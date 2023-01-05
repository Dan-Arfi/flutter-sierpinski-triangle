import 'dart:ui';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/semantics.dart';

var pixelRatio = window.devicePixelRatio;

//Size in physical pixels
var physicalScreenSize = window.physicalSize;
var physicalWidth = physicalScreenSize.width;
var physicalHeight = physicalScreenSize.height;
bool stopTimer = false;
bool resetTimer = false;
//Size in logical pixels
var logicalScreenSize = window.physicalSize / pixelRatio;
var logicalWidth = logicalScreenSize.width;
var logicalHeight = logicalScreenSize.height;

bool pickedPoint = false;

var points = [Offset(-50, 50),];

var trianleDots = [];

List pointlist = [
  trianleDots[1],
  Offset(logicalWidth / 2, logicalHeight / 2),
];

int index = 0;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double posx = 100.0;
  double posy = 300.0;
  // touch position\

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      print("amongs");
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Color(0xFFf6f7eb),
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                width: 400,
                height: 400,
                child: CustomPaint(
                  painter: OpenPainter(),
                ),
              ),
              GestureDetector(
                onTapDown: (TapDownDetails details) {
                  if (trianleDots.length < 3) {
                    final dx = details.localPosition.dx;
                    final dy = details.localPosition.dy;
                    setState(() {
                      posx = dx;
                      posy = dy;

                      trianleDots.add(Offset(posx, posy));
                      points.add(trianleDots[index]);
                      index += 1;
                      print(trianleDots);
                      print(index);
                    });
                  }
                },
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: 100,
                          height: 50,
                          child: ElevatedButton(
                              onPressed: () {
                                if (trianleDots.length > 2) {
                                  setState(() {
                                    pickedPoint = true;
                                    resetTimer = false;
                                    pointlist[0] =
                                        trianleDots[Random().nextInt(3)];
                                    drawNextDot();
                                    print(points);
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF393e41),
                                elevation: 0,
                              ),
                              child: Text("start")),
                        ),
                        Container(
                          width: 100,
                          height: 50,
                          child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  clear();
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF393e41),
                                elevation: 0,
                                
                              ),
                              child: Text("clear")),
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      );

  void drawNextDot() {
    Timer.periodic(Duration(milliseconds: 1), (timer) {
      if (resetTimer) {
        timer.cancel();
        resetTimer = false;
      } else {
        setState(() {
          Offset newDot = Offset((pointlist[0].dx + pointlist[1].dx) / 2,
              (pointlist[0].dy + pointlist[1].dy) / 2);
          points.add(newDot);

          pointlist[0] = trianleDots[Random().nextInt(3)];
          pointlist[1] = newDot;
        });
      }
    });
  }

  Future clear() async {
    setState(() {
      points = [];
      pointlist = [];
      resetTimer = true;
      pickedPoint = false;
      trianleDots = [];
      pointlist.add(Offset(-100, -100));
      pointlist.add(Offset(logicalWidth / 2, logicalHeight / 2));
      index = 0;
    });
  }
}

// drwaing dots
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Flutter Tutorial - googleflutter.com'),
      backgroundColor: Color(0xFF444444),
    ),
    body: ListView(children: <Widget>[
      Text(
        'Canvas',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20, height: 2),
      ),
      Container(
        width: 400,
        height: 400,
        child: CustomPaint(
          painter: OpenPainter(),
        ),
      ),
    ]),
  );
}

class OpenPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = Color(0xffe94f37)
      ..strokeWidth = 10;
    //list of points

    //draw points on canvas
    canvas.drawPoints(PointMode.points, points, paint1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
