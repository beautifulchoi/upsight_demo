import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:board_project/models/question.dart';
import 'dart:async';

class QuestionFirebase {
  late CollectionReference questionReference;
  late Stream<QuerySnapshot> questionStream;

  Future initDb() async {
    questionReference = FirebaseFirestore.instance.collection('question');
    questionStream = questionReference.snapshots();
  }

  List<Question> getQuestions(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data!.docs.map((DocumentSnapshot document) {
      return Question.fromSnapshot(document);
    }).toList();
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