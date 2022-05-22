import 'dart:async';
import 'dart:collection';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'auto_size_util.dart';

void runAutoApp(Widget app) {
  AutoWidgetsFlutterBinding.ensureInitialized()
    ..scheduleAttachRootWidget(app)
    ..scheduleWarmUpFrame();
}

class AutoWidgetsFlutterBinding extends WidgetsFlutterBinding {
  static WidgetsBinding ensureInitialized() {
    AutoWidgetsFlutterBinding();
    return WidgetsBinding.instance;
  }

  @override
  ViewConfiguration createViewConfiguration() {
    var queryData = MediaQueryData.fromWindow(window);
    if (queryData.size.shortestSide < 600) {
      window.onPointerDataPacket = _handlePointerDataPacket;
      return ViewConfiguration(
        size: AutoSizeUtil.getSize(),
        devicePixelRatio: AutoSizeUtil.getDevicePixelRatio(),
      );
    } else {
      return super.createViewConfiguration();
    }
  }

  /// 因为修改了 devicePixelRatio ，得适配点击事件  GestureBinding
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
    var width = MediaQueryData.fromWindow(window).size.shortestSide;
    _pendingPointerEvents.addAll(PointerEventConverter.expand(
        packet.data,
        // 适配事件的转换比率,采用我们修改的
        width < 600
            ? AutoSizeUtil.getDevicePixelRatio()
            : window.devicePixelRatio));
    if (!locked) _flushPointerEventQueue();
  }

  @override
  void cancelPointer(int pointer) {
    if (_pendingPointerEvents.isEmpty && !locked) {
      scheduleMicrotask(_flushPointerEventQueue);
    }
    _pendingPointerEvents.addFirst(PointerCancelEvent(pointer: pointer));
  }

  void _flushPointerEventQueue() {
    assert(!locked);
    while (_pendingPointerEvents.isNotEmpty) {
      handlePointerEvent(_pendingPointerEvents.removeFirst());
    }
  }
}
