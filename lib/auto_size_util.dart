import 'dart:ui';

import 'package:flutter/material.dart';

class AutoSizeUtil {
  static double devicePixelRatio = 3.0;

  static double screenWidth = 300;

  static double screenHeight = 800;

  /// 根据设置 的 宽度 来得到 devicePixelRatio
  static double getDevicePixelRatio() {
    devicePixelRatio = window.physicalSize.width / AutoSizeUtil.screenWidth;
    return devicePixelRatio;
  }

  /// 根据设置的宽度，来得到对应的高度
  static Size getSize() {
    screenHeight = window.physicalSize.height / getDevicePixelRatio();
    return Size(screenWidth, screenHeight);
  }

  static Widget appBuilder(BuildContext context, Widget? widget) {
    return MediaQuery(
      // 这里如果设置 textScaleFactor = 1.0 ，就不会随着系统字体大小去改变了
      data: MediaQuery.of(context).copyWith(
          size: Size(AutoSizeUtil.screenWidth, AutoSizeUtil.screenHeight),
          devicePixelRatio: AutoSizeUtil.devicePixelRatio,
          textScaleFactor: 1.0),
      child: Theme(
        data: Theme.of(context).copyWith(),
        child: widget!,
      ),
    );
  }
}
