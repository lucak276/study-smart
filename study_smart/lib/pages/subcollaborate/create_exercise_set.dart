import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:study_smart/utils/box.dart';
import 'package:study_smart/utils/get_appbar.dart';
import 'package:study_smart/utils/globals.dart';

class CreateExerciseSet extends StatefulWidget {
  const CreateExerciseSet({Key? key}) : super(key: key);

  @override
  State<CreateExerciseSet> createState() => _CreateExerciseSetState();
}

class _CreateExerciseSetState extends State<CreateExerciseSet> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool isLoading = false;
  bool somethingWentWrong = false;
  bool changeSuccessful = false;

  bool isPublic = true;

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
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
            child: ButtonBox(
                color: mainYellowScheme,
                width: double.infinity,
                icon: const Icon(Icons.task_alt_outlined),
                text: 'Aufgabensatz erstellen',
                onTap: () async {
                  try {
                    await FirebaseFirestore.instance
                        .collection('Majors')
                        .doc(major)
                        .collection(lesson)
                        .doc('ExerciseSets')
                        .collection('ExerciseSet')
                        .doc(_titleController.text.trim())
                        .set({
                      'title': _titleController.text.trim(),
                      'description': _descriptionController.text.trim(),
                      'publicAccess': isPublic,
                      'id': docID
                    });

                    if (mounted) {
                      Navigator.of(context).pop();
                    }
                  } catch (e) {
                    //print(e);
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
          Row(children: [
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
          Row(children: [
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
          Row(children: [
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
              padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isPublic = !isPublic;
                  });
                },
                child: CustomBox(
                  color: mainYellowScheme,
                  height: 30,
                  width: double.infinity,
                  child: Row(children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 5),
                      child: Icon(isPublic
                          ? Icons.play_arrow_outlined
                          : Icons.play_arrow),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                      child: Text(
                        'Privat',
                        style: TextStyle(
                            fontWeight:
                                isPublic ? FontWeight.normal : FontWeight.bold),
                      ),
                    ),
                  ]),
                ),
              )),
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
