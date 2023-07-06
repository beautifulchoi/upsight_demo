import 'package:cloud_firestore/cloud_firestore.dart';

class Building {
  late String name;
  late String address;
  late String content;
  late String author;
  late String create_date;
  late String modify_date;
  late bool bookmark;
  late DocumentReference? reference;

  Building({
    required this.name,
    required this.address,
    required this.content,
    required this.author,
    required this.create_date,
    required this.modify_date,
    required this.bookmark,
    this.reference,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'content': content,
      'author': author,
      'create_date': create_date,
      'modify_date': modify_date,
      'bookmark': bookmark,
    };
  }

  Building.fromMap(Map<dynamic, dynamic>? map) {
    name = map?['name'];
    address = map?['address'];
    content = map?['content'];
    author = map?['author'];
    create_date = map?['create_date'];
    modify_date = map?['modify_date'];
    bookmark = map?['bookmark'];
  }

  Building.fromSnapshot(DocumentSnapshot document) {
    Map<String, dynamic> map = document.data() as Map<String, dynamic>;
    name = map['name'];
    address = map['address'];
    content = map['content'];
    author = map['author'];
    create_date = map['create_date'];
    modify_date = map['modify_date'];
    bookmark = map['bookmark'];
    reference = document.reference;
  }
}