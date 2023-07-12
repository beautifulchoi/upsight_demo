/*
게시글(question) 수정하는 page
 */

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:board_project/models/question.dart';
import 'package:intl/intl.dart';
import 'package:board_project/providers/question_firestore.dart';

class ModifyScreen extends StatefulWidget {
  // detail_screen에서 전달받는 해당 question 데이터
  final Question data;
  ModifyScreen({required this.data});

  _ModifyScreenState createState() => _ModifyScreenState();
}

class _ModifyScreenState extends State<ModifyScreen> {
  QuestionFirebase questionFirebase = QuestionFirebase();
  // 전달받은 question 데이터 저장할 변수
  late Question questionData;
  // 전달받은 question 데이터의 DocumentSnapshot id 저장할 변수
  late String document;

  _ModifyScreenState() {
    questionFirebase.initDb();
  }

  @override
  void initState() {
    super.initState();
    // 전달받은 question 데이터 저장
    questionData = widget.data;
    // 해당 question 데이터의 snapshot 저장
    fetchQuestionData();
  }

  // 해당 question 데이터의 snapshot 저장하는 함수
  void fetchQuestionData() async {
    // 수정할 question 데이터의 DocumentSnapshot() 찾아서 저장
    QuerySnapshot snapshot = await questionFirebase.questionReference
        .where('title', isEqualTo: questionData.title)
        .where('content', isEqualTo: questionData.content)
        .where('author', isEqualTo: questionData.author)
        .where('create_date', isEqualTo: questionData.create_date)
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
        title: Text('수정하기'),
      ),
      // appBar 아래 UI 구현 코드
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              // title 값이 변경되었는지 확인하여 입력 받은 데이터 저장
              onChanged: (value) {
                questionData.title = value;
              },
              // 입력하려고 하면 작아지면서 위로 올라가는 애니메이션? UI 코드
              decoration: InputDecoration(
                hintText: questionData.title,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              onChanged: (value) {
                questionData.content = value;
              },
              decoration: InputDecoration(
                hintText: questionData.content,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              onChanged: (value) {
                questionData.author = value;
              },
              decoration: InputDecoration(
                hintText: questionData.author,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              onChanged: (value) {
                questionData.category = value;
              },
              decoration: InputDecoration(
                hintText: questionData.category,
              ),
            ),
            SizedBox(height: 16),
            // 게시글 수정 완료 버튼
            OutlinedButton(
              onPressed: () async {
                // 모든 필드가 작성되었는지 확인
                if (questionData.title.isNotEmpty && questionData.content.isNotEmpty && questionData.author.isNotEmpty && questionData.category.isNotEmpty) {
                  // 입력받은 데이터로 새로운 question 데이터 생성하여 DB에 업데이트
                  Question newQuestion = Question(
                      title: questionData.title,
                      content: questionData.content,
                      author: questionData.author,
                      create_date: questionData.create_date,
                      modify_date: DateFormat('yy/MM/dd/HH/mm/ss').format(DateTime.now()),
                      category: questionData.category,
                      views_count: questionData.views_count,
                      isLikeClicked: questionData.isLikeClicked,
                      reference: questionData.reference,
                  );
                  await questionFirebase.updateQuestion(newQuestion);
                  await questionFirebase.questionReference.doc(document).update({
                    'title': questionData.title,
                    'content': questionData.content,
                    'author': questionData.author,
                    'create_date': questionData.create_date,
                    'modify_date': DateFormat('yy/MM/dd/HH/mm/ss').format(DateTime.now()),
                    'category': questionData.category,
                    'views_count': questionData.views_count,
                    'isLikeClicked': questionData.isLikeClicked,
                  });
                  // 수정된 question 데이터를 가지고 게시물 list screen으로 전환
                  Navigator.pushNamed(context, '/test', arguments: newQuestion);
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
            // 게시글 수정 취소 버튼
            OutlinedButton(
              onPressed: () {
                // 게시물 list screen으로 전환(현재 infinite_scroll_page)
                Navigator.pushNamed(context, '/test');
              },
              child: Text('취소'),
            ),
          ],
        ),
      ),
    );
  }
}