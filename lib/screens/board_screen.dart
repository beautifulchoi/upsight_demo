// import 'package:board_project/providers/question_firestore.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:board_project/models/question.dart';
// import 'package:board_project/screens/create_screen.dart';
// import 'package:board_project/screens/detail_screen.dart';
// import 'package:intl/intl.dart';
// import 'package:get/get.dart';
//
// class BoardScreen extends StatefulWidget {
//   _BoardScreenState createState() => _BoardScreenState();
// }
//
// class _BoardScreenState extends State<BoardScreen> {
//   late List<Question> questions;
//   QuestionFirebase questionFirebase = QuestionFirebase();
//   late String user;
//
//   @override
//   void initState() {
//     super.initState();
//     print("initState");
//     setState(() {
//       questionFirebase.initDb();
//     });
//     user = 'admin';
//
//     for (int i = 0; i < 22; i++) {
//       Question newQuestion = Question(
//         title: i.toString() + '번째 제목',
//         content: i.toString() + '번째 내용',
//         author: user,
//         create_date: DateFormat('yy/MM/dd/HH/mm/ss').format(DateTime.now()),
//         modify_date: 'Null',
//         category: i.toString() + '번째 카테고리',
//         views_count: 0,
//         isLikeClicked: false,
//       );
//       questionFirebase.questionReference.add(newQuestion.toMap());
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//         stream: questionFirebase.questionStream,
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (!snapshot.hasData) {
//             return Scaffold(
//               appBar: AppBar(),
//               body: Center(child: CircularProgressIndicator()),
//             );
//           } else {
//             questions = questionFirebase.getQuestions(snapshot);
//             questions.sort((a, b) => b.create_date.compareTo(a.create_date));
//             return Scaffold(
//               appBar: AppBar(
//                 title: Text('게시판'),
//               ),
//               floatingActionButton: FloatingActionButton(
//                 child: Text('+', style: TextStyle(fontSize: 25)),
//                 onPressed: () {
//                   Navigator.of(context).push(
//                     MaterialPageRoute(
//                         builder: (BuildContext context) => CreateScreen()),
//                   );
//                 }),
//               body: ListView.separated(
//                 itemCount: questions.length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     title: Text(questions[index].title),
//                     subtitle: Text(questions[index].content),
//                     trailing: Column(
//                       children: [
//                         Text(questions[index].author),
//                         Text(questions[index].create_date),
//                       ],
//                     ),
//                     onTap: () {
//                       Navigator.of(context).push(
//                         MaterialPageRoute(
//                             builder: (BuildContext context) => DetailScreen(data: questions[index],)),
//                       );
//                     },
//                   );
//                 },
//                 separatorBuilder: (context, index) {
//                   return Divider();
//                 },
//               ),
//             );
//           }
//         });
//   }
// }