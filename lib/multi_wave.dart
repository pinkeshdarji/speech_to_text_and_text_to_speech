// import 'dart:math';
//
// import 'package:flutter/animation.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart' show timeDilation;
// import 'package:flutter/widgets.dart';
// import 'package:vector_math/vector_math.dart' as Vector;
//
// class MultiWave extends StatefulWidget {
//   final bool isStartAnimating;
//
//   @override
//   _MultiWaveState createState() => new _MultiWaveState();
//
//   MultiWave({Key? key, required this.isStartAnimating}) : super(key: key) {
//     timeDilation = 1.0;
//   }
// }
//
// class _MultiWaveState extends State<MultiWave> {
//   @override
//   Widget build(BuildContext context) {
//     Size size = new Size(MediaQuery.of(context).size.width, 120.0);
//     return Stack(
//       children: <Widget>[
//         Wave(
//           size: size,
//           xOffset: 0,
//           yOffset: 0,
//           color: kColorgrey3.withOpacity(0.2),
//           strokeWidth: 2,
//           isStart: widget.isStartAnimating,
//         ),
//         Wave(
//           size: size,
//           xOffset: 270,
//           yOffset: 7,
//           color: kColorgrey3.withOpacity(0.3),
//           strokeWidth: 2.5,
//           isStart: widget.isStartAnimating,
//         ),
//         Wave(
//           size: size,
//           xOffset: 100,
//           yOffset: 22,
//           color: kColorgrey3.withOpacity(0.5),
//           strokeWidth: 3,
//           isStart: widget.isStartAnimating,
//         ),
//       ],
//     );
//   }
// }
//
// class Wave extends StatefulWidget {
//   final Size size;
//   final int xOffset;
//   final int yOffset;
//   final Color color;
//   final double strokeWidth;
//   final bool isStart;
//
//   Wave(
//       {Key key,
//       @required this.size,
//       this.xOffset,
//       this.yOffset,
//       this.color,
//       this.strokeWidth,
//       this.isStart})
//       : super(key: key);
//
//   @override
//   State<StatefulWidget> createState() {
//     return new _WaveState();
//   }
// }
//
// class _WaveState extends State<Wave> with TickerProviderStateMixin {
//   AnimationController animationController;
//   List<Offset> animList1 = [];
//
//   @override
//   void initState() {
//     super.initState();
//
//     animationController = new AnimationController(
//         vsync: this, duration: new Duration(milliseconds: 1000));
//
//     animationController.addListener(() {
//       animList1.clear();
//       for (int i = -2 - widget.xOffset;
//           i <= widget.size.width.toInt() + 2;
//           i++) {
//         animList1.add(new Offset(
//             i.toDouble() + widget.xOffset,
//             sin((animationController.value * 360 - i) %
//                         360 *
//                         Vector.degrees2Radians) *
//                     20 +
//                 50 +
//                 widget.yOffset));
//       }
//     });
//     animationController.reset();
//   }
//
//   @override
//   void dispose() {
//     animationController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     widget.isStart ? animationController.repeat() : animationController.stop();
//     return new Container(
//       alignment: Alignment.center,
//       child: new AnimatedBuilder(
//         animation: new CurvedAnimation(
//           parent: animationController,
//           curve: Curves.easeInOut,
//         ),
//         builder: (context, child) => CustomPaint(
//           painter: WavePainter(animationController.value, animList1,
//               widget.color, widget.strokeWidth),
//           child: Container(
//             height: 100,
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class WavePainter extends CustomPainter {
//   final double animation;
//   final Color color;
//   final double strokeWidth;
//
//   List<Offset> waveList1 = [];
//
//   WavePainter(this.animation, this.waveList1, this.color, this.strokeWidth);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     // Draw the shadow first
//     Paint paint = Paint()
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = strokeWidth + 5
//       ..color = color.withOpacity(0.1)
//       ..maskFilter = MaskFilter.blur(BlurStyle.normal, 10);
//     Path path = new Path();
//     path.addPolygon(waveList1, false);
//     canvas.drawPath(path, paint);
//
//     // Draw the actual path
//     Paint paint2 = Paint()
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = strokeWidth
//       ..color = color;
//     Path path2 = new Path();
//     path2.addPolygon(waveList1, false);
//     canvas.drawPath(path2, paint2);
//   }
//
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => this != oldDelegate;
// }
