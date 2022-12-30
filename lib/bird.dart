import 'package:flutter/material.dart';

enum Direction { Up, Down }
const double birdX = -0.9;
const double birdSize = 40;

class Bird extends StatelessWidget {
  const Bird({
    Key? key,
    required this.birdY,
  }) : super(key: key);

  final double birdY;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        duration: Duration(milliseconds: 0),
        curve: Curves.linear,
        alignment: Alignment(birdX, birdY),
        child: Container(
            width: birdSize,
            height: birdSize,
            child: Image.asset("assets/images/bird.png")));
  }
}