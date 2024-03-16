import 'package:flutter/material.dart';
import 'package:study_smart/pages/authentication/login.dart';
import 'package:study_smart/pages/authentication/register.dart';
import 'package:study_smart/utils/globals.dart';
import 'package:study_smart/utils/swipe_right_transition.dart';

class SetName extends StatefulWidget {
  const SetName({Key? key}) : super(key: key);

  @override
  State<SetName> createState() => _SetNameState();
}

class _SetNameState extends State<SetName> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();

    super.dispose();
  }

  Widget _getText() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),
          Text(
            'Hey,',
            style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
                color: mainFontColor),
          ),
          Text(
            'wie dürfen wir dich nennen?',
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
        backgroundColor: backgroundColorScheme,
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
                    controller: _firstNameController,
                    enableSuggestions: true,
                    decoration: InputDecoration(
                      hintText: 'Vorname',
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
                    controller: _lastNameController,
                    enableSuggestions: true,
                    decoration: InputDecoration(
                      hintText: 'Nachname',
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
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      SwipeRightTransition(
                        widget: Register(
                          firstName: _firstNameController.text.trim(),
                          lastName: _lastNameController.text.trim(),
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25))),
                  child: Container(
                    width: 250,
                    height: 60,
                    alignment: Alignment.center,
                    child: Text(
                      'Weiter',
                      style: TextStyle(fontSize: 18, color: mainFontColor),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                _getLoginButton(),
                const SizedBox(height: 10),
              ],
            ),
          )
        ]))));
  }
}
