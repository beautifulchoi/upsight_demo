import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:board_project/models/question.dart';
import 'package:intl/intl.dart';
import 'package:board_project/providers/question_firestore.dart';

class ModifyScreen extends StatefulWidget {
  final Question data;
  ModifyScreen({required this.data});

  _ModifyScreenState createState() => _ModifyScreenState();
}

class _ModifyScreenState extends State<ModifyScreen> {
  QuestionFirebase questionFirebase = QuestionFirebase();
  late Question questionData;
  late String document;

  _ModifyScreenState() {
    questionFirebase.initDb();
  }

  @override
  void initState() {
    super.initState();
    questionData = widget.data;

    fetchQuestionData();
  }

  void fetchQuestionData() async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.red,
        title: Text('수정하기'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                questionData.title = value;
              },
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
            OutlinedButton(
              onPressed: () async {
                if (questionData.title.isNotEmpty && questionData.content.isNotEmpty && questionData.author.isNotEmpty && questionData.category.isNotEmpty) {
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
                  // QuerySnapshot snapshot = await questionFirebase.questionReference
                  //     .where('title', isEqualTo: questionData.title)
                  //     .where('content', isEqualTo: questionData.content)
                  //     .where('author', isEqualTo: questionData.author)
                  //     .where('create_date', isEqualTo: questionData.create_date)
                  //     .get();
                  // String documentId = snapshot.docs.first.id;
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
                  // 나중에 고쳐야함!!!!!!!!!!!!!!!!
                  Navigator.pushNamed(context, '/test', arguments: newQuestion);
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
                // 나중에 고쳐야함!!!!!!!!!!!!!!!!
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

// import 'package:flutter/material.dart';
// import 'package:board_project/models/question.dart';
// import 'package:intl/intl.dart';
// import 'package:board_project/providers/question_firestore.dart';
//
// class ModifyScreen extends StatefulWidget {
//   final Question data;
//   ModifyScreen({required this.data});
//
//   _ModifyScreenState createState() => _ModifyScreenState();
// }
//
// class _ModifyScreenState extends State<ModifyScreen> {
//   QuestionFirebase questionFirebase = QuestionFirebase();
//   late Question questionData;
//
//   @override
//   void initState() {
//     super.initState();
//     questionData = widget.data;
//     setState(() {
//       questionFirebase.initDb();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('수정하기'),
//       ),
//       body: Container(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           children: [
//             TextField(
//               onChanged: (value) {
//                 questionData.title = value;
//               },
//               decoration: InputDecoration(
//                 hintText: questionData.title,
//               ),
//             ),
//             SizedBox(height: 16),
//             TextField(
//               onChanged: (value) {
//                 questionData.content = value;
//               },
//               decoration: InputDecoration(
//                 hintText: questionData.content,
//               ),
//             ),
//             SizedBox(height: 16),
//             TextField(
//               onChanged: (value) {
//                 questionData.author = value;
//               },
//               decoration: InputDecoration(
//                 hintText: questionData.author,
//               ),
//             ),
//             SizedBox(height: 16),
//             TextField(
//               onChanged: (value) {
//                 questionData.category = value;
//               },
//               decoration: InputDecoration(
//                 hintText: questionData.category,
//               ),
//             ),
//             SizedBox(height: 16),
//             OutlinedButton(
//               onPressed: () async {
//                 if (questionData.title.isNotEmpty && questionData.content.isNotEmpty && questionData.author.isNotEmpty && questionData.category.isNotEmpty) {
//                   Question newQuestion = Question(
//                       title: questionData.title,
//                       content: questionData.content,
//                       author: questionData.author,
//                       create_date: questionData.create_date,
//                       modify_date: DateFormat('yy/MM/dd/HH/mm/ss').format(DateTime.now()),
//                       category: questionData.category,
//                       views_count: questionData.views_count,
//                       likes_count: questionData.likes_count,
//                       reference: questionData.reference,
//                   );
//                   questionFirebase
//                       .updateQuestion(newQuestion)
//                       .then((value) => Navigator.pushNamed(context, '/'));
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
//               child: Text('완료'),
//             ),
//             OutlinedButton(
//               onPressed: () {
//                 Navigator.pushNamed(context, '/');
//               },
//               child: Text('취소'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }