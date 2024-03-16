import 'package:flutter/material.dart';
import 'package:study_smart/pages/subcollaborate/create_exercise_set.dart';
import 'package:study_smart/pages/subcollaborate/start_exercise.dart';
import 'package:study_smart/utils/box.dart';
import 'package:study_smart/utils/get_appbar.dart';
import 'package:study_smart/utils/globals.dart';

import '../utils/swipe_right_transition.dart';

class Exercise extends StatefulWidget {
  const Exercise({Key? key}) : super(key: key);

  @override
  State<Exercise> createState() => _Exercise();
}

class _Exercise extends State<Exercise> {
  bool showYourExcercises = true; //TODO: save this state in local DB
  bool showOtherExcercises = true; //TODO: save this state in local DB

  List<Widget> exerciseWidgets = [];
  List<Widget> myExerciseWidgets = [];

  @override
  void initState() {
    super.initState();

    buildExercises();
  }

  buildExercises() {
    try {
      exerciseWidgets.clear();
      myExerciseWidgets.clear();
      for (var exer in myExercises) {
        if(exer.className == lesson) {
          myExerciseWidgets.add(_getExerciseBox(exer));
        }
      }
      for (var exer in exercises) {
        if(exer.className == lesson) {
          exerciseWidgets.add(_getExerciseBox(exer));
        }
      }
    } catch (e) {
      return;
    }
  }

  _getExerciseBox(ExerciseSet exer) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          SwipeRightTransition(
            widget: StartExercise(exer: exer),
          ),
        );
      },
      child: Padding(
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
                    exer.title,
                    style: TextStyle(color: mainFontColor, fontSize: 18),
                  ),
                  Divider(
                    color: mainFontColor,
                    thickness: 2,
                    endIndent: 30,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    exer.description,
                    style: TextStyle(color: mainFontColor),
                  )
                ],
              ),
            ),
          )
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: getAppBar(height, true, 'Üben', mainYellowScheme),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: ButtonBox(
                color: mainYellowScheme,
                width: double.infinity,
                icon: const Icon(Icons.add),
                text: 'Aufgabensatz Erstellen',
                onTap: () {
                  Navigator.push(
                    context,
                    SwipeRightTransition(
                      widget: const CreateExerciseSet(),
                    ),
                  );
                }
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  showYourExcercises = !showYourExcercises;
                });
              },
              child: Row(children: [
                const SizedBox(
                  width: 15,
                ),
                Icon(showYourExcercises
                    ? Icons.arrow_downward_sharp
                    : Icons.arrow_upward_sharp),
                const SizedBox(width: 5),
                const Text(
                  'Deine Übungssätze',
                  style: TextStyle(fontSize: 26),
                ),
                const Expanded(child: SizedBox())
              ]),
            ),
            Divider(
              thickness: 1.5,
              indent: 15,
              endIndent: 15,
              color: mainFontColor,
            ),
            showYourExcercises
                ? Column(
                    children: myExerciseWidgets,
                  )
                : const SizedBox(
                    height: 1,
                  ),
            const SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  showOtherExcercises = !showOtherExcercises;
                });
              },
              child: Row(children: [
                const SizedBox(
                  width: 15,
                ),
                Icon(showOtherExcercises
                    ? Icons.arrow_downward_sharp
                    : Icons.arrow_upward_sharp),
                const SizedBox(width: 5),
                const Text(
                  'Andere Übungssätze',
                  style: TextStyle(fontSize: 26),
                ),
                const Expanded(child: SizedBox())
              ]),
            ),
            Divider(
              thickness: 1.5,
              indent: 15,
              endIndent: 15,
              color: mainFontColor,
            ),
            showOtherExcercises
            ? Column(children: exerciseWidgets,)
            : const SizedBox(height: 1)
          ],
        ),
      ),
    );
  }
}

class ExerciseSet {
  final String title;
  final String description;
  final bool publicAccess;
  final String docID;
  final String className;

  const ExerciseSet(
      {required this.title,
      required this.description,
      required this.publicAccess,
      required this.docID,
      required this.className});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'docID': docID,
      'title': title,
      'description': description,
      'publicAccess': publicAccess,
    };
    return map;
  }

  factory ExerciseSet.fromMap(Map<dynamic, dynamic> data, String cName) {
    ExerciseSet exerciseSet = ExerciseSet(
        title: data['title'],
        description: data['description'],
        publicAccess: data['publicAccess'],
        docID: data['id'],
        className: cName);
    return exerciseSet;
  }
}
