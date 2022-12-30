import 'package:flutter/material.dart';

class StartSceen extends StatelessWidget {
  const StartSceen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment(0, -0.2),
        child: Container(
            child: Text("点击开始游戏",
                style: TextStyle(fontSize: 48, color: Colors.green))));
  }
}