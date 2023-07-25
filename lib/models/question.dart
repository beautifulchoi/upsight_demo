import 'package:cloud_firestore/cloud_firestore.dart';

class Question {
  late String title;
  late String content;
  late String author;
  late String create_date;
  late String modify_date;
  late String category;
  late int views_count;
  late bool isLikeClicked;
  late DocumentReference? reference;
  late int answerCount;


  Question({
    required this.title,
    required this.content,
    required this.author,
    required this.create_date,
    required this.modify_date,
    required this.category,
    required this.views_count,
    required this.isLikeClicked,
    required this.answerCount,
    this.reference,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'author': author,
      'create_date': create_date,
      'modify_date': modify_date,
      'category': category,
      'views_count': views_count,
      'isLikeClicked': isLikeClicked,
      'answerCount': answerCount,
    };
  }

  Question.fromMap(Map<dynamic, dynamic>? map) {
    title = map?['title'];
    content = map?['content'];
    author = map?['author'];
    create_date = map?['create_date'];
    modify_date = map?['modify_date'];
    category = map?['category'];
    views_count = map?['views_count'];
    isLikeClicked = map?['isLikeClicked'];
    answerCount = map?['answerCount'];
  }


  Question.fromSnapshot(DocumentSnapshot document) {
    Map<String, dynamic> map = document.data() as Map<String, dynamic>;
    title = map['title'];
    content = map['content'];
    author = map['author'];
    create_date = map['create_date'];
    modify_date = map['modify_date'];
    category = map['category'];
    views_count = map['views_count'];
    isLikeClicked = map['isLikeClicked'];
    answerCount = map['answerCount'];

    reference = document.reference;
  }
}