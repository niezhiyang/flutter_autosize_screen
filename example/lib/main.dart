import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_autosize_screen/auto_size_util.dart';
import 'package:flutter_autosize_screen/temp.dart';


void main() {

  AutoSizeUtil.screenWidth = 360;
  runAutoSizeApp(const MyApp());
  // runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      builder: AutoSizeUtil.appBuilder,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        bottomNavigationBar: _bottomNavigationBar(),
        body: MyHomePage(title: "lallla"),
      ),
    );
  }

  BottomNavigationBar _bottomNavigationBar() {
    return BottomNavigationBar(
      // BottomNavigationBarType 中定义的类型，有 fixed 和 shifting 两种类型
      type: BottomNavigationBarType.fixed,

      // BottomNavigationBarItem 中 icon 的大小
      iconSize: 24,

      // 当前所高亮的按钮index
      currentIndex: 1,

      // 点击里面的按钮的回调函数，参数为当前点击的按钮 index
      onTap: (position) {},

      // 如果 type 类型为 fixed，则通过 fixedColor 设置选中 item 的颜色
      items: _buildItem(),
      unselectedItemColor: Colors.grey,
    );
  }

  List<BottomNavigationBarItem> _buildItem() {
    var array = <BottomNavigationBarItem>[];

    for (int i = 0; i < 5; i++) {
      BottomNavigationBarItem item = BottomNavigationBarItem(
        icon: Icon(

          Icons.favorite,
        ),
        label: "大哥大",
      );
      array.add(item);
    }
    return array;
  }
}

class Demo extends StatelessWidget {
  const Demo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MaterialButton(
        child: Text("第一页"),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return MyHomePage(title: "lallla");
          }));
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey _keyGreen = GlobalKey();
  GlobalKey _keyBlue = GlobalKey();
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

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
    print("MediaQuery    ${MediaQuery.of(context).size.width} ---- ${MediaQuery.of(context).size.height} --- ${MediaQuery.of(context).devicePixelRatio}");
    print("window   ${window.physicalSize/window.devicePixelRatio}  -- -- ${window.devicePixelRatio}");
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                  child: Container(
                    key: _keyGreen,
                    height: 180,
                    color: Colors.redAccent,
                    child:  Text("window   ${window.physicalSize/window.devicePixelRatio}  -- -- ${window.devicePixelRatio}"),
                  )),
              VerticalDivider(
                width: 1,
                color: Colors.black,
              ),
              Expanded(
                  child: Container(
                    height: 180,
                    color: Colors.blue,
                  )),
            ],
          ),
          Container(
            key: _keyBlue,
            width: 180,
            height: 180,
            color: Colors.redAccent,
            child: Text("MediaQuery    ${MediaQuery.of(context).size.width} ---- ${MediaQuery.of(context).size.height} --- ${MediaQuery.of(context).devicePixelRatio}"),
          ),
          Text("MediaQuery    ${MediaQuery.of(context).size.width} ---- ${MediaQuery.of(context).size.height} --- ${MediaQuery.of(context).devicePixelRatio}"),
          Text("window   ${window.physicalSize/window.devicePixelRatio}  -- -- ${window.devicePixelRatio}"),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'You have pushed the button this many times:',
                ),
                Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
