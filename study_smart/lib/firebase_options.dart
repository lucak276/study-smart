// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBp-_yoSGMD860dO4lOlKqYUK4pN-bVnLA',
    appId: '1:956542968318:web:d0b7258ea7127e89bf60af',
    messagingSenderId: '956542968318',
    projectId: 'study-smart-cab90',
    authDomain: 'study-smart-cab90.firebaseapp.com',
    databaseURL:
        'https://study-smart-cab90-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'study-smart-cab90.appspot.com',
    measurementId: 'G-V8JKBXKSDR',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBz7T5zJvY_KT-DdV_mgHkiQw0r8Rfg_T0',
    appId: '1:956542968318:android:8fbc015dcbe02f06bf60af',
    messagingSenderId: '956542968318',
    projectId: 'study-smart-cab90',
    databaseURL:
        'https://study-smart-cab90-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'study-smart-cab90.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAi4KxoLQGXS6shQx6_g1RG1VBNX2BwtPE',
    appId: '1:956542968318:ios:4ab67e3ad87ddf8fbf60af',
    messagingSenderId: '956542968318',
    projectId: 'study-smart-cab90',
    databaseURL:
        'https://study-smart-cab90-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'study-smart-cab90.appspot.com',
    iosClientId:
        '956542968318-1sog3ju0p39uc29p4evuqte6qi4mjt47.apps.googleusercontent.com',
    iosBundleId: 'com.example.studySmart',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAi4KxoLQGXS6shQx6_g1RG1VBNX2BwtPE',
    appId: '1:956542968318:ios:4ab67e3ad87ddf8fbf60af',
    messagingSenderId: '956542968318',
    projectId: 'study-smart-cab90',
    databaseURL:
        'https://study-smart-cab90-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'study-smart-cab90.appspot.com',
    iosClientId:
        '956542968318-1sog3ju0p39uc29p4evuqte6qi4mjt47.apps.googleusercontent.com',
    iosBundleId: 'com.example.studySmart',
  );
}
