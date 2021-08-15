import 'dart:ui';

import 'package:flutter/material.dart';

class AutoSizeUtil {
  static double _devicePixelRatio = 3.0;

  static double _screenWidth = 300;

  static double _screenHeight = 800;

  static double _screenStandard = 360;

  /// 如果是横屏 就以高度为基准
  /// 如果是竖屏 就以宽度为基准
  static void setStandard(double standard) {
    _screenStandard = standard;
  }

  /// 根据设置 的 宽度 来得到 devicePixelRatio
  static double getDevicePixelRatio() {
    var originalSize = window.physicalSize / window.devicePixelRatio;
    var originalWidth = originalSize.width;
    var originalHeight = originalSize.height;
    if (originalHeight > originalWidth) {
      // 竖屏
      _devicePixelRatio =
          window.physicalSize.width / AutoSizeUtil._screenStandard;
    } else {
      // 横屏
      _devicePixelRatio =
          window.physicalSize.height / AutoSizeUtil._screenStandard;
    }
    return _devicePixelRatio;
  }

  /// 根据设置的宽度，来得到对应的高度
  static Size getSize() {
    // 如果是横屏就已宽度为基准

    var originalSize = window.physicalSize / window.devicePixelRatio;
    var originalWidth = originalSize.width;
    var originalHeight = originalSize.height;
    if (originalHeight > originalWidth) {
      // 竖屏
      _screenHeight = window.physicalSize.height / getDevicePixelRatio();
      _screenWidth = _screenStandard;
      return Size(_screenStandard, _screenHeight);
    } else {
      // 横屏
      _screenWidth = window.physicalSize.width / getDevicePixelRatio();
      _screenHeight = _screenStandard;
      return Size(_screenWidth, _screenStandard);
    }
  }

  static Widget appBuilder(BuildContext context, Widget? widget) {
    return MediaQuery(
      // 这里如果设置 textScaleFactor = 1.0 ，就不会随着系统字体大小去改变了
      data: MediaQuery.of(context).copyWith(
          size: Size(AutoSizeUtil._screenWidth, AutoSizeUtil._screenHeight),
          devicePixelRatio: AutoSizeUtil._devicePixelRatio,
          textScaleFactor: 1.0),
      child: Theme(
        data: Theme.of(context).copyWith(),
        child: widget!,
      ),
    );
  }
}
