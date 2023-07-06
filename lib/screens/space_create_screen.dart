/*
공간(space) 생성하는 page
 */

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:board_project/providers/building_firestore.dart';

class SpaceCreateScreen extends StatefulWidget {
  _SpaceCreateScreenState createState() => _SpaceCreateScreenState();
}

class _SpaceCreateScreenState extends State<SpaceCreateScreen> {

  @override
  void initState() {
    super.initState();
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
        title: Text('세부 공간 추가'),
      ),
      // appBar 아래 UI 구현 코드
      body: Column(
        children: [
          Text('선택한 공간의 내용을 입력해주세요.'),
          Divider(thickness: 1),
          TextField(
            // name 값이 작성되었는지 확인하여 입력 받은 데이터 저장
            onChanged: (value) {
              setState(() {

              });
            },
            decoration: InputDecoration(labelText: '공간 별칭'),
          ),
          SizedBox(height: 16),
          TextField(
            onChanged: (value) {
              setState(() {

              });
            },
            decoration: InputDecoration(labelText: '공간 타입'),
          ),
          SizedBox(height: 16),
        ],
      )
    );
  }
}