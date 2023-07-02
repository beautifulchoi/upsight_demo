import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:board_project/models/question.dart';

class Answer {
  late String content;
  late String author;
  late String create_date;
  late String modify_date;
  late DocumentReference? reference;

  Answer({
    required this.content,
    required this.author,
    required this.create_date,
    required this.modify_date,
    this.reference,
  });

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'author': author,
      'create_date': create_date,
      'modify_date': modify_date,
    };
  }

  Answer.fromMap(Map<dynamic, dynamic>? map) {
    content = map?['content'];
    author = map?['author'];
    create_date = map?['create_date'];
    modify_date = map?['modify_date'];
  }

  Answer.fromSnapshot(DocumentSnapshot document) {
    Map<String, dynamic> map = document.data() as Map<String, dynamic>;
    content = map['content'];
    author = map['author'];
    create_date = map['create_date'];
    modify_date = map['modify_date'];
    reference = document.reference;
  }
}