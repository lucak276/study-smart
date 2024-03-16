import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:study_smart/utils/get_appbar.dart';
import 'package:study_smart/utils/globals.dart';


class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool isLoading = false;

  final _oldPasswordController= TextEditingController();
  final _newPasswordController= TextEditingController();
  final _repeatPasswordController= TextEditingController();

  bool hideOldPasswd = true;
  bool hideNewPasswd = true;
  bool hideRepeatPasswd = true;

  bool oldPasswordWrong = false;
  bool newPasswordWrong = false;
  bool repeatPasswordWrong = false;

  bool changeSuccessful = false;
  bool somethingWentWrong = false;

  bool showChangePassword = false;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _oldPasswordController.dispose();
    _repeatPasswordController.dispose();

    super.dispose();
  }

  void _resetValidate() {
    setState(() {
      oldPasswordWrong = false;
      newPasswordWrong = false;
      repeatPasswordWrong = false;
    });
  }

  void _validate() {
    if (_oldPasswordController.text != password) {
      setState(() {
        oldPasswordWrong = true;
      });
    }
    if (_newPasswordController.text == password) {
      setState(() {
        newPasswordWrong = true;
      });
    }
    if (_repeatPasswordController.text != _newPasswordController.text) {
      setState(() {
        repeatPasswordWrong = true;
      });
    }
  }

  Widget _changeButton() {
    return isLoading
    ? const CircularProgressIndicator()
    : ElevatedButton(
      onPressed: _changePassword,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25)
        )
      ),
      child: Container(
        width: 300,
        height: 60,
        alignment: Alignment.center,
        child: Text(
          'Bestätigen',
          style: TextStyle(
            fontSize: 18,
            color: mainFontColor
          ),
        ),
      ),
    ); 
  }

  void _changePassword() async {
    setState(() {
      isLoading = true;
    });

    _resetValidate();
    _validate();

    if (oldPasswordWrong || newPasswordWrong || repeatPasswordWrong) {
      setState(() {
        isLoading = false;
      });
      return;
    }
    var user = FirebaseAuth.instance.currentUser;

    if(user != null) {
      password = _newPasswordController.text.trim();
      user.updatePassword(_newPasswordController.text.trim()).then((_){
        _newPasswordController.clear();
        _oldPasswordController.clear();
        _repeatPasswordController.clear();
        setState(() {
          changeSuccessful = true;
          somethingWentWrong = false;
          isLoading = false;
        });
      }).catchError((error){
        setState(() {
          changeSuccessful = false;
          somethingWentWrong = true;
          isLoading = false;
        });
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: getReturnAppBar(height, false, 'Passwort Ändern', mainGreenScheme),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 25, 20, 5),
              child: TextField(
                controller: _oldPasswordController,
                obscureText: hideOldPasswd,
                enableSuggestions: true,
                decoration: InputDecoration( 
                  constraints: const BoxConstraints(
                    maxHeight: 60,
                    maxWidth: 300
                  ),
                  hintText: 'Altes Passwort',
                  hintStyle: TextStyle(
                    color: mainFontColor
                  ),
                  errorText: oldPasswordWrong ? 'Falsches Passwort' : null,
                  suffix: IconButton(
                    onPressed: () { 
                      setState(() { 
                        if(hideOldPasswd) { 
                          hideOldPasswd = false;
                        }
                        else {
                          hideOldPasswd = true;
                        }
                      });
                    }, 
                    icon: Icon(
                      hideOldPasswd == true ? Icons.remove_red_eye : Icons.password,
                      color: mainFontColor,  
                    )
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(width: 1, color: mainColorScheme)
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(width: 1, color: mainColorScheme)
                  ),
                ),
                style: TextStyle(
                  color: mainFontColor
                ),
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: TextField(
                controller: _newPasswordController,
                obscureText: hideNewPasswd,
                enableSuggestions: true,
                decoration: InputDecoration( 
                  constraints: const BoxConstraints(
                    maxHeight: 60,
                    maxWidth: 300
                  ),
                  hintText: 'Neues Passwort',
                  hintStyle: TextStyle(
                    color: mainFontColor
                  ),
                  errorText: newPasswordWrong ? 'Neues Passwort kann nicht altes Passwort sein' : null,
                  suffix: IconButton(
                    onPressed: () { 
                      setState(() { 
                        if(hideNewPasswd) { 
                          hideNewPasswd = false;
                        }
                        else {
                          hideNewPasswd = true;
                        }
                      });
                    }, 
                    icon: Icon(
                      hideNewPasswd == true ? Icons.remove_red_eye : Icons.password,
                      color: mainFontColor,  
                    )
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(width: 1, color: mainColorScheme)
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(width: 1, color: mainColorScheme)
                  ),
                ),
                style: TextStyle(
                  color: mainFontColor
                ),
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: TextField(
                controller: _repeatPasswordController,
                obscureText: hideRepeatPasswd,
                enableSuggestions: true,
                decoration: InputDecoration( 
                  constraints: const BoxConstraints(
                    maxHeight: 60,
                    maxWidth: 300
                  ),
                  hintText: 'Neues Passwort wiederholen',
                  hintStyle: TextStyle(
                    color: mainFontColor
                  ),
                  errorText: repeatPasswordWrong ? 'Passwörter stimmen nicht überein' : null,
                  suffix: IconButton(
                    onPressed: () { 
                      setState(() { 
                        if(hideRepeatPasswd) { 
                          hideRepeatPasswd = false;
                        }
                        else {
                          hideRepeatPasswd = true;
                        }
                      });
                    }, 
                    icon: Icon(
                      hideRepeatPasswd == true ? Icons.remove_red_eye : Icons.password,
                      color: mainFontColor,  
                    )
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(width: 1, color: mainColorScheme)
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(width: 1, color: mainColorScheme)
                  ),
                ),
                style: TextStyle(
                  color: mainFontColor
                ),
              ),
            ),
            const SizedBox(height: 15),
            _changeButton(),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                somethingWentWrong
                ? 'Etwas ist schiefgelaufen! Versuchen Sie es später erneut!'
                : '',
                style: const TextStyle(
                  color: Colors.red
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                changeSuccessful
                ? 'Passwort erfolgreich geändert!'
                : '',
                style: const TextStyle(
                  color: Colors.green
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}