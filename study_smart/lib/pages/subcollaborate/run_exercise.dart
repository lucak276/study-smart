// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:study_smart/pages/exercise.dart';
import 'package:study_smart/utils/box.dart';
import 'package:study_smart/utils/globals.dart';

class RunExercise extends StatefulWidget {
  const RunExercise({
    Key? key, 
    required this.exer, 
    required this.modeState, 
    required this.taskNumber,
    required this.minutes
  }) : super(key: key);

  final ExerciseSet exer;
  final int modeState;
  final int taskNumber;
  final int minutes;

  @override
  State<RunExercise> createState() => _RunExerciseState();
}

class _RunExerciseState extends State<RunExercise> {
  final _descriptionController = TextEditingController();
  List<Map<String, dynamic>> exerciseWidgets = [];
  bool _isLoading = true;

  int selectedOption = 0;

  int _currentIndex = 0;

  bool handedIn = false;

  DateTime startTime = DateTime.now();

  /// Check right answer of multiple choice
  int rightChoice = 0;

  late Timer _timer;
  late Duration _duration;

  @override
  void initState() {
    super.initState();

    _duration = DateTime.now().difference(startTime);
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => _updateTimer());

    _fetchExercises();

    if(widget.modeState == 1){
      Timer(Duration(minutes: widget.minutes), () async {
        minutesLearned += widget.minutes;
        box.put('minutesLearned', minutesLearned);
        saveTimeToFirestore();
        
        Navigator.of(context).pop();
      });
    }
  }

  saveTimeToFirestore() async {
    try {
      await FirebaseFirestore.instance
      .collection('Users')
      .doc(docID)
      .update({'minutesLearned': minutesLearned.toString()});
    }
    catch (e) {
      return;
    }
  }

  saveTasksToFirestore() async {
    try {
      await FirebaseFirestore.instance
      .collection('Users')
      .doc(docID)
      .update({'exercisesSolved': exercisesSolved.toString()});
    }
    catch (e) {
      return;
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _timer.cancel();

    super.dispose();
  }

  void _updateTimer() {
    setState(() {
      _duration = DateTime.now().difference(startTime);
    });
  }

  checkIsRight() {
    setState(() {
      rightChoice = exerciseWidgets[_currentIndex]['options'].indexOf(exerciseWidgets[_currentIndex]['solution']);
    });  
  }

  _fetchExercises() async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
      .collection('Majors/$major/${widget.exer.className}/ExerciseSets/ExerciseSet/${widget.exer.title}/Exercise')
      .get();

      for (var queryDocumentSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data = queryDocumentSnapshot.data();
        setState(() {
          exerciseWidgets.add(data);
        });
      }
      setState(() {
        exerciseWidgets.shuffle();
      });
    }
    catch (e) {
      return;
    }
    setState(() {
      _isLoading = false;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height*0.1),
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          flexibleSpace: Stack(
            children: [
              Container(
                width: double.infinity,
              decoration: BoxDecoration(
                  color: mainYellowScheme,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 0, 2),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 2, bottom: 2),
                      child: Container(
                        decoration: BoxDecoration(
                          color: mainYellowScheme,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(25, 0, 20, 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Expanded(child: SizedBox(height: 1,)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Üben',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30
                                    ),
                                  ),
                                  (widget.modeState == 1)
                                  ? Text(
                                    "${_duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${(_duration.inSeconds.remainder(60)).toString().padLeft(2, '0')}/${widget.minutes}:00",
                                    style: const TextStyle(
                                      fontSize: 25,
                                      color: Colors.white
                                    ),
                                  )
                                  : const Text('')
                                ],
                              )
                            ],
                          ),
                        )
                      ),
                    )
                  )
                ),
              ),
              Positioned(
                left: 10.0, 
                bottom: 10.0,
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(6),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(width: 5),
                          Icon(
                            Icons.arrow_back_ios,
                            color: mainYellowScheme,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          centerTitle: false,
        )
      ),
      body: SingleChildScrollView(
        child: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
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
                          exerciseWidgets[_currentIndex]['description'],
                          style: TextStyle(color: mainFontColor),
                        )
                      ],
                    ),
                  ),
                )
              ),
            ),
            Row(children: [
            const SizedBox(
              width: 15,
            ),
            const Text(
              'Antwort:',
              style: TextStyle(fontSize: 26),
            ),
            const Expanded(child: SizedBox())
          ]),
          Divider(
            thickness: 1.5,
            indent: 15,
            endIndent: 15,
            color: mainFontColor,
          ),
          (exerciseWidgets[_currentIndex]['isText'])
          ? Padding(
            padding: const EdgeInsets.all(15),
            child: CustomBox(
              color: mainYellowScheme,
              height: 150,
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 10, right: 5, top: 15),
                    child: Icon(Icons.edit),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                    child: TextField(
                      controller: _descriptionController,
                      enableSuggestions: true,
                      maxLines: 5,
                      decoration: InputDecoration(
                        constraints: BoxConstraints(
                            maxHeight: 140, maxWidth: width * 0.7),
                        hintText: 'Antwort eingeben',
                        hintStyle: TextStyle(color: mainFontColor),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(color: mainFontColor),
                    )
                  )
                ]
              )
            ),
          )
          : Column(
            children: [
              for (var i = 0; i < exerciseWidgets[_currentIndex]['options'].length; i++)
              handedIn ?
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
                child: ButtonBox(
                  width: double.infinity,
                  color: (i == rightChoice) ? mainGreenScheme : mainRedScheme,
                  icon: Icon(
                    (selectedOption == i) ? Icons.play_arrow : Icons.play_arrow_outlined
                  ),
                  text: exerciseWidgets[_currentIndex]['options'][i],
                  onTap: () {
                    setState(() {
                      selectedOption = i;
                    });
                  },
                ),
              )
              : Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
                child: ButtonBox(
                  width: double.infinity,
                  color: mainYellowScheme,
                  icon: Icon(
                    (selectedOption == i) ? Icons.play_arrow : Icons.play_arrow_outlined
                  ),
                  text: exerciseWidgets[_currentIndex]['options'][i],
                  onTap: () {
                    setState(() {
                      selectedOption = i;
                    });
                  },
                ),
              ),
            ],
          ),
          if (handedIn && exerciseWidgets[_currentIndex]['isText'])
          Column(
            children: [
              Row(children: [
                const SizedBox(
                  width: 15,
                ),
                const Text(
                  'Antwort:',
                  style: TextStyle(fontSize: 26),
                ),
                const Expanded(child: SizedBox())
              ]),
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
                            exerciseWidgets[_currentIndex]['solution'],
                            style: TextStyle(color: mainFontColor),
                          )
                        ],
                      ),
                    ),
                  )
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Divider(
            thickness: 3,
            indent: 15,
            endIndent: 15,
            color: mainFontColor,
          ),
          if (!handedIn)
          Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
              child: ButtonBox(
                color: mainYellowScheme,
                width: double.infinity,
                icon: const Icon(Icons.check_box_outlined),
                text: 'Abgeben',
                onTap: () {
                  if (!exerciseWidgets[_currentIndex]['isText']) {
                    checkIsRight();
                  }
                  setState(() {                    
                    handedIn = true;                    
                  });
                }
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
              child: ButtonBox(
                color: mainYellowScheme,
                width: double.infinity,
                icon: Icon(handedIn ? Icons.check_box_outlined : Icons.skip_next_outlined),
                text: handedIn ? 'Nächste Aufgabe' : 'Überspringen',
                onTap: () {
                  setState(() {
                    handedIn = false;
                    if (exerciseWidgets.length > (_currentIndex + 1)) {
                      if ((widget.modeState == 2) && (widget.taskNumber > (_currentIndex + 1))) {
                        setState(() {
                          _currentIndex++;
                        });
                      }
                      else if (widget.taskNumber <= (_currentIndex + 1)) {
                        exercisesSolved += widget.taskNumber;
                        box.put('exercisesSolved', exercisesSolved);
                        saveTasksToFirestore();
                      }
                      else {
                        setState(() {
                          _currentIndex++;
                        });
                      }
                    }
                  });
                }
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 35),
              child: ButtonBox(
                color: mainYellowScheme,
                width: double.infinity,
                icon: const Icon(Icons.stop_circle_outlined),
                text: 'Übung abbrechen',
                onTap: () {
                  Navigator.of(context).pop();
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}