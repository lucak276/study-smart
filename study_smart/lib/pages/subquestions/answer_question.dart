// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:study_smart/pages/questions.dart';
import 'package:study_smart/utils/box.dart';
import 'package:study_smart/utils/get_appbar.dart';
import 'package:study_smart/utils/globals.dart';
import 'package:study_smart/utils/storage_service.dart';

class AnswerQuestion extends StatefulWidget {
  const AnswerQuestion({Key? key, required this.question}) : super(key: key);

  final Question question;

  @override
  State<AnswerQuestion> createState() => _AnswerQuestionState();
}

class _AnswerQuestionState extends State<AnswerQuestion> {
  List<Widget> answerBoxes = [];

  bool _showQuestion = true;
  bool _showAnswers = true;

  bool isLoading = false;

  File? _image = null;
  String path = '';
  String fileName = '';

  final _answerController = TextEditingController();

  Widget image = const SizedBox(height: 1);

  @override
  void initState() {
    super.initState();

    _loadImage();
    _getAnswers();
  }

  @override
  void dispose() {
    _answerController.dispose();

    super.dispose();
  }

  Future _getAnswers() async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('Majors/$major/$lesson/QA/Answers')
          .orderBy('createdAt')
          .get();

      for (var queryDocumentSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data = queryDocumentSnapshot.data();
        if (data['title'] == widget.question.title) {
          Widget answerImage = const SizedBox(height: 1);
          bool hasImage = false;
          if (data['imagePath'] != '') {
            try {
              setState(() {
                hasImage = true;
              });
              Reference storageReference =
                  FirebaseStorage.instance.ref().child(data['imagePath']);

              String downloadUrl = await storageReference.getDownloadURL();

              setState(() {
                answerImage = Padding(
                  padding: const EdgeInsets.all(15),
                  child: Image.network(
                    downloadUrl,
                    fit: BoxFit.cover,
                  ),
                );
              });
            } catch (e) {
              setState(() {
                hasImage = false;
              });
            }
          }
          setState(() {
            answerBoxes.add(Padding(
              padding: const EdgeInsets.all(15),
              child: CustomBox(
                  color: mainPurpleScheme,
                  height: hasImage ? 200 : 120,
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['name'],
                            style:
                                TextStyle(color: mainFontColor, fontSize: 18),
                          ),
                          Text(
                            'am ${toDateTime(data['createdAt']).day}.${toDateTime(data['createdAt']).month}.${toDateTime(data['createdAt']).year}',
                            style:
                                TextStyle(color: mainFontColor, fontSize: 18),
                          ),
                          Divider(
                            color: mainFontColor,
                            thickness: 2,
                            endIndent: 30,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            data['content'],
                            style: TextStyle(color: mainFontColor),
                          ),
                          answerImage
                        ],
                      ),
                    ),
                  )),
            ));
          });
        }
      }
    } catch (e) {
      return;
    }
  }

  _loadImage() async {
    if (widget.question.imagePath.isNotEmpty) {
      try {
        Reference storageReference =
            FirebaseStorage.instance.ref().child(widget.question.imagePath);

        String downloadUrl = await storageReference.getDownloadURL();

        setState(() {
          image = Padding(
            padding: const EdgeInsets.all(15),
            child: CustomBox(
              height: 200,
              width: double.infinity,
              color: mainPurpleScheme,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Image.network(
                    downloadUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
        });
      } catch (e) {
        return;
      }
    }
  }

  Future<void> pickSomeFiles() async {
    List<String> extensions = ['pdf', 'png'];
    try {
      final results = await FilePicker.platform.pickFiles(
          allowMultiple: false,
          type: FileType.custom,
          allowedExtensions: extensions);

      if (results != null) {
        setState(() {
          _image = File(results.files.single.path!);
        });

        path = results.files.single.path!;
        fileName = results.files.single.name;
      }
    } catch (e) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: getReturnAppBar(height, false, 'Frage', mainPurpleScheme),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                setState(() {
                  _showQuestion = !_showQuestion;
                });
              },
              child: Row(children: [
                const SizedBox(
                  width: 15,
                ),
                Icon(_showQuestion
                    ? Icons.arrow_downward_sharp
                    : Icons.arrow_upward_sharp),
                const SizedBox(width: 5),
                const Text(
                  'Frage:',
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
            _showQuestion
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: CustomBox(
                            color: mainPurpleScheme,
                            height: 120,
                            width: double.infinity,
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.question.title,
                                      style: TextStyle(
                                          color: mainFontColor, fontSize: 18),
                                    ),
                                    Divider(
                                      color: mainFontColor,
                                      thickness: 2,
                                      endIndent: 30,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      widget.question.description,
                                      style: TextStyle(color: mainFontColor),
                                    )
                                  ],
                                ),
                              ),
                            )),
                      ),
                      image
                    ],
                  )
                : const SizedBox(height: 15),
            GestureDetector(
              onTap: () {
                setState(() {
                  _showAnswers = !_showAnswers;
                });
              },
              child: Row(children: [
                const SizedBox(
                  width: 15,
                ),
                Icon(_showAnswers
                    ? Icons.arrow_downward_sharp
                    : Icons.arrow_upward_sharp),
                const SizedBox(width: 5),
                const Text(
                  'Antworten:',
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
            _showAnswers
                ? Column(
                    children: answerBoxes,
                  )
                : const SizedBox(height: 15),
            Row(children: [
              const SizedBox(
                width: 15,
              ),
              const Text(
                'Antwort Schreiben:',
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
                  color: mainPurpleScheme,
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
                              controller: _answerController,
                              enableSuggestions: true,
                              maxLines: 5,
                              decoration: InputDecoration(
                                constraints: BoxConstraints(
                                    maxHeight: 140, maxWidth: width * 0.7),
                                hintText: 'Antwort Schreiben',
                                hintStyle: TextStyle(color: mainFontColor),
                                border: InputBorder.none,
                              ),
                              style: TextStyle(color: mainFontColor),
                            ))
                      ])),
            ),
            Row(children: [
              const SizedBox(
                width: 15,
              ),
              const Text(
                'Anhänge:',
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
              child: ButtonBox(
                icon: const Icon(Icons.upload_file),
                text: 'Hier klicken für Anhang',
                onTap: () {
                  pickSomeFiles();
                },
                color: mainPurpleScheme,
                width: double.infinity,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Center(
                child: _image == null
                    ? const Text('Kein Bild ausgewählt.')
                    : CustomBox(
                        height: 200,
                        width: double.infinity,
                        color: mainPurpleScheme,
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Image.file(
                              _image!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 20),
            Divider(
              thickness: 3,
              indent: 15,
              endIndent: 15,
              color: mainFontColor,
            ),
            // _getCreateButton(),
            const Padding(
              padding: EdgeInsets.all(10.0),
/*
            child: Text(
              somethingWentWrong
                  ? 'Etwas ist schiefgelaufen! Versuchen Sie es später erneut!'
                  : '',
              style: const TextStyle(color: Colors.red),
            ),
            */
            ),
            isLoading
                ? const CircularProgressIndicator()
                : Padding(
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
                    child: ButtonBox(
                        color: mainPurpleScheme,
                        width: double.infinity,
                        icon: const Icon(Icons.task_alt_outlined),
                        text: 'Antwort Abgeben',
                        onTap: () async {
                          setState(() {
                            isLoading = true;
                          });
                          try {
                            final Storage storage = Storage();
                            storage.uploadFile(path, fileName);

                            answersGiven += 1;
                            box.put('answersGiven', answersGiven);

                            await FirebaseFirestore.instance
                            .collection('Users')
                            .doc(docID)
                            .update({
                              'answersGiven': answersGiven.toString()
                            });

                            await FirebaseFirestore.instance
                                .collection(
                                    'Majors/Informatik/Datenbanken/QA/Answers')
                                .add({
                              'title': widget.question.title,
                              'content': _answerController.text.trim(),
                              'createdAt': DateTime.now(),
                              'id': docID,
                              'name': '$firstName $lastName',
                              'imagePath':
                                  fileName.isEmpty ? '' : 'Bilder/$fileName'
                            });
                            if (mounted) {
                              Navigator.of(context).pop();
                            }
                          } catch (e) {
                            return;
                          }
                          setState(() {
                            isLoading = false;
                          });
                        }),
                  ),
            const SizedBox(height: 20)
          ],
        ),
      ),
    );
  }
}
