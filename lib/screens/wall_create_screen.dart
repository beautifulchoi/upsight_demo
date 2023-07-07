/*
벽면(wall) 생성하는 page
 */

import 'package:board_project/providers/wall_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:board_project/models/wall.dart';
import 'package:board_project/screens/building_board_screen.dart';

class WallCreateScreen extends StatefulWidget {
  // space_detail_screen에서 전달받는 벽면 number 데이터
  final int data;
  // space_detail_screen에서 전달받는 해당 space 데이터
  final String dataId;
  WallCreateScreen({required this.data, required this.dataId});

  _WallCreateScreenState createState() => _WallCreateScreenState();
}

class _WallCreateScreenState extends State<WallCreateScreen> {
  WallFirebase wallFirebase = WallFirebase();

  // 새로 생성하는 wall model의 각 필드 초기화
  String tag = '';
  String content = '';
  String author = '';
  String create_date = '';
  String modify_date = 'Null';

  // 임의로 지정할 user name, 추후 user model과 연결해야해서 DB 연결시켜야함
  late String user;

  // 전달받은 벽면 number 데이터 저장할 변수
  late int wallNum;
  // 전달받은 spaceId 데이터 저장할 변수
  late String spaceId;

  @override
  void initState() {
    super.initState();
    // 전달받은 벽면 number 데이터 저장
    wallNum = widget.data;
    // 전달받은 spaceId 데이터 저장
    spaceId = widget.dataId;

    setState(() {
      wallFirebase.initDb();
    });
    user = 'admin';
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
        title: Text('벽면 추가'),
      ),
      // appBar 아래 UI 구현 코드
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // 벽면 번호
            Container(
              padding: EdgeInsets.all(8),
              width: double.infinity,
              child: Text(
                wallNum.toString(),
                style: TextStyle(fontWeight: FontWeight.bold),
                textScaleFactor: 1.4,
                textAlign: TextAlign.start,
              ),
            ),
            Divider(
              thickness: 1,
            ),
            TextField(
              // tag 값이 작성되었는지 확인하여 입력 받은 데이터 저장
              onChanged: (value) {
                setState(() {
                  tag = value;
                });
              },
              // 입력하려고 하면 작아지면서 위로 올라가는 애니메이션? UI 코드
              decoration: InputDecoration(labelText: '태그', prefixText: '#'),
            ),
            SizedBox(height: 16),
            TextField(
              onChanged: (value) {
                setState(() {
                  content = value;
                });
              },
              decoration: InputDecoration(labelText: '내용 입력'),
            ),
            SizedBox(height: 16),
            // 벽면 작성 완료 버튼
            OutlinedButton(
                onPressed: () {
                  // 모든 필드가 작성되었는지 확인
                  if (tag.isNotEmpty && content.isNotEmpty) {
                    // 입력받은 데이터로 새로운 wall 데이터 생성하여 DB에 생성
                    Wall newWall = Wall(
                      space: spaceId,
                      number: wallNum,
                      tag: tag,
                      content: content,
                      author: user,
                      create_date: DateFormat('yy/MM/dd/HH/mm/ss').format(DateTime.now()),
                      modify_date: modify_date,
                    );

                    wallFirebase.addWall(newWall).then((value) {
                      // 새로 생성된 데이터는 building 목록 screen으로 전환되면서 전달됨
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (BuildContext context) => BuildingBoardScreen()),
                      );
                    });
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
              child: Text('입력 완료'),
            ),
            // 벽면 작성 취소 버튼
            OutlinedButton(
              onPressed: () {
                // 이전 화면인 세부 공간 조회 screen으로 전환
                Navigator.of(context).pop();
              },
              child: Text('취소'),
            ),
          ],
        ),
      )
    );
  }
}