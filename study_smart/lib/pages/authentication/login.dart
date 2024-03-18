import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:study_smart/pages/landing.dart';
import 'package:study_smart/utils/globals.dart';
import 'package:study_smart/utils/swipe_right_transition.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool isLoading = false;
  bool wrongPassword = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  Future signIn() async {
    setState(() {
      isLoading = true;
    });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      var querySnapshot =
          await FirebaseFirestore.instance.collection('Users').get();

      for (var queryDocumentSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data = queryDocumentSnapshot.data();
        if (data['email'] == _emailController.text.trim()) {
          docID = queryDocumentSnapshot.id;
          firstName = data['firstName'];
          lastName = data['lastName'];
          uni = data['uni'];
          joined = toDateTime(data['joined']);
          major = data['major'];
          questionsAsked = int.parse(data['questionsAsked']);
          answersGiven = int.parse(data['answersGiven']);
          exercisesSolved = int.parse(data['exercisesSolved']);
          minutesLearned = int.parse(data['minutesLearned']);
        }
      }

      if (mounted) {
        email = _emailController.text.trim();
        password = _passwordController.text.trim();
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
        wrongPassword = true;
        isLoading = false;
      });
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
            'Willkommen zurück!',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColorScheme,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              )),
        ),
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
                const Expanded(child: Text('')),
                isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: signIn,
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25))),
                        child: Container(
                          width: 250,
                          height: 60,
                          alignment: Alignment.center,
                          child: Text(
                            'Login',
                            style:
                                TextStyle(fontSize: 18, color: mainFontColor),
                          ),
                        ),
                      ),
                const SizedBox(height: 150)
              ],
            ),
          )
        ]))));
  }
}
