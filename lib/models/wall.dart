import 'package:cloud_firestore/cloud_firestore.dart';

class Wall {
  late String space;
  late int number;
  late String tag;
  late String content;
  late String author;
  late String create_date;
  late String modify_date;
  late DocumentReference? reference;

  Wall({
    required this.space,
    required this.number,
    required this.tag,
    required this.content,
    required this.author,
    required this.create_date,
    required this.modify_date,
    this.reference
  });

  Map<String, dynamic> toMap() {
    return {
      'space': space,
      'number': number,
      'tag': tag,
      'content': content,
      'author': author,
      'create_date': create_date,
      'modify_date': modify_date,
    };
  }

  Wall.fromMap(Map<dynamic, dynamic>? map) {
    space = map?['space'];
    number = map?['number'];
    tag = map?['tag'];
    content = map?['content'];
    author = map?['author'];
    create_date = map?['create_date'];
    modify_date = map?['modify_date'];
  }

  Wall.fromSnapshot(DocumentSnapshot document) {
    Map<String, dynamic> map = document.data() as Map<String, dynamic>;
    space = map['space'];
    number = map['number'];
    tag = map['tag'];
    content = map['content'];
    author = map['author'];
    create_date = map['create_date'];
    modify_date = map['modify_date'];
  }
}