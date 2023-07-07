import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:board_project/models/wall.dart';
import 'dart:async';

class WallFirebase {
  late CollectionReference wallReference;
  late Stream<QuerySnapshot> wallStream;

  Future initDb() async {
    wallReference = FirebaseFirestore.instance.collection('wall');
    wallStream = wallReference.snapshots();
  }

  List<Wall> getWalls(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data!.docs.map((DocumentSnapshot document) {
      return Wall.fromSnapshot(document);
    }).toList();
  }

  Future addWall(Wall wall) async {
    wallReference.add(wall.toMap());
  }

  Future updateWall(Wall wall) async {
    wall.reference?.update(wall.toMap());
  }

  Future deleteWall(Wall wall) async {
    wall.reference?.delete();
  }
}