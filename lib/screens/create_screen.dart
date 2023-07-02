import 'package:flutter/material.dart';
import 'package:board_project/models/question.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:board_project/providers/question_firestore.dart';

class CreateScreen extends StatefulWidget {
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  QuestionFirebase questionFirebase = QuestionFirebase();
  String title = '';
  String content = '';
  String author = '';
  String create_date = '';
  String modify_date = '';
  String category = '';

  late String user;

  @override
  void initState() {
    super.initState();
    setState(() {
      questionFirebase.initDb();
    });
    user = 'admin';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.red,
        title: Text('글 쓰기'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  title = value;
                });
              },
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
            OutlinedButton(
              onPressed: () {
                if (title.isNotEmpty && content.isNotEmpty && category.isNotEmpty) {
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
                    Navigator.of(context).pop(newQuestion);
                  });
                } else {
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
            OutlinedButton(
              onPressed: () {
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

// import 'package:flutter/material.dart';
// import 'package:board_project/models/question.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:board_project/providers/question_firestore.dart';
//
// class CreateScreen extends StatefulWidget {
//   _CreateScreenState createState() => _CreateScreenState();
// }
//
// class _CreateScreenState extends State<CreateScreen> {
//   QuestionFirebase questionFirebase = QuestionFirebase();
//   String title = '';
//   String content = '';
//   String author = '';
//   String create_date = '';
//   String modify_date = '';
//   String category = '';
//
//   late String user;
//
//   @override
//   void initState() {
//     super.initState();
//     setState(() {
//       questionFirebase.initDb();
//     });
//     user = 'amdin';
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('글 쓰기'),
//       ),
//       body: Container(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           children: [
//             TextField(
//               onChanged: (value) {
//                 setState(() {
//                   title = value;
//                 });
//               },
//               decoration: InputDecoration(labelText: '제목'),
//             ),
//             SizedBox(height: 16),
//             TextField(
//               onChanged: (value) {
//                 setState(() {
//                   content = value;
//                 });
//               },
//               decoration: InputDecoration(labelText: '내용'),
//             ),
//             SizedBox(height: 16),
//             TextField(
//               onChanged: (value) {
//                 setState(() {
//                   category = value;
//                 });
//               },
//               decoration: InputDecoration(labelText: '카테고리', prefixText: '#'),
//             ),
//             SizedBox(height: 16),
//             OutlinedButton(
//               onPressed: () {
//                 if (title.isNotEmpty && content.isNotEmpty && category.isNotEmpty) {
//                   Question newQuestion = Question(
//                     title: title,
//                     content: content,
//                     author: user,
//                     create_date: DateFormat('yy/MM/dd/HH/mm/ss').format(DateTime.now()),
//                     modify_date: 'Null',
//                     category: category,
//                     views_count: 0,
//                     likes_count: 0,
//                   );
//                   questionFirebase.questionReference
//                       .add(newQuestion.toMap())
//                       .then((value) {
//                     Navigator.of(context).pop();
//                   });
//                 } else {
//                   showDialog(
//                     context: context,
//                     builder: (BuildContext context) {
//                       return AlertDialog(
//                         title: Text('입력 오류'),
//                         content: Text('모든 필드를 입력해주세요.'),
//                         actions: [
//                           TextButton(
//                             child: Text('확인'),
//                             onPressed: () {
//                               Navigator.of(context).pop();
//                             },
//                           ),
//                         ],
//                       );
//                     },
//                   );
//                 }
//               },
//                 child: Text('완료'),
//             ),
//             OutlinedButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('취소'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }