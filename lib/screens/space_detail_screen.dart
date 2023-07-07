/*
공간(space)의 상세 화면을 보여주는 page
 */

import 'package:board_project/providers/wall_firestore.dart';
import 'package:board_project/screens/wall_create_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:board_project/models/space.dart';
import 'package:board_project/models/wall.dart';

class SpaceDetailScreen extends StatefulWidget {
  // building_information_screen에서 전달받는 해당 space 데이터
  final Space data;
  // building_information_screen에서 전달받는 해당 spaceId 데이터
  final String dataId;
  SpaceDetailScreen({required this.data, required this.dataId});

  _SpaceDetailScreenState createState() => _SpaceDetailScreenState();
}

class _SpaceDetailScreenState extends State<SpaceDetailScreen> {
  WallFirebase wallFirebase = WallFirebase();
  // DB에서 받아온 wall 컬렉션 데이터 담을 list
  List<Wall> walls = [];

  // 전달받은 space 데이터 저장할 변수
  late Space spaceData;
  // 전달받은 spaceId 데이터 저장할 변수
  late String spaceId;

  // 해당 space의 wall 데이터들 DocumentSnapshot 저장할 변수
  QuerySnapshot? wall_snapshot;
  // 해당 space의 wall 목록 길이 초기화
  int walls_null_len = 0;

  @override
  void initState() {
    super.initState();
    // 전달받은 space 데이터 저장
    spaceData = widget.data;
    // 전달받은 spaceId 데이터 저장
    spaceId = widget.dataId;
    setState(() {
      wallFirebase.initDb();
      // 해당 space의 wall 데이터의 snapshot 저장
      fetchData();
    });
  }

  // 해당 space의 wall 데이터의 snapshot 저장하는 함수
  Future<void> fetchData() async {
    // 해당 space의 wall 데이터의 DocumentSnapshot() 찾아서 저장
    wall_snapshot = await wallFirebase.wallReference
        .where('space', isEqualTo: spaceId)
        .get();
    setState(() {
      // 해당 space의 wall 목록 길이 저장
      walls_null_len = wall_snapshot!.docs.length;
    });
  }

  // 위젯을 만들고 화면에 보여주는 함수
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar 구현 코드
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('세부 공간 조회'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // 공간 이름
            Container(
              padding: EdgeInsets.all(8),
              width: double.infinity,
              child: Text(
                spaceData.name,
                style: TextStyle(fontWeight: FontWeight.bold),
                textScaleFactor: 1.4,
                textAlign: TextAlign.start,
              ),
            ),
            Divider(
              thickness: 1,
            ),
            // 세부 공간 내용
            ListTile(
              title: Text('세부 공간 내용'),
              subtitle: Text('벽면을 클릭하여 각 세부 내용을 살펴보고,\n내용을 추가 및 수정할 수 있습니다.'),
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
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    child: ElevatedButton(
                      onPressed: () {
                        int wallNum = 1;
                        // 벽면 생성 화면을 보여주는 screen으로 화면 전환(인자: 선택한 벽면 번호, 해당 공간의 document Id)
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (BuildContext context) => WallCreateScreen(data: wallNum, dataId: spaceId))
                        );
                      },
                      child: Text('1'),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: ElevatedButton(
                      onPressed: () {
                        int wallNum = 2;
                        // 벽면 생성 화면을 보여주는 screen으로 화면 전환(인자: 선택한 벽면 번호, 해당 공간의 document Id)
                        Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (BuildContext context) => WallCreateScreen(data: wallNum, dataId: spaceId))
                        );
                      },
                      child: Text('2'),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    bottom: 0,
                    child: ElevatedButton(
                      onPressed: () {
                        int wallNum = 3;
                        // 벽면 생성 화면을 보여주는 screen으로 화면 전환(인자: 선택한 벽면 번호, 해당 공간의 document Id)
                        Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (BuildContext context) => WallCreateScreen(data: wallNum, dataId: spaceId))
                        );
                      },
                      child: Text('3'),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: ElevatedButton(
                      onPressed: () {
                        int wallNum = 4;
                        // 벽면 생성 화면을 보여주는 screen으로 화면 전환(인자: 선택한 벽면 번호, 해당 공간의 document Id)
                        Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (BuildContext context) => WallCreateScreen(data: wallNum, dataId: spaceId))
                        );
                      },
                      child: Text('4'),
                    ),
                  ),
                ],
              ),
            ),
            // 벽면 내용 리스트
            ListTile(
              title: Text('벽면 내용 리스트'),
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
                // box 가운데에 정렬
                alignment: Alignment.center,
                // 벽면 목록이 null일 경우
                child: walls_null_len == 0
                    ? Text(
                    '생성된 벽면이 없습니다', textAlign: TextAlign.center,)
                // 벽면 목록이 null이 아닐 경우
                    : ListView.builder(
                    shrinkWrap: true,
                    itemCount: wall_snapshot!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      // wall의 데이터 저장
                      List<DocumentSnapshot> sortedDocs = wall_snapshot!.docs;
                      // wall 데이터들을 최신순으로 sort
                      sortedDocs.sort((a, b) {
                        return a['create_date'].compareTo(b['create_date']);
                      });
                      DocumentSnapshot wallData = sortedDocs[index];

                      return ListTile(
                        title: Text(wallData['number'].toString()),
                        subtitle: Column(
                          children: [
                            Text(wallData['tag']),
                            Text(wallData['content']),
                          ],
                        ),
                        trailing: Text(wallData['create_date']),
                      );
                    })
              ),
            ),
          ],
        ),
      )
    );
  }
}