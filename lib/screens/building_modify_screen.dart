/*
건물(building) 수정하는 page
 */

import 'package:board_project/screens/building_detail_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:board_project/models/building.dart';
import 'package:board_project/providers/building_firestore.dart';
import 'package:intl/intl.dart';

class BuildingModifyScreen extends StatefulWidget {
  // building_detail_screen에서 전달받는 해당 building 데이터
  final Building data;
  BuildingModifyScreen({required this.data});

  _BuildingModifyScreenState createState() => _BuildingModifyScreenState();
}

class _BuildingModifyScreenState extends State<BuildingModifyScreen> {
  BuildingFirebase buildingFirebase = BuildingFirebase();
  // 전달받은 building 데이터 저장할 변수
  late Building buildingData;
  // 전달받은 building 데이터의 DocumentSnapshot id 저장할 변수
  late String document;

  _BuildingModifyScreenState() {
    buildingFirebase.initDb();
  }

  @override
  void initState() {
    super.initState();
    // 전달받은 building 데이터 저장
    buildingData = widget.data;
    // 해당 building 데이터의 snapshot 저장
    fetchBuildingData();
  }

  // 해당 building 데이터의 snapshot 저장하는 함수
  void fetchBuildingData() async {
    // 수정할 building 데이터의 DocumentSnapshot() 찾아서 저장
    QuerySnapshot snapshot = await buildingFirebase.buildingReference
        .where('name', isEqualTo: buildingData.name)
        .where('address', isEqualTo: buildingData.address)
        .where('content', isEqualTo: buildingData.content)
        .where('create_date', isEqualTo: buildingData.create_date)
        .get();

    if (snapshot.docs.isNotEmpty) {
      document = snapshot.docs.first.id;
      setState(() {});
    }
  }

  // 위젯을 만들고 화면에 보여주는 함수
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar 구현 코드
      appBar: AppBar(
        // 뒤로가기 버튼 삭제
        automaticallyImplyLeading: false,
        backgroundColor: Colors.red,
        title: Text('건물 상세 정보 수정'),
      ),
      // appBar 아래 UI 구현 코드
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              // name 값이 변경되었는지 확인하여 입력 받은 데이터 저장
              onChanged: (value) {
                buildingData.name = value;
              },
              // 입력하려고 하면 작아지면서 위로 올라가는 애니메이션? UI 코드
              decoration: InputDecoration(
                hintText: buildingData.name,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              onChanged: (value) {
                buildingData.address = value;
              },
              decoration: InputDecoration(
                hintText: buildingData.address,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              onChanged: (value) {
                buildingData.content = value;
              },
              decoration: InputDecoration(
                hintText: buildingData.content,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              onChanged: (value) {
                buildingData.author = value;
              },
              decoration: InputDecoration(
                hintText: buildingData.author,
              ),
            ),
            SizedBox(height: 16),
            // 건물 수정 완료 버튼
            OutlinedButton(
              onPressed: () async {
                // 모든 필드가 작성되었는지 확인
                if (buildingData.name.isNotEmpty && buildingData.address.isNotEmpty && buildingData.content.isNotEmpty) {
                  // 입력받은 데이터로 새로운 building 데이터 생성하여 DB에 업데이트
                  Building newBuilding = Building(
                    name: buildingData.name,
                    address: buildingData.address,
                    content: buildingData.content,
                    author: buildingData.author,
                    create_date: buildingData.create_date,
                    modify_date: DateFormat('yy/MM/dd/HH/mm/ss').format(DateTime.now()),
                    bookmark: buildingData.bookmark,
                    reference: buildingData.reference,
                  );
                  await buildingFirebase.updateBuilding(newBuilding);
                  await buildingFirebase.buildingReference.doc(document).update({
                    'name': buildingData.name,
                    'address': buildingData.address,
                    'content': buildingData.content,
                    'author': buildingData.author,
                    'create_date': buildingData.create_date,
                    'modify_date': DateFormat('yy/MM/dd/HH/mm/ss').format(DateTime.now()),
                    'bookmark': buildingData.bookmark,
                  });
                  // 수정된 building 데이터를 가지고 건물 list screen으로 전환
                  Navigator.pushNamed(context, '/building', arguments: newBuilding);
                } else {
                  // 작성되지 않은 필드가 있다면 dialog 띄움
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('입력 오류'),
                        content: Text('모든 필드를 입력해주세요.'),
                        actions: [
                          TextButton(
                            child: Text('확인'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text('수정 완료'),
            ),
            // 건물 수정 취소 버튼
            OutlinedButton(
                onPressed: () {
                  // 건물 list screen으로 전환
                  Navigator.pushNamed(context, '/building');
                },
                child: Text('취소'),
            ),
          ],
        ),
      )
    );
  }
}