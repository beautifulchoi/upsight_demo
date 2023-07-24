import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:board_project/models/question.dart';
import 'dart:async';

class QuestionFirebase {
  late FirebaseFirestore db;
  late CollectionReference questionReference;
  late Stream<QuerySnapshot> questionStream;

  Future initDb() async {
    db = FirebaseFirestore.instance;
    questionReference = FirebaseFirestore.instance.collection('question');
    questionStream = questionReference.snapshots();
  }

  Stream <List<Question>> getQuestions() {
    return questionReference.snapshots().map((list) =>
        list.docs.map((doc) =>
            Question.fromSnapshot(doc)).toList());
  }

  Future addQuestion(Question question) async {
    questionReference.add(question.toMap());
  }

  Future updateQuestion(Question question) async {
    question.reference?.update(question.toMap());
  }

  Future deleteQuestion(Question question) async {
    question.reference?.delete();
  }
}