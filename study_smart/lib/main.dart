import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:study_smart/firebase_options.dart';
import 'package:study_smart/pages/authentication/set_name.dart';
import 'package:study_smart/pages/landing.dart';

import 'package:study_smart/utils/error.dart';

import 'package:study_smart/utils/globals.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  /// Set the device orientation to landscape
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  /// Initialize Hive database. This is for storing user information locally on the given device
  await Hive.initFlutter();
  box = await Hive.openBox('userbox');

  getDBInformation();
  
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> firebaseApp =
        Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    return MaterialApp(
        title: 'Study Smart',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FutureBuilder(
          future: firebaseApp,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const ErrorPage();
            } else if (snapshot.hasData) {
              //signInTest();

              return const MyHomePage(title: 'Study Smart');
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    if (loggedIn) {
      return const Landing();
    } else {
      return const SetName();
    }
  }
}
