import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

class AnimatedLoader extends StatefulWidget {
  const AnimatedLoader({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => AnimatedLoaderState();
}

class AnimatedLoaderState extends State<AnimatedLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _animationController.addListener(() => setState(() {}));
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final percentage = _animationController.value * 100;
    return Center(
      child: LiquidCustomProgressIndicator(
        value: _animationController.value,
        direction: Axis.vertical,
        backgroundColor: Colors.amber,
        valueColor: AlwaysStoppedAnimation(Colors.deepPurple),
        shapePath: loaderPath(),
        // center: Text(
        //   '${percentage.toStringAsFixed(0)}%',
        //   style: TextStyle(
        //     color: Colors.lightGreenAccent,
        //     fontSize: 20.0,
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),
      ),
    );
  }

  loaderPath() {
    Size size = Size(60, 60);

    Path path = Path();
    path.lineTo(size.width * 0.45, size.height * 0.11);
    path.cubicTo(size.width * 0.4, size.height * 0.12, size.width * 0.35,
        size.height * 0.15, size.width * 0.31, size.height / 5);
    path.cubicTo(size.width * 0.31, size.height / 5, size.width * 0.28,
        size.height * 0.24, size.width * 0.28, size.height * 0.24);
    path.cubicTo(size.width * 0.28, size.height * 0.24, size.width / 4,
        size.height * 0.23, size.width / 4, size.height * 0.23);
    path.cubicTo(size.width * 0.23, size.height * 0.22, size.width * 0.19,
        size.height * 0.23, size.width * 0.16, size.height * 0.24);
    path.cubicTo(size.width * 0.09, size.height * 0.26, size.width * 0.03,
        size.height * 0.32, size.width * 0.02, size.height * 0.4);
    path.cubicTo(0, size.height * 0.48, size.width * 0.02, size.height * 0.57,
        size.width * 0.07, size.height * 0.63);
    path.cubicTo(size.width * 0.1, size.height * 0.67, size.width * 0.14,
        size.height * 0.69, size.width * 0.19, size.height * 0.71);
    path.cubicTo(size.width * 0.19, size.height * 0.71, size.width / 5,
        size.height * 0.71, size.width / 5, size.height * 0.71);
    path.cubicTo(size.width / 5, size.height * 0.71, size.width / 5,
        size.height * 0.86, size.width / 5, size.height * 0.86);
    path.cubicTo(size.width / 5, size.height, size.width / 5, size.height,
        size.width / 5, size.height * 1.02);
    path.cubicTo(size.width * 0.23, size.height * 1.04, size.width * 0.26,
        size.height * 1.07, size.width * 0.3, size.height * 1.08);
    path.cubicTo(size.width * 0.3, size.height * 1.08, size.width * 0.31,
        size.height * 1.08, size.width * 0.31, size.height * 1.08);
    path.cubicTo(size.width * 0.31, size.height * 1.08, size.width * 0.31,
        size.height * 1.03, size.width * 0.31, size.height * 1.03);
    path.cubicTo(size.width * 0.31, size.height, size.width * 0.31,
        size.height * 0.95, size.width * 0.31, size.height * 0.91);
    path.cubicTo(size.width * 0.31, size.height * 0.91, size.width * 0.31,
        size.height * 0.84, size.width * 0.31, size.height * 0.84);
    path.cubicTo(size.width * 0.31, size.height * 0.84, size.width * 0.3,
        size.height * 0.82, size.width * 0.3, size.height * 0.82);
    path.cubicTo(size.width * 0.27, size.height * 0.77, size.width * 0.27,
        size.height * 0.75, size.width * 0.27, size.height * 0.67);
    path.cubicTo(size.width * 0.27, size.height * 0.54, size.width * 0.29,
        size.height * 0.47, size.width * 0.32, size.height * 0.44);
    path.cubicTo(size.width / 3, size.height * 0.44, size.width * 0.34,
        size.height * 0.44, size.width * 0.35, size.height * 0.45);
    path.cubicTo(size.width * 0.35, size.height * 0.46, size.width * 0.35,
        size.height * 0.58, size.width * 0.35, size.height * 0.78);
    path.cubicTo(size.width * 0.35, size.height * 0.78, size.width * 0.35,
        size.height * 1.09, size.width * 0.35, size.height * 1.09);
    path.cubicTo(size.width * 0.35, size.height * 1.09, size.width * 0.36,
        size.height * 1.09, size.width * 0.36, size.height * 1.09);
    path.cubicTo(size.width * 0.38, size.height * 1.1, size.width * 0.44,
        size.height * 1.1, size.width * 0.46, size.height * 1.1);
    path.cubicTo(size.width * 0.46, size.height * 1.1, size.width * 0.47,
        size.height * 1.1, size.width * 0.47, size.height * 1.1);
    path.cubicTo(size.width * 0.47, size.height * 1.1, size.width * 0.47,
        size.height * 1.03, size.width * 0.47, size.height * 1.03);
    path.cubicTo(size.width * 0.48, size.height * 0.93, size.width * 0.48,
        size.height * 0.78, size.width * 0.48, size.height * 0.75);
    path.cubicTo(size.width * 0.48, size.height * 0.73, size.width * 0.47,
        size.height * 0.72, size.width * 0.46, size.height * 0.71);
    path.cubicTo(size.width * 0.44, size.height * 0.7, size.width * 0.44,
        size.height * 0.69, size.width * 0.44, size.height * 0.63);
    path.cubicTo(size.width * 0.44, size.height * 0.58, size.width * 0.45,
        size.height * 0.47, size.width * 0.45, size.height * 0.45);
    path.cubicTo(size.width * 0.45, size.height * 0.44, size.width * 0.46,
        size.height * 0.56, size.width * 0.46, size.height * 0.63);
    path.cubicTo(size.width * 0.46, size.height * 0.66, size.width * 0.46,
        size.height * 0.67, size.width * 0.46, size.height * 0.67);
    path.cubicTo(size.width * 0.47, size.height * 0.67, size.width * 0.47,
        size.height * 0.64, size.width * 0.47, size.height * 0.52);
    path.cubicTo(size.width * 0.48, size.height * 0.48, size.width * 0.48,
        size.height * 0.45, size.width * 0.48, size.height * 0.44);
    path.cubicTo(size.width * 0.48, size.height * 0.44, size.width * 0.48,
        size.height * 0.46, size.width * 0.48, size.height * 0.49);
    path.cubicTo(size.width * 0.48, size.height * 0.51, size.width * 0.48,
        size.height * 0.56, size.width * 0.48, size.height * 0.6);
    path.cubicTo(size.width * 0.49, size.height * 0.66, size.width * 0.49,
        size.height * 0.67, size.width * 0.49, size.height * 0.67);
    path.cubicTo(size.width / 2, size.height * 0.67, size.width / 2,
        size.height * 0.66, size.width / 2, size.height * 0.6);
    path.cubicTo(size.width / 2, size.height * 0.56, size.width / 2,
        size.height / 2, size.width / 2, size.height * 0.48);
    path.cubicTo(size.width / 2, size.height * 0.42, size.width * 0.51,
        size.height * 0.44, size.width * 0.51, size.height * 0.51);
    path.cubicTo(size.width * 0.52, size.height * 0.65, size.width * 0.52,
        size.height * 0.67, size.width * 0.52, size.height * 0.67);
    path.cubicTo(size.width * 0.53, size.height * 0.67, size.width * 0.53,
        size.height * 0.64, size.width * 0.53, size.height * 0.55);
    path.cubicTo(size.width * 0.53, size.height * 0.48, size.width * 0.53,
        size.height * 0.44, size.width * 0.53, size.height * 0.45);
    path.cubicTo(size.width * 0.54, size.height * 0.48, size.width * 0.55,
        size.height * 0.59, size.width * 0.55, size.height * 0.63);
    path.cubicTo(size.width * 0.55, size.height * 0.69, size.width * 0.54,
        size.height * 0.7, size.width * 0.52, size.height * 0.71);
    path.cubicTo(size.width * 0.51, size.height * 0.72, size.width * 0.51,
        size.height * 0.72, size.width * 0.51, size.height * 0.75);
    path.cubicTo(size.width * 0.51, size.height * 0.79, size.width * 0.51,
        size.height * 0.89, size.width * 0.51, size.height * 1.02);
    path.cubicTo(size.width * 0.51, size.height * 1.02, size.width * 0.52,
        size.height * 1.11, size.width * 0.52, size.height * 1.11);
    path.cubicTo(size.width * 0.52, size.height * 1.11, size.width * 0.57,
        size.height * 1.1, size.width * 0.57, size.height * 1.1);
    path.cubicTo(size.width * 0.6, size.height * 1.1, size.width * 0.63,
        size.height * 1.1, size.width * 0.64, size.height * 1.1);
    path.cubicTo(size.width * 0.64, size.height * 1.1, size.width * 0.66,
        size.height * 1.09, size.width * 0.66, size.height * 1.09);
    path.cubicTo(size.width * 0.66, size.height * 1.09, size.width * 0.66,
        size.height * 1.05, size.width * 0.66, size.height * 1.05);
    path.cubicTo(size.width * 0.67, size.height * 0.96, size.width * 0.67,
        size.height * 0.79, size.width * 0.67, size.height * 0.76);
    path.cubicTo(size.width * 0.67, size.height * 0.73, size.width * 0.67,
        size.height * 0.73, size.width * 0.65, size.height * 0.73);
    path.cubicTo(size.width * 0.64, size.height * 0.72, size.width * 0.62,
        size.height * 0.69, size.width * 0.61, size.height * 0.67);
    path.cubicTo(size.width * 0.6, size.height * 0.65, size.width * 0.6,
        size.height * 0.64, size.width * 0.6, size.height * 0.61);
    path.cubicTo(size.width * 0.6, size.height * 0.55, size.width * 0.62,
        size.height * 0.49, size.width * 0.65, size.height * 0.45);
    path.cubicTo(size.width * 0.66, size.height * 0.44, size.width * 0.67,
        size.height * 0.44, size.width * 0.68, size.height * 0.44);
    path.cubicTo(size.width * 0.7, size.height * 0.44, size.width * 0.7,
        size.height * 0.44, size.width * 0.71, size.height * 0.45);
    path.cubicTo(size.width * 0.73, size.height * 0.47, size.width * 0.75,
        size.height / 2, size.width * 0.76, size.height * 0.54);
    path.cubicTo(size.width * 0.77, size.height * 0.58, size.width * 0.77,
        size.height * 0.59, size.width * 0.77, size.height * 0.62);
    path.cubicTo(size.width * 0.77, size.height * 0.65, size.width * 0.76,
        size.height * 0.66, size.width * 0.76, size.height * 0.68);
    path.cubicTo(size.width * 0.74, size.height * 0.7, size.width * 0.73,
        size.height * 0.72, size.width * 0.71, size.height * 0.73);
    path.cubicTo(size.width * 0.71, size.height * 0.73, size.width * 0.7,
        size.height * 0.73, size.width * 0.7, size.height * 0.73);
    path.cubicTo(size.width * 0.7, size.height * 0.73, size.width * 0.7,
        size.height * 0.86, size.width * 0.7, size.height * 0.86);
    path.cubicTo(size.width * 0.7, size.height * 0.94, size.width * 0.7,
        size.height * 1.02, size.width * 0.71, size.height * 1.04);
    path.cubicTo(size.width * 0.71, size.height * 1.04, size.width * 0.71,
        size.height * 1.08, size.width * 0.71, size.height * 1.08);
    path.cubicTo(size.width * 0.71, size.height * 1.08, size.width * 0.72,
        size.height * 1.08, size.width * 0.72, size.height * 1.08);
    path.cubicTo(size.width * 0.75, size.height * 1.07, size.width * 0.79,
        size.height * 1.04, size.width * 0.81, size.height * 1.02);
    path.cubicTo(size.width * 0.81, size.height, size.width * 0.81, size.height,
        size.width * 0.81, size.height * 0.86);
    path.cubicTo(size.width * 0.81, size.height * 0.86, size.width * 0.82,
        size.height * 0.71, size.width * 0.82, size.height * 0.71);
    path.cubicTo(size.width * 0.82, size.height * 0.71, size.width * 0.83,
        size.height * 0.71, size.width * 0.83, size.height * 0.71);
    path.cubicTo(size.width * 0.88, size.height * 0.69, size.width * 0.92,
        size.height * 0.67, size.width * 0.95, size.height * 0.63);
    path.cubicTo(size.width, size.height * 0.57, size.width * 1.02,
        size.height * 0.48, size.width, size.height * 0.4);
    path.cubicTo(size.width, size.height * 0.34, size.width * 0.95,
        size.height * 0.28, size.width * 0.9, size.height / 4);
    path.cubicTo(size.width * 0.85, size.height * 0.23, size.width * 0.8,
        size.height * 0.22, size.width * 0.76, size.height * 0.23);
    path.cubicTo(size.width * 0.76, size.height * 0.23, size.width * 0.74,
        size.height * 0.24, size.width * 0.74, size.height * 0.24);
    path.cubicTo(size.width * 0.74, size.height * 0.24, size.width * 0.71,
        size.height / 5, size.width * 0.71, size.height / 5);
    path.cubicTo(size.width * 0.67, size.height * 0.15, size.width * 0.62,
        size.height * 0.12, size.width * 0.56, size.height * 0.11);
    path.cubicTo(size.width * 0.53, size.height * 0.1, size.width * 0.48,
        size.height * 0.1, size.width * 0.45, size.height * 0.11);
    path.cubicTo(size.width * 0.45, size.height * 0.11, size.width * 0.45,
        size.height * 0.11, size.width * 0.45, size.height * 0.11);
    path.lineTo(size.width * 0.45, size.height * 0.11);
    path.close();

    return path;
  }
}
