// ignore_for_file: avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class Storage {
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<void> uploadFile(String filePath, String fileName) async {
    File file = File(filePath);

    try {
      await storage.ref('Bilder/$fileName').putFile(file);
    } on firebase_core.FirebaseException {
      return;
    }
  }
}

class Database {
  static final db = FirebaseFirestore.instance;

  Future<void> saveQuestion(
      String questionPath, Map<String, dynamic> data) async {
    try {
      db.collection(questionPath).add(data).then((DocumentReference doc) =>
          print('DocumentSnapshot added with ID: ${doc.id}'));
    } on firebase_core.FirebaseException {
      return;
    }
  }
}
