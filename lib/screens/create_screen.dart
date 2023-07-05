/*
게시글(question) 생성하는 page
 */

import 'package:flutter/material.dart';
import 'package:board_project/models/question.dart';
import 'package:intl/intl.dart';
import 'package:board_project/providers/question_firestore.dart';

class CreateScreen extends StatefulWidget {
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  QuestionFirebase questionFirebase = QuestionFirebase();

  // 새로 생성하는 question model의 각 필드 초기화
  String title = '';
  String content = '';
  String author = '';
  String create_date = '';
  String modify_date = '';
  String category = '';

  // 임의로 지정할 user name, 추후 user model과 연결해야해서 DB 연결시켜야함
  late String user;

  @override
  void initState() {
    super.initState();
    setState(() {
      questionFirebase.initDb();
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
        title: Text('글 쓰기'),
      ),
      // appBar 아래 UI 구현 코드
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              // title 값이 작성되었는지 확인하여 입력 받은 데이터 저장
              onChanged: (value) {
                setState(() {
                  title = value;
                });
              },
              // 입력하려고 하면 작아지면서 위로 올라가는 애니메이션? UI 코드
              decoration: InputDecoration(labelText: '제목'),
            ),
            SizedBox(height: 16),
            TextField(
              onChanged: (value) {
                setState(() {
                  content = value;
                });
              },
              decoration: InputDecoration(labelText: '내용'),
            ),
            SizedBox(height: 16),
            TextField(
              onChanged: (value) {
                setState(() {
                  category = value;
                });
              },
              decoration: InputDecoration(labelText: '카테고리', prefixText: '#'),
            ),
            SizedBox(height: 16),
            // 게시글 작성 완료 버튼
            OutlinedButton(
              onPressed: () {
                // 모든 필드가 작성되었는지 확인
                if (title.isNotEmpty && content.isNotEmpty && category.isNotEmpty) {
                  // 입력받은 데이터로 새로운 question 데이터 생성하여 DB에 생성
                  Question newQuestion = Question(
                    title: title,
                    content: content,
                    author: user,
                    create_date: DateFormat('yy/MM/dd/HH/mm/ss').format(DateTime.now()),
                    modify_date: 'Null',
                    category: category,
                    views_count: 0,
                    isLikeClicked: false,
                  );
                  questionFirebase.addQuestion(newQuestion).then((value) {
                    // 새로 생성된 데이터는 이전 화면인 게시물 list screen으로 전환되면서 전달됨(현재 infinite_scroll_page)
                    Navigator.of(context).pop(newQuestion);
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
              child: Text('완료'),
            ),
            // 게시글 작성 취소 버튼
            OutlinedButton(
              onPressed: () {
                // 이전 화면인 게시물 list screen으로 전환(현재 infinite_scroll_page)
                Navigator.of(context).pop();
              },
              child: Text('취소'),
            ),
          ],
        ),
      ),
    );
  }
}