import 'package:cloud_firestore/cloud_firestore.dart';

class Space {
  late String building;
  late String name;
  late bool type;
  late String author;
  late String create_date;
  late String modify_date;
  late DocumentReference? reference;

  Space({
    required this.building,
    required this.name,
    required this.type,
    required this.author,
    required this.create_date,
    required this.modify_date,
    this.reference
  });

  Map<String, dynamic> toMap() {
    return {
      'building': building,
      'name': name,
      'type': type,
      'author': author,
      'create_date': create_date,
      'modify_date': modify_date,
    };
  }

  Space.fromMap(Map<dynamic, dynamic>? map) {
    building = map?['building'];
    name = map?['name'];
    type = map?['type'];
    author = map?['author'];
    create_date = map?['create_date'];
    modify_date = map?['modify_date'];
  }

  Space.fromSnapshot(DocumentSnapshot document) {
    Map<String, dynamic> map = document.data() as Map<String, dynamic>;
    building = map['building'];
    name = map['name'];
    type = map['type'];
    author = map['author'];
    create_date = map['create_date'];
    modify_date = map['modify_date'];
  }
}