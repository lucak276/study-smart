import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:study_smart/pages/exercise.dart';
import 'package:study_smart/pages/questions.dart';
import 'package:study_smart/pages/subcollaborate/start_exercise.dart';
import 'package:study_smart/pages/subquestions/answer_question.dart';
import 'package:study_smart/pages/subtasks/change_task.dart';
import 'package:study_smart/pages/tasks.dart';
import 'package:study_smart/utils/box.dart';
import 'package:study_smart/utils/get_appbar.dart';
import 'package:study_smart/utils/globals.dart';
import 'package:study_smart/utils/swipe_right_transition.dart';

class Overview extends StatefulWidget {
  const Overview({Key? key}) : super(key: key);

  @override
  State<Overview> createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  bool isLoading = true;
  bool _showTasks = true;
  bool _showQuestions = true;
  bool _showExercises = true;

  List<Widget> taskWidgets = [];
  List<Widget> questionWidgets = [];
  List<Widget> exerciseWidgets = [];

  @override
  void initState() {
    super.initState();

    fetchInformation();
  }

  fetchInformation() async {
    await fetchClasses();
    await fetchTasks();
    await fetchQuestions();
    await fetchExercises();

    setState(() {
      isLoading = false;
    });
  }

  Future fetchTasks() async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('Users/$docID/Tasks')
          .orderBy('dueDate')
          .get();

      List<Task> newTasks = [];
      List<Task> newDoneTasks = [];

      for (var queryDocumentSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data = queryDocumentSnapshot.data();
        if (data['status'] == 'done') {
          newDoneTasks.add(Task.fromMap(data, queryDocumentSnapshot.id));
        } else {
          newTasks.add(Task.fromMap(data, queryDocumentSnapshot.id));
        }
      }
      doneTasks = newDoneTasks;
      tasks = newTasks;

      try {
        taskWidgets.add(_getTaskBox(tasks[0]));
        taskWidgets.add(_getTaskBox(tasks[1]));
        taskWidgets.add(_getTaskBox(tasks[2]));
      } catch (e) {
        return;
      }
    } catch (e) {
      return;
    }
  }

  Future fetchQuestions() async {
    try {
      List<Widget> otherQuestions = [];
      var querySnapshot = await FirebaseFirestore.instance
          .collection('Majors/$major/$lesson/QA/Questions')
          .orderBy('createdAt')
          .get();

      myQuestions.clear();
      questions.clear();
      for (var queryDocumentSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data = queryDocumentSnapshot.data();
        if (data['id'] == docID) {
          myQuestions.add(Question.fromMap(data));
          if (questionWidgets.length < 3) {
            questionWidgets.add(_getQuestionBox(Question.fromMap(data)));
          }
        } else {
          questions.add(Question.fromMap(data));
          if (otherQuestions.length < 3) {
            otherQuestions.add(_getQuestionBox(Question.fromMap(data)));
          }
        }
      }
      int i = 0;
      while (questionWidgets.length < 3) {
        if (otherQuestions.length <= i) {
          break;
        }
        questionWidgets.add(otherQuestions[i]);
        i += 1;
      }
    } catch (e) {
      return;
    }
  }

  Future fetchExercises() async {
    List<Widget> otherExercises = [];
    try {
      exercises.clear();
      myExercises.clear();
      for (var less in lessons) {
        var querySnapshot = await FirebaseFirestore.instance
          .collection('Majors/$major/$less/ExerciseSets/ExerciseSet')
          .get();

        for (var queryDocumentSnapshot in querySnapshot.docs) {
          Map<String, dynamic> data = queryDocumentSnapshot.data();
          if (data['id'] == docID) {
            myExercises.add(ExerciseSet.fromMap(data, less));
            if (exerciseWidgets.length < 3) {
              exerciseWidgets.add(_getExerciseBox(ExerciseSet.fromMap(data, less)));
            }
          }
          else {
            if (data['publicAccess']) {
              exercises.add(ExerciseSet.fromMap(data, less));
              if (otherExercises.length < 3) {
                otherExercises.add(_getExerciseBox(ExerciseSet.fromMap(data, less)));
              }
            }
          }
        }
        int i = 0;
        while (exerciseWidgets.length < 3) {
          if (exercises.length <= i) {
            break;
          }
          exerciseWidgets.add(otherExercises[i]);
          i += 1;
        }
      }
    } catch (e) {
      return;
    }
  }

  fetchClasses() async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
      .collection('Majors')
      .doc(major)
      .get();
      lessons.clear();

      Map<String, dynamic>? data = querySnapshot.data();
      for (var less in data!['classes']) {
        setState(() {
          lessons.add(less);
        });
      }
      if (lesson == '') {
        setState(() {
          lesson = lessons[0];
        });
      }
    }
    catch (e) {
      return;
    }
  }

  Widget _getTaskBox(Task task) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          SwipeRightTransition(
            widget: ChangeTask(task: task),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
        child: CustomBox(
            color: mainRedScheme,
            height: 70,
            width: double.infinity,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(color: mainFontColor, fontSize: 18),
                    ),
                    Text(
                      'Bis: ${task.dueDate.day}.${task.dueDate.month}.${task.dueDate.year}',
                      style: TextStyle(
                        color: mainFontColor,
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }

  Widget _getQuestionBox(Question question) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          SwipeRightTransition(
            widget: AnswerQuestion(question: question),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
        child: CustomBox(
            color: mainPurpleScheme,
            height: 70,
            width: double.infinity,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      question.title,
                      style: TextStyle(color: mainFontColor, fontSize: 18),
                    ),
                    Text(
                      'Gefragt: ${question.createdAt.day}.${question.createdAt.month}.${question.createdAt.year}',
                      style: TextStyle(
                        color: mainFontColor,
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }

  Widget _getExerciseBox(ExerciseSet exer) {
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
            height: 70,
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
                    Text(
                      'Fach: ${exer.className}',
                      style: TextStyle(
                        color: mainFontColor,
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: getAppBar(height, false, 'Willkommen!', mainBlueScheme),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                setState(() {
                  _showTasks = !_showTasks;
                });
              },
              child: Row(children: [
                const SizedBox(
                  width: 15,
                ),
                Icon(_showTasks
                    ? Icons.arrow_downward_sharp
                    : Icons.arrow_upward_sharp),
                const SizedBox(width: 5),
                const Text(
                  'Tasks:',
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
            _showTasks
                ? Column(
                    children: taskWidgets,
                  )
                : const SizedBox(height: 5),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                setState(() {
                  _showQuestions = !_showQuestions;
                });
              },
              child: Row(children: [
                const SizedBox(
                  width: 15,
                ),
                Icon(_showQuestions
                    ? Icons.arrow_downward_sharp
                    : Icons.arrow_upward_sharp),
                const SizedBox(width: 5),
                const Text(
                  'Aktuelle Fragen:',
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
            _showQuestions
                ? Column(
                    children: questionWidgets,
                  )
                : const SizedBox(height: 5),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                setState(() {
                  _showExercises = !_showExercises;
                });
              },
              child: Row(children: [
                const SizedBox(
                  width: 15,
                ),
                Icon(_showExercises
                    ? Icons.arrow_downward_sharp
                    : Icons.arrow_upward_sharp),
                const SizedBox(width: 5),
                const Text(
                  'Aufgaben:',
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
            _showExercises
                ? Column(
                    children: exerciseWidgets,
                  )
                : const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
