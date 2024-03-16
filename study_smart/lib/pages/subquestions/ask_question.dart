// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:study_smart/utils/box.dart';
import 'package:study_smart/utils/globals.dart';
import 'package:study_smart/utils/storage_service.dart';

class AskQuestion extends StatefulWidget {
  const AskQuestion({Key? key}) : super(key: key);

  @override
  State<AskQuestion> createState() => _AskQuestionState();
}

class _AskQuestionState extends State<AskQuestion> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  File? _image = null;
  String path = '';
  String fileName = '';

  DateTime selectedDate = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day, 0, 0, 0, 0);

  bool isLoading = false;
  bool somethingWentWrong = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
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

  _getCreateButton() {
    return isLoading
        ? const CircularProgressIndicator()
        : Padding(
            padding: const EdgeInsets.all(15),
            child: ButtonBox(
                color: mainPurpleScheme,
                width: double.infinity,
                icon: const Icon(Icons.task_alt_outlined),
                text: 'Frage stellen',
                onTap: () async {
                  try {
                    final Storage storage = Storage();
                    storage.uploadFile(path, fileName);
                    await FirebaseFirestore.instance
                        .collection('Majors')
                        .doc(major)
                        .collection(lesson)
                        .doc('QA')
                        .collection('Questions')
                        .add({
                      'title': _titleController.text.trim(),
                      'description': _descriptionController.text.trim(),
                      'createdAt': selectedDate,
                      'id': docID,
                      'imagePath': fileName.isEmpty ? '' : 'Bilder/$fileName'
                    });

                    questionsAsked += 1;
                    box.put('questionsAsked', questionsAsked);

                    await FirebaseFirestore.instance
                    .collection('Users')
                    .doc(docID)
                    .update({
                      'questionsAsked': questionsAsked.toString()
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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: mainPurpleScheme,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          const SizedBox(height: 20),
          Row(children: [
            const SizedBox(
              width: 15,
            ),
            const Text(
              'Titel der Frage:',
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
              height: 60,
              width: double.infinity,
              child: Row(
                children: [
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
                        hintText: 'Titel',
                        hintStyle: TextStyle(color: mainFontColor),
                      ),
                      style: TextStyle(color: mainFontColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
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
                            fit: BoxFit
                                .cover, // <-- Anpassen der Größe des Bildes an die Größe der CustomBox
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
        ]),
      ),
    );
  }
}
