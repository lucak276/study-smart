import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:study_smart/pages/exercise.dart';
import 'package:study_smart/pages/subcollaborate/edit_exercise.dart';
import 'package:study_smart/utils/box.dart';
import 'package:study_smart/utils/get_appbar.dart';
import 'package:study_smart/utils/globals.dart';
import 'package:study_smart/utils/swipe_right_transition.dart';

class EditExerciseSet extends StatefulWidget {
  const EditExerciseSet({Key? key, required this.exer}) : super(key: key);

  final ExerciseSet exer;

  @override
  State<EditExerciseSet> createState() => _EditExerciseState();
}

class _EditExerciseState extends State<EditExerciseSet> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool isLoading = false;
  bool somethingWentWrong = false;
  bool changeSuccessful = false;

  bool _showExercises = false;

  bool isPublic = true;
  bool isPrivat = false;

  List<Widget> exerciseWidgets = [];

  @override
  void initState() {
    super.initState();

    _titleController.text = widget.exer.title;
    _descriptionController.text = widget.exer.description;
    isPublic = widget.exer.publicAccess;

    _fetchExercises();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();

    super.dispose();
  }

  _fetchExercises() async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
      .collection('Majors/$major/${widget.exer.className}/ExerciseSets/ExerciseSet/${widget.exer.title}/Exercise')
      .get();

      for (var queryDocumentSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data = queryDocumentSnapshot.data();
        setState(() {
          exerciseWidgets.add(_getExerciseBox(data, queryDocumentSnapshot.id));
        });
      }
    }
    catch (e) {
      return;
    }
  }

  Widget _getExerciseBox(Map<String, dynamic> data, String dID) {
    return GestureDetector(
      onTap: () {
        if (data['id'] == docID) {
          Navigator.push(
            context,
            SwipeRightTransition(
              widget: EditExercise(dID: dID, exer: widget.exer, data: data),
            ),
          );
        }
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
                      data['title'],
                      style: TextStyle(color: mainFontColor, fontSize: 18),
                    ),
                    Text(
                      'von: ${data['creator']}',
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
                      data['description'],
                      style: TextStyle(color: mainFontColor),
                    )
                  ],
                ),
              ),
            )),
      ),
    );
  }

  _getCreateButton() {
    return isLoading
        ? const CircularProgressIndicator()
        : Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
            child: ButtonBox(
                color: mainYellowScheme,
                width: double.infinity,
                icon: const Icon(Icons.task_alt_outlined),
                text: 'Änderungen speichern',
                onTap: () async {
                  try {
                    await FirebaseFirestore.instance
                        .collection('Majors')
                        .doc(major)
                        .collection(lesson)
                        .doc('ExerciseSets')
                        .collection('ExerciseSet')
                        .doc(widget.exer.title)
                        .update({
                      'title': _titleController.text.trim(),
                      'description': _descriptionController.text.trim(),
                      'publicAccess': isPublic,
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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: getReturnAppBar(height, true, 'Aufgabensatz', mainYellowScheme),
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
                        hintText: 'Aufgabensatz Titel',
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
                              hintText: 'Beschreibung (Optional)',
                              hintStyle: TextStyle(color: mainFontColor),
                              border: InputBorder.none,
                            ),
                            style: TextStyle(color: mainFontColor),
                          ))
                    ])),
          ),
          Row(children: const [
            SizedBox(
              width: 15,
            ),
            Text(
              'Sichtbarkeit:',
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
              padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
              child: GestureDetector(
                onTap: () {
                  if (!isPublic) {
                    setState(() {
                      isPrivat = !isPrivat;
                      isPublic = !isPublic;
                    });
                  }
                },
                child: CustomBox(
                  color: mainYellowScheme,
                  height: 30,
                  width: double.infinity,
                  child: Row(children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 5),
                      child: Icon(isPublic
                          ? Icons.play_arrow
                          : Icons.play_arrow_outlined),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                      child: Text(
                        'Öffentlich',
                        style: TextStyle(
                            fontWeight:
                                isPublic ? FontWeight.bold : FontWeight.normal),
                      ),
                    ),
                  ]),
                ),
              )),
          Padding(
              padding: const EdgeInsets.fromLTRB(15, 5, 15, 15),
              child: GestureDetector(
                onTap: () {
                  if (!isPrivat) {
                    setState(() {
                      isPrivat = !isPrivat;
                      isPublic = !isPublic;
                    });
                  }
                },
                child: CustomBox(
                  color: mainYellowScheme,
                  height: 30,
                  width: double.infinity,
                  child: Row(children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 5),
                      child: Icon(isPrivat
                          ? Icons.play_arrow
                          : Icons.play_arrow_outlined),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                      child: Text(
                        'Privat',
                        style: TextStyle(
                            fontWeight:
                                isPrivat ? FontWeight.bold : FontWeight.normal),
                      ),
                    ),
                  ]),
                ),
              )),
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
          _showExercises
          ? Column(
            children: exerciseWidgets
          )
          : const SizedBox(height: 1),
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
              changeSuccessful ? 'Aufgabensatz erfolgreich geändert!' : '',
              style: const TextStyle(color: Colors.green),
            ),
          ),
        ]),
      ),
    );
  }
}