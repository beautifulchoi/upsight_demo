import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  late String name;
  late String user_id;
  late String user_pw;
  late String user_number;
  late String user_email;
  late String user_address;
  late DocumentReference? reference;

  User({
    required this.name,
    required this.user_id,
    required this.user_pw,
    required this.user_number,
    required this.user_email,
    required this.user_address,
    this.reference,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'user_id': user_id,
      'user_pw': user_pw,
      'user_number': user_number,
      'user_email': user_email,
      'user_address': user_address,
    };
  }

  User.fromMap(Map<dynamic, dynamic>? map) {
    name = map?['name'];
    user_id = map?['user_id'];
    user_pw = map?['user_pw'];
    user_number = map?['user_number'];
    user_email = map?['user_email'];
    user_address = map?['user_address'];
  }


  User.fromSnapshot(DocumentSnapshot document) {
    Map<String, dynamic> map = document.data() as Map<String, dynamic>;
    name = map['name'];
    user_id = map['user_id'];
    user_pw = map['user_pw'];
    user_number = map['user_number'];
    user_email = map['user_email'];
    user_address = map['user_address'];
    reference = document.reference;
  }
}