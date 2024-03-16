/// All variables used in the whole project should be placed here
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:study_smart/pages/exercise.dart';
import 'package:study_smart/pages/questions.dart';
import 'package:study_smart/pages/tasks.dart';

/// Main color scheme must be initialized in main function
Color mainColorScheme = mainBlueScheme;
Color backgroundColorScheme = backgroundLightScheme;
Color thirdColorScheme = thirdLightScheme;
Color mainFontColor = lightFontColor;

/// Blue color schemes
Color mainBlueScheme = const Color(0xFF4E81BD);

/// Red color schemes
Color mainRedScheme = const Color(0xFFCD4545);

/// Red color schemes
Color mainGreenScheme = const Color(0xFF27AC2C);

/// Red color schemes
Color mainPurpleScheme = const Color(0xFFAF39B1);

/// Red color schemes
Color mainYellowScheme = const Color(0xFFECA72C);

/// Light color schemes
Color backgroundLightScheme = Colors.white;
Color thirdLightScheme = Colors.white54;
Color lightFontColor = Colors.black;
Color headerNavFontColor = Colors.white;

/// Dark color schemes
Color mainDarkScheme = Colors.black;
Color backgroundDarkScheme = Colors.black;
Color thirdDarkScheme = Colors.black;
Color darkFontColor = Colors.white;

/// Font Style
FontStyle mainFontStyle = FontStyle.normal;

/// Boolean that determines if dark mode is activated
/// True: Dark mode is activated
/// False: Light mode is activated
bool darkModeActivated = false;

/// Database box
/// Structure:
/// 'loggedIn':true
// ignore: prefer_typing_uninitialized_variables
var box;

/// Authentication credentials, saved at login/registration
String email = '';
String password = '';
String major = 'Studiengang';
String uni = '';
String lesson = '';
List<String> lessons = [];

/// DocID for user Firestore file
String docID = '';

/// Account information
String firstName = '';
String lastName = '';
DateTime joined = DateTime.now();

int exercisesSolved = 0;
int questionsAsked = 0;
int answersGiven = 0;
int minutesLearned = 0;

/// Shows if user is already logged in
bool loggedIn = false;

/// Contains all tasks loaded on Welcome page
List<Task> tasks = [];
List<Task> doneTasks = [];

List<Question> myQuestions = [];
List<Question> questions = [];

List<ExerciseSet> myExercises = [];
List<ExerciseSet> exercises = [];

/// Check in local hive storage if person is already logged in
Future getDBInformation() async {
  if (true) {
    if (box.get('loggedIn') != null) {
      loggedIn = box.get('loggedIn');
    }
    if (box.get('email') != null &&
        box.get('password') != null &&
        box.get('docID') != null) {
      email = box.get('email');
      password = box.get('password');
      docID = box.get('docID');

      if (box.get('firstName') != null &&
          box.get('lastName') != null &&
          box.get('joined') != null &&
          box.get('uni') != null &&
          box.get('major') != null &&
          box.get('lesson') != null) {
        firstName = box.get('firstName');
        lastName = box.get('lastName');
        joined = box.get('joined');
        uni = box.get('uni');
        major = box.get('major');
        lesson = box.get('lesson');
      }

      if (box.get('exercisesSolved') != null &&
          box.get('questionsAsked') != null &&
          box.get('answersGiven') != null &&
          box.get('minutesLearned') != null) {
        exercisesSolved = box.get('exercisesSolved');
        questionsAsked = box.get('questionsAsked');
        answersGiven = box.get('answersGiven');
        minutesLearned = box.get('minutesLearned');
      }

      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
      } catch (e) {
        loggedIn = false;
        resetVariables();
      }
    } else {
      loggedIn = false;
    }
  } else {
    loggedIn = true;
  }
}

void resetVariables() {
  loggedIn = false;
  email = '';
  password = '';
  docID = '';
  firstName = '';
  lastName = '';
  joined = DateTime.now();
  uni = '';
  major = 'Studiengang';
  lesson = '';
  exercisesSolved = 0;
  questionsAsked = 0;
  answersGiven = 0;
  minutesLearned = 0;
  saveToHive();
}

void saveToHive() {
  box.put('loggedIn', loggedIn);
  box.put('email', email);
  box.put('password', password);
  box.put('docID', docID);
  box.put('firstName', firstName);
  box.put('lastName', lastName);
  box.put('joined', joined);
  box.put('major', major);
  box.put('uni', uni);
  box.put('lesson', lesson);
  box.put('exercisesSolved', exercisesSolved);
  box.put('questionsAsked', questionsAsked);
  box.put('answersGiven', answersGiven);
  box.put('minutesLearned', minutesLearned);
}

DateTime toDateTime(Timestamp value) {
  return value.toDate();
}
