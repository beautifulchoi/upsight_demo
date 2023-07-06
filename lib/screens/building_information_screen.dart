/*
건물(building)의 정보 조회 화면을 보여주는 page
 */

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:board_project/models/building.dart';
import 'package:board_project/providers/building_firestore.dart';
import 'package:board_project/screens/building_detail_screen.dart';

class BuildingInformationScreen extends StatefulWidget {
  // building_board_screen에서 전달받는 해당 building 데이터
  final Building data;
  // building_board_screen에서 전달받는 해당 buildingId 데이터
  final String dataId;
  BuildingInformationScreen({required this.data, required this.dataId});

  _BuildingInformationScreenState createState() => _BuildingInformationScreenState();
}

class _BuildingInformationScreenState extends State<BuildingInformationScreen> {
  BuildingFirebase buildingFirebase = BuildingFirebase();

  // 전달받은 building 데이터 저장할 변수
  late Building buildingData;
  // 전달받은 buildingId 데이터 저장할 변수
  late String buildingId;

  @override
  void initState() {
    // 전달받은 building 데이터 저장
    buildingData = widget.data;
    // 전달받은 buildingId 데이터 저장
    buildingId = widget.dataId;
    setState(() {
      buildingFirebase.initDb();
    });
  }

  // 위젯을 만들고 화면에 보여주는 함수
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar 구현 코드
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('건물 정보 조회'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // 건물 이름
            Container(
              padding: EdgeInsets.all(8),
              width: double.infinity,
              child: Text(
                buildingData.name,
                style: TextStyle(fontWeight: FontWeight.bold),
                textScaleFactor: 1.4,
                textAlign: TextAlign.start,
              ),
            ),
            Divider(
              thickness: 1,
            ),
            // 건물 상세 정보 보기
            ListTile(
              title: Text("건물 상세 정보 조회 및 수정"),
              subtitle: Text(buildingData.address),
              onTap: () {
                // 건물의 상세화면을 보여주는 screen으로 화면 전환(인자: 해당 건물 데이터, 해당 건물의 document Id)
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (BuildContext context) => BuildingDetailScreen(data: buildingData, dataId: buildingId)),
                );
              },
            ),
            Divider(
              thickness: 1,
            ),
            // 공간 구성도
            ListTile(
              title: Text("공간 구성도"),
              subtitle: Text("세부 공간을 클릭하여 내용을 조회하고 수정합니다."),
            ),
            Container(
              width: 345.32,
              height: 284.20,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                shadows: [
                  BoxShadow(
                    color: Color(0x19000000),
                    blurRadius: 4,
                    offset: Offset(0, 0),
                    spreadRadius: 2,
                  )
                ],
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text('내용이 없습니다.', textAlign: TextAlign.center,),
              ),
            ),
            Divider(
              thickness: 1,
            ),
            // 세부 공간 추가하기
            ListTile(
              title: Text("세부 공간 추가하기"),
              subtitle: Text("추가할 세부 공간의 타일을 선택해주세요."),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {

                  },
                  child: Container(
                    width: 157.59,
                    height: 157.38,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      shadows: [
                        BoxShadow(
                          color: Color(0x19000000),
                          blurRadius: 4,
                          offset: Offset(0, 0),
                          spreadRadius: 2,
                        )
                      ],
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text('닫힌 공간', textAlign: TextAlign.center,),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(25.0), // 패딩 값 조정 가능
                  child: InkWell(
                    onTap: () {

                    },
                    child: Container(
                      width: 157.59,
                      height: 157.38,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        shadows: [
                          BoxShadow(
                            color: Color(0x19000000),
                            blurRadius: 4,
                            offset: Offset(0, 0),
                            spreadRadius: 2,
                          )
                        ],
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text('열린 공간', textAlign: TextAlign.center,),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      )
    );
  }
}