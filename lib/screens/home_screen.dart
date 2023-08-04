import 'dart:async';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // oneCycle 시간 리스트
  static var numList = [900, 1200, 1500, 1800, 2100];
  // static var numList = [15, 20, 25, 30, 35];
  // 휴식
  static var restTime = 300;
  // static var restTime = 5;
  static var oneCycle = numList[2];
  int totalSeconds = oneCycle;
  int totalRestSeconds = restTime;
  bool isRunning = false;
  bool isRest = false;
  int totalPomodoros = 0;
  int goalPomodoros = 0;
  int totalRest = 0;
  late Timer timer;

  // '분'을 '초'로 바꾸는 버튼용
  // bool typeSecend = false;

  // '분'을 '초'로 바꾸는 버튼용
  // void changeSeconed() {
  //   setState(() {
  //     numList = [15, 20, 25, 30, 35];
  //     restTime = 5;
  //     typeSecend = true;
  //   });
  // }

  void onTick(Timer timer) {
    if (totalSeconds == 0) {
      setState(() {
        totalPomodoros += 1;
        if (goalPomodoros == 11 && totalPomodoros == 4) {
          totalPomodoros = 0;
          goalPomodoros = 0;
        } else if (totalPomodoros == 4) {
          goalPomodoros += 1;
          totalPomodoros = 0;
        }
        isRunning = false;
        isRest = true;
        totalSeconds = oneCycle;
      }); //25분이 다 되면 pomodoros 1씩 증가, 다시 25분 초기화
      timer.cancel(); //타이머가 0이 되면 타이머 취소
      if (isRest) {
        onRestTick;
      }
    } else {
      setState(() {
        totalSeconds = totalSeconds - 1;
      });
    }
  }

  void onRestTick(Timer timer) {
    if (totalRestSeconds == 0) {
      setState(() {
        totalRest += 1;
        isRest = false;
        totalRestSeconds = restTime;
      }); // 휴식 끝나면 초기화
      timer.cancel();
    } else {
      setState(() {
        totalRestSeconds -= 1;
      });
    }
  }

  void onStartPressed() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      onTick,
    );
    setState(() {
      isRunning = true;
    });
  }

  onRestStartPressed() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      onRestTick,
    );
    setState(() {
      // isRunning = false;
    });
  }

  void onPausePressed() {
    timer.cancel();
    setState(() {
      isRunning = false;
    });
  }

  void onRestPausePressed() {
    timer.cancel();
    setState(() {
      isRest = false;
    });
  }

  void refresh() {
    if (isRunning) {
      timer.cancel();
    }
    if (isRest) {
      timer.cancel();
    }
    setState(() {
      isRunning = false;
      isRest = false;
      totalSeconds = oneCycle;
      totalRestSeconds = restTime;
    });
  }

  void onFifteen() {
    setState(() {
      oneCycle = numList[0];
      refresh();
    });
  }

  void onTwenty() {
    setState(() {
      oneCycle = numList[1];
      refresh();
    });
  }

  void onTwentyFive() {
    setState(() {
      oneCycle = numList[2];
      refresh();
    });
  }

  void onThirty() {
    setState(() {
      oneCycle = numList[3];
      refresh();
    });
  }

  void onThirtyFive() {
    setState(() {
      oneCycle = numList[4];
      refresh();
    });
  }

  String format(int seconds) {
    var duration = Duration(seconds: seconds);
    return duration.toString().split('.').first.substring(2, 7);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              flex: 1,
              child: Container(
                alignment: Alignment.bottomCenter,
                child: Text(
                  isRest ? format(totalRestSeconds) : format(totalSeconds),
                  style: TextStyle(
                    color: Theme.of(context).cardColor,
                    fontSize: 89,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: onFifteen,
                      child: Text(
                        '15',
                        style: TextStyle(
                          fontSize: 25,
                          color: Theme.of(context).cardColor,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: onTwenty,
                      child: Text(
                        '20',
                        style: TextStyle(
                          fontSize: 25,
                          color: Theme.of(context).cardColor,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: onTwentyFive,
                      child: Text(
                        '25',
                        style: TextStyle(
                          fontSize: 25,
                          color: Theme.of(context).cardColor,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: onThirty,
                      child: Text(
                        '30',
                        style: TextStyle(
                          fontSize: 25,
                          color: Theme.of(context).cardColor,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: onThirtyFive,
                      child: Text(
                        '35',
                        style: TextStyle(
                          fontSize: 25,
                          color: Theme.of(context).cardColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 3,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: isRest
                      ? [
                          Text(
                            'Rest Time',
                            style: TextStyle(
                              fontSize: 25,
                              color: Theme.of(context).cardColor,
                            ),
                          ),
                          IconButton(
                            iconSize: 120,
                            color: Theme.of(context).cardColor,
                            onPressed: (totalRestSeconds != restTime)
                                ? refresh
                                : onRestStartPressed,
                            icon: Icon((totalRestSeconds != restTime)
                                ? Icons.stop_circle_outlined
                                : Icons.play_circle_outlined),
                          ),
                          IconButton(
                            iconSize: 60,
                            color: Theme.of(context).cardColor,
                            onPressed: refresh,
                            icon: const Icon(Icons.restore),
                          ),
                        ]
                      : [
                          Text(
                            'Pomodoro Time',
                            style: TextStyle(
                              fontSize: 25,
                              color: Theme.of(context).cardColor,
                            ),
                          ),
                          IconButton(
                            iconSize: 120,
                            color: Theme.of(context).cardColor,
                            onPressed: isRunning
                                ? onPausePressed
                                : onStartPressed, //(){}
                            icon: Icon(isRunning
                                ? Icons.pause_circle_outline
                                : Icons.play_circle_outlined),
                          ),
                          IconButton(
                            iconSize: 60,
                            color: Theme.of(context).cardColor,
                            onPressed: refresh,
                            icon: const Icon(Icons.restore),
                          ),
                        ],
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(50),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Round',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context)
                                              .textTheme
                                              .displayLarge!
                                              .color,
                                        ),
                                      ),
                                      Text(
                                        '$totalPomodoros / 4',
                                        style: TextStyle(
                                          fontSize: 58,
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context)
                                              .textTheme
                                              .displayLarge!
                                              .color,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Goal',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context)
                                              .textTheme
                                              .displayLarge!
                                              .color,
                                        ),
                                      ),
                                      Text(
                                        '$goalPomodoros / 12',
                                        style: TextStyle(
                                          fontSize: 58,
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context)
                                              .textTheme
                                              .displayLarge!
                                              .color,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
