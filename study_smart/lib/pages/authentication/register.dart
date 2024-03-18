import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:study_smart/pages/authentication/login.dart';
import 'package:study_smart/pages/landing.dart';
import 'package:study_smart/utils/globals.dart';
import 'package:study_smart/utils/swipe_right_transition.dart';

class Register extends StatefulWidget {
  const Register({Key? key, required this.firstName, required this.lastName})
      : super(key: key);

  final String firstName;
  final String lastName;

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _uniController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  List<Widget> majorWidgets = [];

  bool _boxExpanded = false;

  bool isLoading = false;
  bool unavailableCredentials = false;

  @override
  void initState() {
    super.initState();

    _fetchMajors();
  }

  @override
  void dispose() {
    _uniController.dispose();
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  _fetchMajors() async {
    var querySnapshot =
        await FirebaseFirestore.instance.collection('Majors').get();

    for (var queryDocumentSnapshot in querySnapshot.docs) {
      majorWidgets.add(ListTile(
        onTap: () {
          setState(() {
            major = queryDocumentSnapshot.id;
            _boxExpanded = !_boxExpanded;
          });
        },
        title: Text(queryDocumentSnapshot.id),
      ));
      majorWidgets.add(const Divider(indent: 10, endIndent: 10));
    }
    majorWidgets.add(const SizedBox(height: 5));
  }

  Future register() async {
    if (_emailController.text.trim().isNotEmpty &&
        _passwordController.text.trim().isNotEmpty &&
        _uniController.text.trim().isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim());

        var querySnapshot =
            await FirebaseFirestore.instance.collection('Users').add({
          'email': _emailController.text.trim(),
          'firstName': widget.firstName,
          'lastName': widget.lastName,
          'uni': _uniController.text.trim(),
          'joined': DateTime.now(),
          'exercisesSolved': '0',
          'answersGiven': '0',
          'minutesLearned': '0',
          'questionsAsked': '0'
        });

        if (mounted) {
          uni = _uniController.text.trim();
          //  docID = querySnapshot.id;
          email = _emailController.text.trim();
          password = _passwordController.text.trim();
          firstName = widget.firstName;
          lastName = widget.lastName;
          joined = DateTime.now();
          loggedIn = true;

          saveToHive();

          Navigator.push(
            context,
            SwipeRightTransition(
              widget: const Landing(),
            ),
          );
        }
      } catch (e) {
        _emailController.clear();
        _passwordController.clear();
        setState(() {
          unavailableCredentials = true;
          isLoading = false;
        });
      }
    }
  }

  Widget _getText() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),
          Text(
            'Hey, ${widget.firstName}!',
            style: const TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Erstelle einen Benutzeraccount.',
            style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
                color: mainFontColor),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _getLoginButton() {
    return TextButton(
        onPressed: () {
          Navigator.push(
            context,
            SwipeRightTransition(
              widget: const Login(),
            ),
          );
        },
        child: Text(
          'Konto vorhanden? Einloggen',
          style: TextStyle(
            color: mainFontColor,
            fontSize: 15,
            fontWeight: FontWeight.w300,
            decoration: TextDecoration.underline,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: Center(
                child: CustomScrollView(slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                _getText(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: TextField(
                    controller: _uniController,
                    enableSuggestions: true,
                    decoration: InputDecoration(
                      hintText: 'Universität/Hochschule',
                      hintStyle: TextStyle(color: mainFontColor),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide:
                              BorderSide(width: 1, color: mainColorScheme)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide:
                              BorderSide(width: 1, color: mainColorScheme)),
                    ),
                    style: TextStyle(color: mainFontColor),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: TextField(
                    controller: _emailController,
                    enableSuggestions: true,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      hintStyle: TextStyle(color: mainFontColor),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide:
                              BorderSide(width: 1, color: mainColorScheme)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide:
                              BorderSide(width: 1, color: mainColorScheme)),
                    ),
                    style: TextStyle(color: mainFontColor),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: TextField(
                    controller: _passwordController,
                    enableSuggestions: true,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Passwort',
                      hintStyle: TextStyle(color: mainFontColor),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide:
                              BorderSide(width: 1, color: mainColorScheme)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide:
                              BorderSide(width: 1, color: mainColorScheme)),
                    ),
                    style: TextStyle(color: mainFontColor),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _boxExpanded = !_boxExpanded;
                        });
                      },
                      child: Container(
                        height: 60,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: mainColorScheme),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(major),
                              Icon(_boxExpanded
                                  ? Icons.arrow_downward_outlined
                                  : Icons.arrow_upward_outlined)
                            ],
                          ),
                        ),
                      ),
                    )),
                Stack(
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: 20),
                        //const Expanded(child: Text('')),
                        isLoading
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: register,
                                style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25))),
                                child: Container(
                                  width: 250,
                                  height: 60,
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Fertig',
                                    style: TextStyle(
                                        fontSize: 18, color: mainFontColor),
                                  ),
                                ),
                              ),
                        const SizedBox(height: 10),
                        _getLoginButton(),
                        const SizedBox(height: 10),
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
                          )),
                  ],
                ),
              ],
            ),
          )
        ]))));
  }
}
