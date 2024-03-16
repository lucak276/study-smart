// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:study_smart/pages/authentication/set_name.dart';
import 'package:study_smart/pages/subprofile/change_password.dart';
import 'package:study_smart/utils/box.dart';
import 'package:study_smart/utils/get_appbar.dart';
import 'package:study_smart/utils/globals.dart';
import 'package:study_smart/utils/swipe_right_transition.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _majorController = TextEditingController();
  final _uniController = TextEditingController();

  bool isLoading = false;
  bool wrongEmail = false;
  bool wrongName = false;
  bool _boxExpanded = false;

  List<Widget> majorWidgets = [];

  @override
  void initState() {
    super.initState();

    _nameController.text = '$firstName $lastName';
    _emailController.text = email;
    _majorController.text = major;
    _uniController.text = uni;

    _fetchMajors();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _majorController.dispose();
    _uniController.dispose();

    super.dispose();
  }

  _fetchMajors() async {
    var querySnapshot = await FirebaseFirestore.instance
          .collection('Majors')
          .get();

    for (var queryDocumentSnapshot in querySnapshot.docs) {
      majorWidgets.add(
        ListTile(
          onTap: () async {
            setState(() {
              major = queryDocumentSnapshot.id;
              _boxExpanded = !_boxExpanded;
            });
            box.put('major', major);

            await FirebaseFirestore.instance
            .collection('Users')
            .doc(docID)
            .update({'major': major});
          },
          title: Text(queryDocumentSnapshot.id),
        )
      );
      majorWidgets.add(
        const Divider(indent: 10, endIndent: 10)
      );
    }
    majorWidgets.add(const SizedBox(height: 5));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: getReturnAppBar(height, false, 'Konto Bearbeiten', mainGreenScheme),
      body: SingleChildScrollView(
        child: Column(children: [
          const SizedBox(height: 20),
          Row(children: [
            const SizedBox(
              width: 15,
            ),
            const Text(
              'Kontoinformationen:',
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
          const SizedBox(height: 10),
          CustomBox(
            color: mainGreenScheme,
            height: 60,
            width: width * 0.9,
            child: Row(children: [
              const Padding(
                padding: EdgeInsets.only(left: 10, right: 5),
                child: Icon(Icons.edit),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                child: TextField(
                  controller: _nameController,
                  enableSuggestions: true,
                  decoration: InputDecoration(
                      constraints:
                          BoxConstraints(maxHeight: 60, maxWidth: width * 0.7),
                      border: InputBorder.none,
                      hintText: 'Name',
                      hintStyle: TextStyle(color: mainFontColor),
                      errorText: wrongName
                          ? 'Bitte gib einen Vor- und Nachnamen an!'
                          : null),
                  style: TextStyle(color: mainFontColor),
                  onSubmitted: (value) async {
                    String fullName = _nameController.text.trim();
                    List<String> nameParts = fullName.split(' ');

                    if (nameParts.length >= 2) {
                      String fName = nameParts[0];
                      String lName = nameParts[nameParts.length - 1];
                      await FirebaseFirestore.instance
                          .collection('Users')
                          .doc(docID)
                          .update({'firstName': fName, 'lastName': lName});
                      setState(() {
                        firstName = fName;
                        lastName = lName;
                        wrongName = false;
                      });
                    } else {
                      setState(() {
                        wrongName = false;
                      });
                    }
                  },
                ),
              ),
            ]),
          ),
          const SizedBox(height: 10),
          CustomBox(
            color: mainGreenScheme,
            height: 60,
            width: width * 0.9,
            child: Row(children: [
              const Padding(
                padding: EdgeInsets.only(left: 10, right: 5),
                child: Icon(Icons.edit),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                child: TextField(
                  controller: _emailController,
                  enableSuggestions: true,
                  decoration: InputDecoration(
                      constraints:
                          BoxConstraints(maxHeight: 60, maxWidth: width * 0.7),
                      border: InputBorder.none,
                      hintText: 'Email',
                      hintStyle: TextStyle(color: mainFontColor),
                      errorText: wrongEmail
                          ? 'Email konnte nicht geändert werden'
                          : null),
                  style: TextStyle(color: mainFontColor),
                  onSubmitted: (value) async {
                    try {
                      var user = FirebaseAuth.instance.currentUser;

                      password = _emailController.text.trim();
                      user!.updateEmail(_emailController.text.trim());
                      await FirebaseFirestore.instance
                          .collection('Users')
                          .doc(docID)
                          .update({
                        'email': _emailController.text.trim(),
                      });
                      setState(() {
                        email = _emailController.text.trim();
                        wrongEmail = false;
                      });
                    } catch (e) {
                      setState(() {
                        wrongEmail = true;
                      });
                      return;
                    }
                  },
                ),
              ),
            ]),
          ),
          const SizedBox(height: 10),
          CustomBox(
            color: mainGreenScheme,
            height: 60,
            width: width * 0.9,
            child: Row(children: [
              const Padding(
                padding: EdgeInsets.only(left: 10, right: 5),
                child: Icon(Icons.edit),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                child: TextField(
                  controller: _uniController,
                  enableSuggestions: true,
                  decoration: InputDecoration(
                    constraints:
                        BoxConstraints(maxHeight: 60, maxWidth: width * 0.7),
                    border: InputBorder.none,
                    hintText: 'Universität/Hochschule',
                    hintStyle: TextStyle(color: mainFontColor),
                  ),
                  style: TextStyle(color: mainFontColor),
                  onSubmitted: (value) async {
                    try {
                      await FirebaseFirestore.instance
                          .collection('Users')
                          .doc(docID)
                          .update({
                        'uni': _uniController.text.trim(),
                      });
                      setState(() {
                        uni = _uniController.text.trim();
                      });
                    } catch (e) {
                      return;
                    }
                  },
                ),
              ),
            ]),
          ),
          const SizedBox(height: 10),
          CustomBox(
            height: 60,
            width: width * 0.9,
            color: mainGreenScheme,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _boxExpanded = !_boxExpanded;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      major
                    ),
                    Icon(
                      _boxExpanded ? Icons.arrow_downward_outlined : Icons.arrow_upward_outlined
                    )
                  ],
                ),
              ),
            ),
          ),
          Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: 20),
                  Row(children: [
                    const SizedBox(
                      width: 15,
                    ),
                    const Text(
                      'Kontoverwaltung:',
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
                  const SizedBox(height: 10),
                  ButtonBox(
                      color: mainGreenScheme,
                      width: width * 0.9,
                      icon: const Icon(Icons.password_outlined),
                      text: 'Passwort ändern',
                      onTap: () {
                        Navigator.push(
                          context,
                          SwipeRightTransition(
                            widget: const ChangePassword(),
                          ),
                        );
                      }),
                  const SizedBox(height: 10),
                  ButtonBox(
                      color: mainRedScheme,
                      width: width * 0.9,
                      icon: const Icon(Icons.logout_outlined),
                      text: 'Abmelden',
                      onTap: () {
                        resetVariables();
                        FirebaseAuth.instance.signOut();
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const SetName()));
                      }),
                  const SizedBox(height: 10),
                  ButtonBox(
                    color: mainRedScheme,
                    width: width * 0.9,
                    icon: const Icon(Icons.delete_outlined),
                    text: 'Konto löschen',
                    onTap: () {
                      try {
                        resetVariables();
                        // TODO delete from Firestore
                        FirebaseAuth.instance.currentUser!.delete();
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const SetName()));
                      } catch (e) {
                        return;
                      }
                    }
                  ),
                ],
              ),
              if (_boxExpanded)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: mainColorScheme),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: SingleChildScrollView(
                      child: Column(
                        children: majorWidgets,
                      ),
                    ),
                  ),
                )
              ),
            ],
          ),
          const SizedBox(height: 10),
        ]),
      ),
    );
  }
}
