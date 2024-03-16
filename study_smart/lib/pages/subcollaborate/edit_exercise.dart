// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:study_smart/pages/exercise.dart';
import 'package:study_smart/utils/box.dart';
import 'package:study_smart/utils/get_appbar.dart';
import 'package:study_smart/utils/globals.dart';

class EditExercise extends StatefulWidget {
  const EditExercise({Key? key, required this.dID, required this.exer, required this.data}) : super(key: key);

  final String dID;
  final ExerciseSet exer;
  final Map<String, dynamic> data;

  @override
  State<EditExercise> createState() => _EditExerciseState();
}

class _EditExerciseState extends State<EditExercise> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _solutionController = TextEditingController();

  bool isLoading = false;
  bool somethingWentWrong = false;
  bool changeSuccessful = false;

  late bool isText;

  List<dynamic> options = [];
  int rightOption = 0;

  bool _isMaxLimitReached = false;

  @override
  void initState() {
    super.initState();

    isText = widget.data['isText'];
    options = widget.data['options'];
    _titleController.text = widget.data['title'];
    _descriptionController.text = widget.data['description'];
    if (isText) {
      _solutionController.text = widget.data['solution'];
    }
    else {
      _solutionController.text = options.firstWhere((element) => element == widget.data['solution']);
      rightOption = options.indexOf(widget.data['solution']);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _solutionController.dispose();

    super.dispose();
  }

  void _removeAnswerOption(int index) {
    setState(() {
      options.removeAt(index);
      if (_isMaxLimitReached) {
        _isMaxLimitReached = false;
      }
    });
  }

  void _addAnswerOption() {
    if (options.length >= 6) {
      setState(() {
        _isMaxLimitReached = true;
      });
      return;
    }

    setState(() {
      options.add('');
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: getReturnAppBar(height, true, 'Aufgabensatz', mainYellowScheme),
      body: SingleChildScrollView(
        child: Column(children: [
          const SizedBox(height: 20),
          Row(children: [
            const SizedBox(
              width: 15,
            ),
            const Text(
              'Aufgabenart:',
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
            padding: const EdgeInsets.all(15.0),
            child: ButtonBox(
              color: mainYellowScheme, 
              width: width, 
              icon: const Icon(Icons.edit), 
              text: isText ? 'Fließtext' : 'Multiple Choice', 
              onTap: () {
                setState(() {
                  isText = !isText;
                });
              }
            ),
          ),
          Row(children: [
            const SizedBox(
              width: 15,
            ),
            const Text(
              'Titel:',
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
            padding: const EdgeInsets.all(15),
            child: CustomBox(
              color: mainYellowScheme,
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
                      hintText: 'Aufgaben Titel',
                      hintStyle: TextStyle(color: mainFontColor),
                    ),
                    style: TextStyle(color: mainFontColor),
                  ),
                ),
              ]),
            )),
          Row(children: [
            const SizedBox(
              width: 15,
            ),
            const Text(
              'Beschreibung:',
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
                              hintText: 'Beschreibung',
                              hintStyle: TextStyle(color: mainFontColor),
                              border: InputBorder.none,
                            ),
                            style: TextStyle(color: mainFontColor),
                          ))
                    ])),
          ),
          if (!isText) 
          Column(
            children: [
              Row(children: [
                const SizedBox(
                  width: 15,
                ),
                const Text(
                  'Optionen:',
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
              for (var i = 0; i < options.length; i++)
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
                child: CustomBox(
                  color: mainYellowScheme,
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
                        onChanged: (value) {
                          setState(() {
                            options[i] = value;
                          });
                        },
                        enableSuggestions: true,
                        decoration: InputDecoration(
                          constraints: BoxConstraints(
                              maxHeight: 60, maxWidth: width * 0.7),
                          border: InputBorder.none,
                          hintText: options[i],
                          hintStyle: TextStyle(color: mainFontColor),
                        ),
                        style: TextStyle(color: mainFontColor),
                      ),
                    ),
                  ]),
                )
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
                child: ButtonBox(
                  width: double.infinity,
                  color: mainYellowScheme,
                  icon: const Icon(Icons.add),
                  text: 'Option hinzufügen',
                  onTap: () {
                    _addAnswerOption();
                  },
                ),
              ),
            ],
          ),
          Row(children: [
            const SizedBox(
              width: 15,
            ),
            const Text(
              'Musterlösung:',
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
          isText
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
                            controller: _solutionController,
                            enableSuggestions: true,
                            maxLines: 5,
                            decoration: InputDecoration(
                              constraints: BoxConstraints(
                                  maxHeight: 140, maxWidth: width * 0.7),
                              hintText: 'Lösung',
                              hintStyle: TextStyle(color: mainFontColor),
                              border: InputBorder.none,
                            ),
                            style: TextStyle(color: mainFontColor),
                          ))
                    ])),
          )
          : Column(
            children: [
              for (var i = 0; i < options.length; i++)
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
                child: ButtonBox(
                  width: double.infinity,
                  color: mainYellowScheme,
                  icon: Icon(
                    (rightOption == i) ? Icons.play_arrow : Icons.play_arrow_outlined
                  ),
                  text: options[i],
                  onTap: () {
                    setState(() {
                      rightOption = i;
                    });
                  },
                ),
              ),
            ],
          ),
          Divider(
            thickness: 3,
            indent: 15,
            endIndent: 15,
            color: mainFontColor,
          ),
          isLoading
        ? const CircularProgressIndicator()
        : Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
            child: ButtonBox(
                color: mainYellowScheme,
                width: double.infinity,
                icon: const Icon(Icons.task_alt_outlined),
                text: 'Aufgabe erstellen',
                onTap: () async {
                  try {
                    if (!isText) {
                      setState(() {
                        _solutionController.text = options[rightOption];
                      });
                    }
                      
                    await FirebaseFirestore.instance
                        .collection('Majors')
                        .doc(major)
                        .collection(lesson)
                        .doc('ExerciseSets')
                        .collection('ExerciseSet')
                        .doc(widget.exer.title)
                        .collection('Exercise')
                        .doc(widget.dID)
                        .update({
                      'description': _descriptionController.text.trim(),
                      'isText': isText,
                      'options': options,
                      'solution': _solutionController.text.trim(),
                      'title': _titleController.text.trim()
                    });

                    if (mounted) {
                      Navigator.of(context).pop();
                    }
                  } catch (e) {
                    return;
                  }
                }),
          ),
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
              changeSuccessful ? 'Aufgabensatz erfolgreich geändert!' : '',
              style: const TextStyle(color: Colors.green),
            ),
          ),
        ]),
      ),
    );
  }
}
