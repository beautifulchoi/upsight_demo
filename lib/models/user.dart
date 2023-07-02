import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  late String name;
  late DocumentReference? reference;

  User({
    required this.name,
    this.reference,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }

  User.fromMap(Map<dynamic, dynamic>? map) {
    name = map?['name'];
  }


  User.fromSnapshot(DocumentSnapshot document) {
    Map<String, dynamic> map = document.data() as Map<String, dynamic>;
    name = map['name'];
    reference = document.reference;
  }
}