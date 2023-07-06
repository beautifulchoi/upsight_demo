import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:board_project/models/building.dart';
import 'dart:async';

class BuildingFirebase {
  late CollectionReference buildingReference;
  late Stream<QuerySnapshot> buildingStream;

  Future initDb() async {
    buildingReference = FirebaseFirestore.instance.collection('building');
    buildingStream = buildingReference.snapshots();
  }

  List<Building> getBuildings(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data!.docs.map((DocumentSnapshot document) {
      return Building.fromSnapshot(document);
    }).toList();
  }

  Future addBuilding(Building building) async {
    buildingReference.add(building.toMap());
  }

  Future updateBuilding(Building building) async {
    building.reference?.update(building.toMap());
  }

  Future deleteBuilding(Building building) async {
    building.reference?.delete();
  }
}