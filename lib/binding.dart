import 'dart:async';
import 'dart:collection';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'auto_size_util.dart';


void runAutoApp(Widget app) {
  AutoWidgetsFlutterBinding.ensureInitialized()
    ..scheduleAttachRootWidget(app)
    ..scheduleWarmUpFrame();

  // var runAppCallback = () {
  //   AutoWidgetsFlutterBinding.ensureInitialized()
  //     ..scheduleAttachRootWidget(app)
  //     ..scheduleWarmUpFrame();
  // };
  // // 屏幕尺寸初始化较晚，此操作可限制在尺寸赋值后继续操作
  // if (window.physicalSize.isEmpty) {
  //   VoidCallback? oldMetricsChanged = window.onMetricsChanged;
  //   window.onMetricsChanged = () {
  //     if (!window.physicalSize.isEmpty) {
  //       if (oldMetricsChanged != null) {
  //         oldMetricsChanged();
  //       }
  //       window.onMetricsChanged = oldMetricsChanged;
  //       runAppCallback();
  //     }
  //   };
  // } else {
  //   runAppCallback();
  // }
}


class AutoWidgetsFlutterBinding extends WidgetsFlutterBinding {
  static WidgetsBinding ensureInitialized() {
    if (WidgetsBinding.instance == null) AutoWidgetsFlutterBinding();
    return WidgetsBinding.instance!;
  }

  @override
  ViewConfiguration createViewConfiguration() {
    return ViewConfiguration(
      size: AutoSizeUtil.getSize(),
      devicePixelRatio: AutoSizeUtil.getDevicePixelRatio(),
    );
  }

  ///
  /// 因为修改了 devicePixelRatio ，得适配点击事件  GestureBinding
  /// 修改过的 PixelRatio
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
    _pendingPointerEvents.addAll(PointerEventConverter.expand(
        packet.data,
        // 适配事件的转换比率,采用我们修改的
        AutoSizeUtil.getDevicePixelRatio()));
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
      assert(() {
        if (debugPrintHitTestResults) debugPrint('$event: $result');
        return true;
      }());
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
