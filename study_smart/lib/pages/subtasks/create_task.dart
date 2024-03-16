// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:study_smart/utils/box.dart';
import 'package:study_smart/utils/get_appbar.dart';
import 'package:study_smart/utils/globals.dart';

class CreateTask extends StatefulWidget {
  const CreateTask({Key? key}) : super(key: key);

  @override
  State<CreateTask> createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime selectedDate = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day, 0, 0, 0, 0);

  bool isLoading = false;
  bool somethingWentWrong = false;
  bool changeSuccessful = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();

    super.dispose();
  }

  _getCreateButton() {
    return isLoading
        ? const CircularProgressIndicator()
        : Padding(
            padding: const EdgeInsets.all(15),
            child: ButtonBox(
                color: mainRedScheme,
                width: double.infinity,
                icon: const Icon(Icons.task_alt_outlined),
                text: 'Task erstellen',
                onTap: () async {
                  try {
                    await FirebaseFirestore.instance
                        .collection('Users/$docID/Tasks')
                        .add({
                      'title': _titleController.text.trim(),
                      'description': _descriptionController.text.trim(),
                      'dueDate': selectedDate,
                      'status': 'active',
                      'class': lesson
                    });

                    if (mounted) {
                      Navigator.of(context).pop();
                    }
                  } catch (e) {
                    return;
                  }
                }),
          );
  }

  Widget _getDatePicker() {
    var outputFormat = DateFormat('dd.MM.yyyy');
    var outputDate = outputFormat.format(selectedDate);

    return Padding(
      padding:
          const EdgeInsets.only(left: 25.0, top: 10, bottom: 10, right: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Tag',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(
              height: 60,
              child: GestureDetector(
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101));
                  if (picked != null && picked != selectedDate) {
                    setState(() {
                      selectedDate = picked;
                    });
                  }
                },
                child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: mainRedScheme,
                        borderRadius: BorderRadius.circular(12)),
                    child: Center(
                        child: Text(outputDate,
                            style: const TextStyle(
                                fontSize: 18, color: Colors.white)))),
              )),
        ],
      ),
    );
  }

  Widget _getTimePicker() {
    var timeFormat = DateFormat('HH:mm');
    return Padding(
      padding:
          const EdgeInsets.only(left: 25.0, top: 10, bottom: 10, right: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Uhrzeit',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(
              height: 60,
              child: GestureDetector(
                onTap: () async {
                  var time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(selectedDate));
                  if (time != null) {
                    setState(() {
                      selectedDate = DateTime(
                          selectedDate.year,
                          selectedDate.month,
                          selectedDate.day,
                          time.hour,
                          time.minute);
                    });
                  }
                },
                child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: mainRedScheme,
                        borderRadius: BorderRadius.circular(12)),
                    child: Center(
                        child: Text(timeFormat.format(selectedDate),
                            style: const TextStyle(
                                fontSize: 18, color: Colors.white)))),
              )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: getReturnAppBar(height, false, 'Task Erstellen', mainRedScheme),
      body: SingleChildScrollView(
        child: Column(children: [
          const SizedBox(height: 20),
          Row(children: const [
            SizedBox(
              width: 15,
            ),
            Text(
              'Titel:',
              style: TextStyle(fontSize: 26),
            ),
            Expanded(child: SizedBox())
          ]),
          Divider(
            thickness: 1.5,
            indent: 15,
            endIndent: 15,
            color: mainFontColor,
          ),
          Padding(
              padding: const EdgeInsets.all(15),
              child: CustomBox(
                color: mainRedScheme,
                height: 60,
                width: double.infinity,
                child: Row(children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 10, right: 5),
                    child: Icon(Icons.edit),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                    child: TextField(
                      controller: _titleController,
                      enableSuggestions: true,
                      decoration: InputDecoration(
                        constraints: BoxConstraints(
                            maxHeight: 60, maxWidth: width * 0.7),
                        border: InputBorder.none,
                        hintText: 'Task Titel',
                        hintStyle: TextStyle(color: mainFontColor),
                      ),
                      style: TextStyle(color: mainFontColor),
                    ),
                  ),
                ]),
              )),
          Row(children: const [
            SizedBox(
              width: 15,
            ),
            Text(
              'Fälligkeitsdatum:',
              style: TextStyle(fontSize: 26),
            ),
            Expanded(child: SizedBox())
          ]),
          Divider(
              thickness: 1.5, indent: 15, endIndent: 15, color: mainFontColor),
          _getDatePicker(),
          _getTimePicker(),
          Row(children: const [
            SizedBox(
              width: 15,
            ),
            Text(
              'Beschreibung:',
              style: TextStyle(fontSize: 26),
            ),
            Expanded(child: SizedBox())
          ]),
          Divider(
            thickness: 1.5,
            indent: 15,
            endIndent: 15,
            color: mainFontColor,
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: CustomBox(
                color: mainRedScheme,
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
                              hintText: 'Beschreibung',
                              hintStyle: TextStyle(color: mainFontColor),
                              border: InputBorder.none,
                            ),
                            style: TextStyle(color: mainFontColor),
                          ))
                    ])),
          ),
          const SizedBox(height: 20),
          Divider(
            thickness: 3,
            indent: 15,
            endIndent: 15,
            color: mainFontColor,
          ),
          _getCreateButton(),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              somethingWentWrong
                  ? 'Etwas ist schiefgelaufen! Versuchen Sie es später erneut!'
                  : '',
              style: const TextStyle(color: Colors.red),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              changeSuccessful ? 'Task erfolgreich geändert!' : '',
              style: const TextStyle(color: Colors.green),
            ),
          ),
        ]),
      ),
    );
  }
}
