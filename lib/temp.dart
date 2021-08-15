import 'dart:async';
import 'dart:collection';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'auto_size_util.dart';

class AutoSizeWidgetsFlutterBinding extends WidgetsFlutterBinding {
  static WidgetsBinding? ensureInitialized() {
    if (WidgetsBinding.instance == null) AutoSizeWidgetsFlutterBinding();
    return WidgetsBinding.instance;
  }

  @override
  ViewConfiguration createViewConfiguration() {
    var originalSize = window.physicalSize / window.devicePixelRatio;

    var originalWidth = originalSize.width;
    var originalHeight = originalSize.height;
    AutoSizeUtil.devicePixelRatio =
        window.physicalSize.width / AutoSizeUtil.screenWidth;

    return ViewConfiguration(
      size: Size(AutoSizeUtil.screenWidth,
          originalHeight / ((originalWidth / AutoSizeUtil.screenWidth))),
      // size: AutoSizeUtils.screenSize,
      devicePixelRatio: AutoSizeUtil.devicePixelRatio,
    );
  }

  /// 因为调整了 PixelRatio，所以对于 Event 事件，需要额外对事件的坐标进行对应比例的转换；
  @override
  void initInstances() {
    super.initInstances();
    window.onPointerDataPacket = _handlePointerDataPacket;
  }

  @override
  void unlocked() {
    super.unlocked();
    _flushPointerEventQueue();
  }

  final Queue<PointerEvent> _pendingPointerEvents = Queue<PointerEvent>();

  void _handlePointerDataPacket(PointerDataPacket packet) {
    // Event 事件，需要按比例转换尺寸
    _pendingPointerEvents.addAll(PointerEventConverter.expand(
        packet.data, AutoSizeUtil.devicePixelRatio));
    if (!locked) _flushPointerEventQueue();
  }

  @override
  void cancelPointer(int pointer) {
    if (_pendingPointerEvents.isEmpty && !locked)
      scheduleMicrotask(_flushPointerEventQueue);
    _pendingPointerEvents.addFirst(PointerCancelEvent(pointer: pointer));
  }

  void _flushPointerEventQueue() {
    assert(!locked);
    while (_pendingPointerEvents.isNotEmpty)
      _handlePointerEvent(_pendingPointerEvents.removeFirst());
  }

  final Map<int, HitTestResult> _hitTests = <int, HitTestResult>{};

  void _handlePointerEvent(PointerEvent event) {
    assert(!locked);
    HitTestResult result;
    if (event is PointerDownEvent) {
      assert(!_hitTests.containsKey(event.pointer));
      result = HitTestResult();
      hitTest(result, event.position);
      _hitTests[event.pointer] = result;
    } else if (event is PointerUpEvent || event is PointerCancelEvent) {
      result = _hitTests.remove(event.pointer)!;
    } else if (event.down) {
      result = _hitTests[event.pointer]!;
    } else {
      return; // We currently ignore add, remove, and hover move events.
    }
    if (result != null) dispatchEvent(event, result);
  }
}

/**
 * 提供 WidgetsFlutterBinding 的同名方法
 */
void ensureAutoSizeInitialized() {
  AutoSizeWidgetsFlutterBinding.ensureInitialized();
}

/**
 * 替代 runApp()
 */
void runAutoSizeApp(Widget app) {
  var runAppCallback = () {
    AutoSizeWidgetsFlutterBinding.ensureInitialized()!
      ..scheduleAttachRootWidget(app)
      ..scheduleWarmUpFrame();
  };
  // 屏幕尺寸初始化较晚，此操作可限制在尺寸赋值后继续操作
  if (window.physicalSize.isEmpty) {
    VoidCallback? oldMetricsChanged = window.onMetricsChanged;
    window.onMetricsChanged = () {
      if (!window.physicalSize.isEmpty) {
        if (oldMetricsChanged != null) {
          oldMetricsChanged();
        }
        window.onMetricsChanged = oldMetricsChanged;
        runAppCallback();
      }
    };
  } else {
    runAppCallback();
  }
}
