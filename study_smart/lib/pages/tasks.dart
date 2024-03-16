import 'package:flutter/material.dart';
import 'package:study_smart/pages/subtasks/change_task.dart';
import 'package:study_smart/pages/subtasks/create_task.dart';
import 'package:study_smart/utils/box.dart';
import 'package:study_smart/utils/get_appbar.dart';
import 'package:study_smart/utils/globals.dart';
import 'package:study_smart/utils/swipe_right_transition.dart';

class Tasks extends StatefulWidget {
  const Tasks({Key? key}) : super(key: key);

  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime selectedDate = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day, 0, 0, 0, 0);

  bool _showActiveTasks = true;
  bool _showDoneTasks = true;
  List<Widget> taskWidgets = [];
  List<Widget> doneTaskWidgets = [];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    fetchTasks();
  }

  fetchTasks() {
    try {
      taskWidgets.clear();
      doneTaskWidgets.clear();
      for (var task in tasks) {
        if(task.className == lesson) {
          taskWidgets.add(_getTaskBox(task));
        }
      }
      for (var task in doneTasks) {
        if(task.className == lesson) {
          doneTaskWidgets.add(_getTaskBox(task));
        }
      }
    } catch (e) {
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
            height: 120,
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
                    Divider(
                      color: mainFontColor,
                      thickness: 2,
                      endIndent: 30,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      task.description,
                      style: TextStyle(color: mainFontColor),
                    )
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
        appBar: getAppBar(height, true, 'Tasks', mainRedScheme),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      SwipeRightTransition(
                        widget: const CreateTask(),
                      ),
                    );
                  },
                  child: CustomBox(
                      color: mainRedScheme,
                      height: 60,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 10, 10, 10),
                        child: Row(
                          children: [
                            Icon(
                              Icons.add_box_outlined,
                              color: mainFontColor,
                            ),
                            const SizedBox(height: 15),
                            Text(
                              'Task erstellen',
                              style: TextStyle(color: mainFontColor),
                            )
                          ],
                        ),
                      )),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showActiveTasks = !_showActiveTasks;
                  });
                },
                child: Row(children: [
                  const SizedBox(
                    width: 15,
                  ),
                  Icon(_showActiveTasks
                      ? Icons.arrow_downward_sharp
                      : Icons.arrow_upward_sharp),
                  const SizedBox(width: 5),
                  const Text(
                    'Aktive Tasks:',
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
              _showActiveTasks
                  ? Column(
                      children: taskWidgets,
                    )
                  : const SizedBox(height: 5),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showDoneTasks = !_showDoneTasks;
                  });
                },
                child: Row(children: [
                  const SizedBox(
                    width: 15,
                  ),
                  Icon(_showDoneTasks
                      ? Icons.arrow_downward_sharp
                      : Icons.arrow_upward_sharp),
                  const SizedBox(width: 5),
                  const Text(
                    'Erledigte Tasks:',
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
              _showDoneTasks
                  ? Column(
                      children: doneTaskWidgets,
                    )
                  : const SizedBox(height: 5),
            ],
          ),
        ));
  }
}

class Task {
  final String title;
  final String description;
  final DateTime dueDate;
  final String docID;
  final String className;

  const Task(
      {required this.title,
      required this.description,
      required this.dueDate,
      required this.docID,
      required this.className
      });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'title': title,
      'description': description,
      'dueDate': dueDate,
      'class': className
    };
    return map;
  }

  factory Task.fromMap(Map<dynamic, dynamic> data, String docID) {
    Task task = Task(
        title: data['title'],
        description: data['description'],
        dueDate: toDateTime(data['dueDate']),
        docID: docID,
        className: data['class']);
    return task;
  }
}
