import 'dart:async';

import 'package:flappybird/pipe.dart';
import 'package:flappybird/scoreboard.dart';
import 'package:flappybird/start.dart';
import 'package:flutter/material.dart';

import 'bird.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'ssy'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({Key? key, this.title = ''}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

const double gapSize = 1;
const double initPipeOneX = 0.2;
const double initPipeTwoX = 0.9;

class _MyHomePageState extends State<MyHomePage> {
  double birdY = 0;
  double birdYLastTime = 0;
  bool isRunning = false;
  double pipeSize = 200;
  double pipeOneX = initPipeOneX;
  double gapOneCenter = 0.2;
  double gapTwoCenter = 0;
  double pipeTwoX = initPipeTwoX;
  Direction birdDirection = Direction.Down;
  int score = 0;
  double time = 0;

  void initGameState(bool isGameOver) {
    setState(() {
      isRunning = !isGameOver;
      pipeOneX = initPipeOneX;
      pipeTwoX = initPipeTwoX;
      birdY = 0;
      birdYLastTime = 0;
      time = 0;
      score = 0;
    });
  }

  bool checkCrash(double center, pipeX) {
    final double deltaWidth =
        (pipWidth + birdSize) / MediaQuery.of(context).size.width;

    if (pipeX <= birdX + deltaWidth) {
      if ((birdY > (center + gapSize / 2)) ||
          (birdY < (center - gapSize / 2))) {
        return true;
      }
    } else if (birdY >= 1) {
      return true;
    }

    return false;
  }

  Timer createTimer() {
    const double g = 9.8;

    return Timer.periodic(Duration(milliseconds: 50), (timer) {
      final double newPipeOneX = pipeOneX - 0.01;
      final double newPipeTwoX = pipeTwoX - 0.01;
      bool isCrash = false;

      time += 0.02;
      // -(gt^2) / 2 + vt
      birdY = -(g / 2) * time * time + 1 * time;
      setState(() {
        birdY = birdYLastTime - birdY;
      });

      isCrash = checkCrash(gapOneCenter, pipeOneX);
      isCrash |= checkCrash(gapTwoCenter, pipeTwoX);

      if (newPipeOneX <= -1 || newPipeTwoX <= -1) {
        setState(() {
          score += 1;
        });
      }

      if (isCrash == true) {
        initGameState(true);

        timer.cancel();
      } else {
        setState(() {
          pipeOneX = newPipeOneX < -1 ? 1.3 : newPipeOneX;
          pipeTwoX = newPipeTwoX < -1 ? 1.3 : newPipeTwoX;
        });
      }
    });
  }

  startGame() {
    initGameState(false);

    createTimer();
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 3 / 4;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: GestureDetector(
          onTap: () {
            setState(() {
              birdYLastTime = birdY;
              time = 0;
            });
          },
          child: Container(
            color: Colors.white,
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                        flex: 3,
                        child: Stack(children: [
                          Pipe(
                              pipeX: pipeOneX,
                              pipeY: -1,
                              pipeSize: maxHeight *
                                  (gapOneCenter - gapSize / 2 + 1) /
                                  2),
                          Pipe(
                              pipeX: pipeOneX,
                              pipeY: 1,
                              pipeSize: maxHeight *
                                  (1 - (gapOneCenter + gapSize / 2)) /
                                  2),
                          Pipe(
                              pipeX: pipeTwoX,
                              pipeY: -1,
                              pipeSize: maxHeight *
                                  (gapTwoCenter - gapSize / 2 + 1) /
                                  2),
                          Pipe(
                              pipeX: pipeTwoX,
                              pipeY: 1,
                              pipeSize: maxHeight *
                                  (1 - (gapTwoCenter + gapSize / 2)) /
                                  2),
                          Bird(
                            birdY: birdY,
                          ),
                        ])),
                    Expanded(
                        flex: 1,
                        child: ScoreBoard(
                          curScore: score,
                        ))
                  ],
                ),
                if (isRunning == false)
                  GestureDetector(
                    onTap: () {
                      startGame();
                    },
                    child: StartSceen(),
                  )
              ],
            ),
          )),
      backgroundColor: Colors.white,
    );
  }
}