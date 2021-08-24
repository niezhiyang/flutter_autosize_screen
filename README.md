
### A low-cost Flutter screen adaptation solution（一个极低成本的 Flutter 屏幕适配方案）
### 100% 还原 UI，只需要按照设计图写的宽高写即可
# 先看图片，设置的标准宽度是 360
###  iPhone 8 ------------------------------- iPhone 11 :
<div >
   <img style="vertical-align: top;" src="https://github.com/niezhiyang/flutter_autosize_screen/blob/master/art/iPhone%208.png?raw=true" width="40%" div align=top>
   <img style="vertical-align: top;" src="https://github.com/niezhiyang/flutter_autosize_screen/blob/master/art/iPhone%2011.png?raw=true" width="40%" >
</div>

###  iPhone 12 pro max  ---------------------  ipad air :
<div >
   <img src="https://github.com/niezhiyang/flutter_autosize_screen/blob/master/art/iPhone%2012.png?raw=true" width="40%" div align=top>
   <img src="https://github.com/niezhiyang/flutter_autosize_screen/blob/master/art/iPad%20Air.png?raw=true" width="40%" div align=top >
</div>

## android 图
### 768x1280-320dpi----------10801920-420dpi----------1440x2560-560dpi
<div >
   <img src="https://github.com/niezhiyang/flutter_autosize_screen/blob/master/art/768*1280-320dpi.png?raw=true" width="30%" div align=top>
   <img src="https://github.com/niezhiyang/flutter_autosize_screen/blob/master/art/1080*1920-420dpi.png?raw=true" width="30%" div align=top >
   <img src="https://github.com/niezhiyang/flutter_autosize_screen/blob/master/art/1440*2560-560dpi.png?raw=true" width="30%" div align=top >
</div>

## web 图
随着拉长屏幕 ，慢慢的 宽度会大于高度，当大于的时候 ，会以 高度 为 基准。
<div >
   <img src="https://github.com/niezhiyang/flutter_autosize_screen/blob/master/art/web.gif?raw=true">
</div>

## 使用
### 引用
```dart
flutter_autosize_screen: ^{LAST_VERSION}
```
### 初始化
1. 在main方法的第一行就初始化，下面的基准一般以宽度为基准，直接写Ui设计图的宽度尺寸，如果是横屏的状态的 下面的 360 就是以高度为基准
```dart
void main() {
  // 设置基准 , isAutoTextSize 表示文字是否随着系统的字体大小更改而更改，默认是 true
  AutoSizeUtil.setStandard(360,isAutoTextSize: true);

  // 使用 runAutoApp 来代替 runApp
  // import 'package:flutter_autosize_screen/binding.dart';
  runAutoApp(const MyApp());

}

```
2. 替换根 MaterialApp 的 MediaQuery
```dart
MaterialApp(
      title: 'Autosize Demo',
      /// 替换，这样可以在以后 使用 MediaQuery.of(context) 得到 正确的Size
      builder: AutoSizeUtil.appBuilder,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: HomePage(),
      ),
    )

```
3. 获取Size
```dart
AutoSizeUtil.getScreenSize()
//或者
MediaQuery.of(context).size
```
4. 直接按照设计图的尺寸写即可
```dart
Container(
    alignment: Alignment.center,
    height: 60,
    width :60,
    color: Colors.redAccent,
    child: Text(
      "直接按照设计图写尺寸",
    ),
  )
```
5. 切记
不能使用 window 获取 size 或者是 获取  MediaQuery<br>
~~window.physicalSize~~<br>
~~MediaQueryData.fromWindow(window)~~<br>

## 下一个目标
因为从根修改了屏幕宽高, 会引起一些系统Widget，有可能比正常的大或者小，比如toorbar的高度默认是 kToolbarHeight = 56.0，这样如果把宽度标准设置成112的话，那这kToolbarHeight就会显得很高，
还有 Text （bodyText2） 默认的是 14，也会非常大，所以 下一个计划是 还原一下默认的系统 widget。大家有好的建议 也可以提给我

## 原理
[掘进](https://juejin.cn/post/6996924953320751134)
## Thank
[FlutterTest](https://github.com/genius158/FlutterTest)




