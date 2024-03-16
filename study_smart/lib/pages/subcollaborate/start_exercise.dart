// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:study_smart/pages/exercise.dart';
import 'package:study_smart/pages/subcollaborate/create_exercise.dart';
import 'package:study_smart/pages/subcollaborate/edit_exercise_set.dart';
import 'package:study_smart/pages/subcollaborate/run_exercise.dart';
import 'package:study_smart/utils/box.dart';
import 'package:study_smart/utils/get_appbar.dart';
import 'package:study_smart/utils/globals.dart';
import 'package:study_smart/utils/swipe_right_transition.dart';

class StartExercise extends StatefulWidget {
  const StartExercise({Key? key, required this.exer}) : super(key: key);

  final ExerciseSet exer;

  @override
  State<StartExercise> createState() => _StartExerciseState();
}

class _StartExerciseState extends State<StartExercise> {
  /// 0 = no limits
  /// 1 = time
  /// 2 = tasks
  int _modeState = 0;
  int minutes = 1;
  int taskNumber = 1;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: getReturnAppBar(height, true, 'Übung Starten', mainYellowScheme),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                const SizedBox(
                  width: 15,
                ),
                const Text(
                  'Aufgabensatz',
                  style: TextStyle(fontSize: 26),
                ),
                const Expanded(child: SizedBox())
              ]
            ),
            Divider(
              thickness: 1.5,
              indent: 15,
              endIndent: 15,
              color: mainFontColor,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
              child: CustomBox(
                color: mainYellowScheme,
                height: 120,
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.exer.title,
                          style: TextStyle(color: mainFontColor, fontSize: 18),
                        ),
                        Divider(
                          color: mainFontColor,
                          thickness: 2,
                          endIndent: 30,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.exer.description,
                          style: TextStyle(color: mainFontColor),
                        )
                      ],
                    ),
                  ),
                )
              ),
            ),
            if (widget.exer.docID == docID)
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
              child: ButtonBox(
                color: mainYellowScheme,
                width: double.infinity,
                icon: const Icon(Icons.edit),
                text: 'Aufgabensatz Bearbeiten',
                onTap: () {
                  Navigator.push(
                    context,
                    SwipeRightTransition(
                      widget: EditExerciseSet(exer: widget.exer,),
                    ),
                  );
                }
              ),
            ),
            Row(
              children: [
                const SizedBox(
                  width: 15,
                ),
                const Text(
                  'Aufgaben hinzufügen',
                  style: TextStyle(fontSize: 26),
                ),
                const Expanded(child: SizedBox())
              ]
            ),
            Divider(
              thickness: 1.5,
              indent: 15,
              endIndent: 15,
              color: mainFontColor,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
              child: ButtonBox(
                width: double.infinity,
                color: mainYellowScheme,
                icon: const Icon(Icons.add),
                text: 'Aufgabe Erstellen',
                onTap: () {
                  Navigator.push(
                    context,
                    SwipeRightTransition(
                      widget: CreateExercise(exer: widget.exer,),
                    ),
                  );
                },
              ),
            ),
            Row(
              children: [
                const SizedBox(
                  width: 15,
                ),
                const Text(
                  'Übungsmodus',
                  style: TextStyle(fontSize: 26),
                ),
                const Expanded(child: SizedBox())
              ]
            ),
            Divider(
              thickness: 1.5,
              indent: 15,
              endIndent: 15,
              color: mainFontColor,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _modeState = 0;
                  });
                },
                child: CustomBox(
                  color: mainYellowScheme,
                  height: 30,
                  width: double.infinity,
                  child: Row(children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 5),
                      child: Icon((_modeState == 0)
                          ? Icons.play_arrow
                          : Icons.play_arrow_outlined),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                      child: Text(
                        'Unbeschränkt',
                        style: TextStyle(
                            fontWeight:
                                (_modeState == 0) ? FontWeight.bold : FontWeight.normal),
                      ),
                    ),
                  ]),
                ),
              )),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _modeState = 1;
                });
              },
              child: CustomBox(
                color: mainYellowScheme,
                height: 30,
                width: double.infinity,
                child: Row(children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 5),
                    child: Icon((_modeState == 1)
                        ? Icons.play_arrow
                        : Icons.play_arrow_outlined),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                    child: Text(
                      'Zeitlich Beschränkt',
                      style: TextStyle(
                          fontWeight:
                              (_modeState == 1) ? FontWeight.bold : FontWeight.normal),
                    ),
                  ),
                ]),
              ),
            )),
            Padding(
            padding: const EdgeInsets.fromLTRB(15, 5, 15, 15),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _modeState = 2;
                });
              },
              child: CustomBox(
                color: mainYellowScheme,
                height: 30,
                width: double.infinity,
                child: Row(children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 5),
                    child: Icon((_modeState == 2)
                        ? Icons.play_arrow
                        : Icons.play_arrow_outlined),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                    child: Text(
                      'Anzahl Beschränkt',
                      style: TextStyle(
                          fontWeight:
                              (_modeState == 2) ? FontWeight.bold : FontWeight.normal),
                    ),
                  ),
                ]),
              ),
            )),
            if (_modeState == 1)
            Column(
              children: [
                Row(
                  children: [
                    const SizedBox(
                      width: 15,
                    ),
                    const Text(
                      'Lernzeit',
                      style: TextStyle(fontSize: 26),
                    ),
                    const Expanded(child: SizedBox())
                  ]
                ),
                Divider(
                  thickness: 1.5,
                  indent: 15,
                  endIndent: 15,
                  color: mainFontColor,
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: CustomBox(
                    color: mainYellowScheme, 
                    height: 60, 
                    width: double.infinity, 
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 10, 10, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.edit),
                              const SizedBox(width: 10),
                              Text(
                                '${minutes.toString()} Minuten'
                              )
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  setState(() {
                                    if (minutes > 1) {
                                      minutes --;
                                    }
                                  });
                                },
                              ),
                              const SizedBox(width: 10),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  setState(() {
                                    minutes ++;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ),
                )
              ],
            ),
            if (_modeState == 2)
            Column(
              children: [
                Row(
                  children: [
                    const SizedBox(
                      width: 15,
                    ),
                    const Text(
                      'Aufgaben Anzahl',
                      style: TextStyle(fontSize: 26),
                    ),
                    const Expanded(child: SizedBox())
                  ]
                ),
                Divider(
                  thickness: 1.5,
                  indent: 15,
                  endIndent: 15,
                  color: mainFontColor,
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: CustomBox(
                    color: mainYellowScheme, 
                    height: 60, 
                    width: double.infinity, 
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 10, 10, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.edit),
                              const SizedBox(width: 10),
                              Text(
                                taskNumber.toString()
                              )
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  setState(() {
                                    if (taskNumber > 1) {
                                      taskNumber --;
                                    }
                                  });
                                },
                              ),
                              const SizedBox(width: 10),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  setState(() {
                                    taskNumber ++;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ),
                )
              ],
            ),
            Divider(
              thickness: 1.5,
              indent: 15,
              endIndent: 15,
              color: mainFontColor,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 35),
              child: ButtonBox(
                color: mainYellowScheme,
                width: double.infinity,
                icon: const Icon(Icons.check_box_outlined),
                text: 'Übung Starten',
                onTap: () {
                  Navigator.push(
                    context,
                    SwipeRightTransition(
                      widget: RunExercise(
                        exer: widget.exer,
                        modeState: _modeState,
                        taskNumber: taskNumber,
                        minutes: minutes,
                      ),
                    ),
                  );
                }
              ),
            ),
          ]
        )
      )
    );
  }
}