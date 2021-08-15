import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_autosize_screen/auto_size_util.dart';
import 'package:flutter_autosize_screen/binding.dart';

void main() {
  AutoSizeUtil.setStandard(360);
  runAutoApp(const MyApp());
  // runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Autosize Demo',
      builder: AutoSizeUtil.appBuilder,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextStyle _style = TextStyle(color: Colors.white);
  GlobalKey _keyGreen = GlobalKey();
  GlobalKey _keyBlue = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      var renderBox = _keyGreen.currentContext!.findRenderObject()!.paintBounds;
      var sizeGreen = renderBox.size;
      print("${sizeGreen.width} ----- ${sizeGreen.height}");

      var renderBlu = _keyBlue.currentContext!.findRenderObject()!.paintBounds;
      var sizeBlue = renderBlu.size;
      print("${sizeBlue.width} ----- ${sizeBlue.height}");
    });
  }

  @override
  Widget build(BuildContext context) {
    var originalSize = window.physicalSize / window.devicePixelRatio;
    var nowDevicePixelRatio = MediaQuery.of(context).devicePixelRatio;

    return Scaffold(
      appBar: AppBar(
        title: Text("Autosize Demo"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                    child: Container(
                  alignment: Alignment.center,
                  key: _keyGreen,
                  height: 60,
                  color: Colors.redAccent,
                  child: Text(
                    "使用Expanded平分屏幕",
                    style: _style,
                  ),
                )),
                Expanded(
                    child: Container(
                  alignment: Alignment.center,
                  height: 60,
                  color: Colors.blue,
                  child: Text(
                    "使用Expanded平分屏幕",
                    style: _style,
                  ),
                )),
              ],
            ),
            Row(
              children: [
                Container(
                  alignment: Alignment.center,
                  key: _keyBlue,
                  width: 180,
                  height: 60,
                  color: Colors.teal,
                  child: Text(
                    "宽度写的是 180",
                    style: _style,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: 180,
                  height: 60,
                  color: Colors.grey,
                  child: Text(
                    "宽度写的是 180",
                    style: _style,
                  ),
                ),
              ],
            ),
            Container(
              alignment: Alignment.center,
              width: 360,
              height: 60,
              color: Colors.purple,
              child: Text(
                "宽度写的是 360",
                style: _style,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Text("原始的 size: $originalSize "),
            Text("原始的 分辨率: ${window.physicalSize} "),
            Text("原始的 devicePixelRatio: ${window.devicePixelRatio} "),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              alignment: Alignment.center,
              width: 360,
              height: 10,
              color: Colors.grey,
            ),
            Text("更改后 size: ${MediaQuery.of(context).size}  "),
            Text("更改后 devicePixelRatio: $nowDevicePixelRatio"),
          ],
        ),
      ),
    );
  }
}
