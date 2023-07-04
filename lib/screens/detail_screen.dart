import 'package:board_project/providers/answer.firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:board_project/models/question.dart';
import 'package:board_project/screens/modify_screen.dart';
import 'package:board_project/providers/question_firestore.dart';
import 'package:board_project/models/answer.dart';
import 'package:intl/intl.dart';

class DetailScreen extends StatefulWidget {
  final Question data;
  final String dataId;
  DetailScreen({required this.data, required this.dataId});

  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Question questionData;
  late String questionId;
  QuestionFirebase questionFirebase = QuestionFirebase();

  AnswerFirebase answerFirebase = AnswerFirebase();
  // String content = '';
  // String author = '';
  // String create_date = '';
  // String modify_date = '';
  QuerySnapshot? answer_snapshot;

  late String user;
  bool likeData = false;

  final _commentTextEditController = TextEditingController();

  int answers_null_len = 0;

  @override
  void initState() {
    super.initState();
    questionData = widget.data;
    questionId = widget.dataId;
    setState(() {
      questionFirebase.initDb();
      answerFirebase.initDb();
      fetchData();
    });
    user = 'admin';
  }

  Future<void> fetchData() async {
    answer_snapshot = await answerFirebase.answerReference
        .where('question', isEqualTo: questionId)
        .get();
    setState(() {
      answers_null_len = answer_snapshot!.docs.length;
    });
    print(answer_snapshot!.docs.length);
  }

  @override
  void dispose() {
    _commentTextEditController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('상세보기'),
      ),
      body: Column(
        children: [
          Expanded(
              child: SingleChildScrollView(
                child: Column(
                    children: <Widget>[
                      // 아이콘, 작성자, datetime
                      ListTile(
                        leading: CircleAvatar(
                          child: CircleAvatar(
                            child: Icon(
                              Icons.person,
                            ),
                          ),
                        ),
                        title: Text(questionData.author),
                        subtitle: Text(questionData.create_date + "     " +
                            questionData.modify_date),
                      ),
                      // 제목
                      Container(
                        padding: EdgeInsets.all(8),
                        width: double.infinity,
                        child: Text(
                          questionData.title,
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textScaleFactor: 1.4,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      // 내용
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(questionData.content!),
                        ),
                      ),
                      // 카테고리
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text('#' + questionData.category!),
                        ),
                      ),
                      // 수정 버튼, 삭제 버튼
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              OutlinedButton(
                                onPressed: () {
                                  if (user == questionData.author) {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              ModifyScreen(data: questionData)),
                                    );
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('권한 오류'),
                                            content: Text('해당 게시글의 작성자가 아닙니다.'),
                                            actions: [
                                              TextButton(
                                                child: Text('확인'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                  }
                                },
                                child: Text('수정'),
                              ),
                              OutlinedButton(
                                onPressed: () {
                                  if (user == questionData.author) {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('삭제하기'),
                                            content: Container(
                                              child: Text('삭제하시겠습니까?'),
                                            ),
                                            actions: [
                                              TextButton(
                                                  child: Text('삭제'),
                                                  onPressed: () async {
                                                    QuerySnapshot snapshot = await questionFirebase
                                                        .questionReference
                                                        .where('title',
                                                        isEqualTo: questionData.title)
                                                        .where('content',
                                                        isEqualTo: questionData.content)
                                                        .where('author',
                                                        isEqualTo: questionData.author)
                                                        .where('create_date',
                                                        isEqualTo: questionData
                                                            .create_date)
                                                        .get();

                                                    if (snapshot.docs.isNotEmpty) {
                                                      String documentId = snapshot.docs
                                                          .first.id;
                                                      await questionFirebase
                                                          .questionReference.doc(
                                                          documentId).delete();
                                                      // 나중에 고쳐야함!!!!!!!!!!!!!!!!
                                                      Navigator.pushNamed(
                                                          context, '/test');
                                                    }
                                                  }),
                                              TextButton(
                                                  child: Text('취소'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  }),
                                            ],
                                          );
                                        });
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('권한 오류'),
                                            content: Text('해당 게시글의 작성자가 아닙니다.'),
                                            actions: [
                                              TextButton(
                                                child: Text('확인'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                  }
                                },
                                child: Text('삭제'),
                              ),
                            ],
                          )
                      ),
                      // 조회수, 좋아요
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                              children: [
                                Container(
                                    padding: EdgeInsets.all(5),
                                    child: Column(
                                      children: [
                                        Icon(Icons.remove_red_eye_outlined),
                                        Text(questionData.views_count.toString()),
                                      ],
                                    )
                                ),
                                Container(
                                  child: IconButton(
                                    onPressed: () async {
                                      QuerySnapshot snapshot = await questionFirebase
                                          .questionReference
                                          .where('title', isEqualTo: questionData.title)
                                          .where(
                                          'content', isEqualTo: questionData.content)
                                          .where(
                                          'author', isEqualTo: questionData.author)
                                          .where('create_date',
                                          isEqualTo: questionData.create_date)
                                          .get();

                                      if (snapshot.docs.isNotEmpty) {
                                        likeData = questionData.isLikeClicked;
                                        String documentId = snapshot.docs.first.id;
                                        await questionFirebase.questionReference.doc(
                                            documentId).update({
                                          'isLikeClicked': !questionData.isLikeClicked
                                        });
                                        setState(() {
                                          questionData.isLikeClicked = !likeData;
                                        });
                                      }
                                    },
                                    icon: Icon(
                                      color: questionData.isLikeClicked
                                          ? Colors.blue
                                          : Colors.black,
                                      Icons.thumb_up_alt_outlined,
                                    ),
                                  ),
                                ),
                              ]
                          )
                      ),
                      // 경계
                      SizedBox(
                        height: 1,
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      // 답변 목록
                      answers_null_len == 0
                          ? Center(
                        child: Text('아직 작성된 답변이 없습니다'),
                      )
                          : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: answer_snapshot!.docs.length,
                          itemBuilder: (BuildContext context, int index) {

                            List<DocumentSnapshot> sortedDocs = answer_snapshot!.docs;
                            sortedDocs.sort((a, b) {
                              return a['create_date'].compareTo(b['create_date']);
                            });
                            DocumentSnapshot answerData = sortedDocs[index];

                            return ListTile(
                              title: Row(
                                children: [
                                  Text(answerData['content']),
                                  IconButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('삭제하기'),
                                              content: Container(
                                                child: Text('삭제하시겠습니까?'),
                                              ),
                                              actions: [
                                                TextButton(
                                                    child: Text('삭제'),
                                                    onPressed: () async {
                                                      QuerySnapshot snapshot = await answerFirebase.answerReference
                                                          .where('question', isEqualTo: answerData['question'])
                                                          .where('content', isEqualTo: answerData['content'])
                                                          .where('create_date', isEqualTo: answerData['create_date'])
                                                          .get();
                                                      if (snapshot.docs.isNotEmpty) {
                                                        String documentId = snapshot.docs.first.id;
                                                        await answerFirebase.answerReference.doc(documentId).delete();
                                                        // 나중에 고쳐야함!!!!!!!!!!!!!!!!
                                                        Navigator.pushNamed(context, '/test');
                                                      }
                                                    }),
                                                TextButton(
                                                  child: Text('취소'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          });
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Text(answerData['author']),
                              trailing: Column(
                                children: [
                                  Text(answerData['create_date']),
                                  Text(answerData['modify_date']),
                                ],
                              ),
                            );
                          }),
                    ]
                ),
              ),
          ),
          Container(
            color: Colors.purple,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Flexible(
                    child: Container(
                      child: Form(
                        child: TextFormField(
                          controller: _commentTextEditController,
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return '댓글을 입력하세요';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.orange,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1,
                                color: Theme
                                    .of(context)
                                    .primaryColor,
                              ),
                            ),
                            hintText: "댓글을 입력하세요",
                            hintStyle: new TextStyle(
                                color: Colors.black26),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.send),
                              onPressed: () {
                                String commentText = _commentTextEditController.text;

                                Answer newAnswer = Answer(
                                  question: questionId,
                                  content: commentText,
                                  author: 'guest',
                                  create_date: DateFormat('yy/MM/dd/HH/mm/ss').format(DateTime.now()),
                                  modify_date: 'Null',
                                );
                                answerFirebase.addAnswer(newAnswer);

                                Navigator.pushNamed(context, '/test');
                              },
                            ),
                            isDense: true,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      )
    );
  }
}

/*
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: Text('제목 : ' + questionData.title),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Text('내용 : ' + questionData.content),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Text('글쓴이 : ' + questionData.author),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Text('카테고리 : ' + questionData.category),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Text('작성일 : ' + questionData.create_date),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Text('수정일 : ' + questionData.modify_date),
            ),
            OutlinedButton(
              onPressed: () {
                if (user == questionData.author) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (BuildContext context) => ModifyScreen(data: questionData)),
                  );
                } else {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('권한 오류'),
                          content: Text('해당 게시글의 작성자가 아닙니다.'),
                          actions: [
                            TextButton(
                              child: Text('확인'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      });
                }
              },
              child: Text('수정'),
            ),
            OutlinedButton(
              onPressed: () {
                if (user == questionData.author) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('삭제하기'),
                          content: Container(
                            child: Text('삭제하시겠습니까?'),
                          ),
                          actions: [
                            TextButton(
                                child: Text('삭제'),
                                onPressed: () async {
                                  QuerySnapshot snapshot = await questionFirebase.questionReference
                                      .where('title', isEqualTo: questionData.title)
                                      .where('content', isEqualTo: questionData.content)
                                      .where('author', isEqualTo: questionData.author)
                                      .where('create_date', isEqualTo: questionData.create_date)
                                      .get();

                                  if (snapshot.docs.isNotEmpty) {
                                    String documentId = snapshot.docs.first.id;
                                    await questionFirebase.questionReference.doc(documentId).delete();
                                    // 나중에 고쳐야함!!!!!!!!!!!!!!!!
                                    Navigator.pushNamed(context, '/test');
                                  }
                                }),
                            TextButton(
                                child: Text('취소'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                }),
                          ],
                        );
                      });
                } else {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('권한 오류'),
                          content: Text('해당 게시글의 작성자가 아닙니다.'),
                          actions: [
                            TextButton(
                              child: Text('확인'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      });
                }
              },
              child: Text('삭제'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(5),
                  child: Column(
                    children: [
                      Icon(Icons.remove_red_eye_outlined),
                      Text(questionData.views_count.toString()),],
                  )
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  child: Column(
                    children: [
                      Container(
                        child: IconButton(
                          onPressed: () async {
                            QuerySnapshot snapshot = await questionFirebase.questionReference
                                .where('title', isEqualTo: questionData.title)
                                .where('content', isEqualTo: questionData.content)
                                .where('author', isEqualTo: questionData.author)
                                .where('create_date', isEqualTo: questionData.create_date)
                                .get();

                            if (snapshot.docs.isNotEmpty) {
                              likeData = questionData.isLikeClicked;
                              String documentId = snapshot.docs.first.id;
                              await questionFirebase.questionReference.doc(documentId).update({
                                'isLikeClicked': !questionData.isLikeClicked
                              });
                              setState(() {
                                questionData.isLikeClicked = !likeData;
                              });
                            }
                          },
                          icon: Icon(
                            color: questionData.isLikeClicked ? Colors.blue : Colors.black,
                            Icons.thumb_up_alt_outlined,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ]
            ),
          ],
        )
      ),
       */
//  );
//}


// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:board_project/models/question.dart';
// import 'package:board_project/screens/modify_screen.dart';
// import 'package:board_project/providers/question_firestore.dart';
//
// class DetailScreen extends StatefulWidget {
//   final Question data;
//   DetailScreen({required this.data});
//
//   _DetailScreenState createState() => _DetailScreenState();
// }
//
// class _DetailScreenState extends State<DetailScreen> {
//   late Question questionData;
//   QuestionFirebase questionFirebase = QuestionFirebase();
//
//   late String user;
//
//   @override
//   void initState() {
//     super.initState();
//     questionData = widget.data;
//     setState(() {
//       questionFirebase.initDb();
//     });
//     questionData.views_count += 1;
//     Question newQuestion = Question(
//       title: questionData.title,
//       content: questionData.content,
//       author: questionData.author,
//       create_date: questionData.create_date,
//       modify_date: questionData.modify_date,
//       category: questionData.category,
//       views_count: questionData.views_count,
//       likes_count: questionData.likes_count,
//       reference: questionData.reference,
//     );
//     questionFirebase.updateQuestion(newQuestion);
//     user = 'amdin';
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('상세보기'),
//       ),
//       body: Container(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           children: [
//             Container(
//               padding: EdgeInsets.all(10),
//               child: Text('제목 : ' + questionData.title),
//             ),
//             Container(
//               padding: EdgeInsets.all(10),
//               child: Text('내용 : ' + questionData.content),
//             ),
//             Container(
//               padding: EdgeInsets.all(10),
//               child: Text('글쓴이 : ' + questionData.author),
//             ),
//             Container(
//               padding: EdgeInsets.all(10),
//               child: Text('카테고리 : ' + questionData.category),
//             ),
//             Container(
//               padding: EdgeInsets.all(10),
//               child: Text('작성일 : ' + questionData.create_date),
//             ),
//             Container(
//               padding: EdgeInsets.all(10),
//               child: Text('수정일 : ' + questionData.modify_date),
//             ),
//             OutlinedButton(
//               onPressed: () {
//                 if (user == questionData.author) {
//                   Navigator.of(context).push(
//                     MaterialPageRoute(
//                         builder: (BuildContext context) => ModifyScreen(data: questionData)),
//                   );
//                 } else {
//                   showDialog(
//                       context: context,
//                       builder: (BuildContext context) {
//                         return AlertDialog(
//                           title: Text('권한 오류'),
//                           content: Text('해당 게시글의 작성자가 아닙니다.'),
//                           actions: [
//                             TextButton(
//                               child: Text('확인'),
//                               onPressed: () {
//                                 Navigator.of(context).pop();
//                               },
//                             ),
//                           ],
//                         );
//                       });
//                 }
//               },
//               child: Text('수정'),
//             ),
//             OutlinedButton(
//               onPressed: () {
//                 if (user == questionData.author) {
//                   showDialog(
//                       context: context,
//                       builder: (BuildContext context) {
//                         return AlertDialog(
//                           title: Text('삭제하기'),
//                           content: Container(
//                             child: Text('삭제하시겠습니까?'),
//                           ),
//                           actions: [
//                             TextButton(
//                                 child: Text('삭제'),
//                                 onPressed: () {
//                                   questionFirebase
//                                       .deleteQuestion(questionData)
//                                       .then((value) {
//                                     Navigator.pushNamed(context, '/');
//                                   });
//                                 }),
//                             TextButton(
//                                 child: Text('취소'),
//                                 onPressed: () {
//                                   Navigator.of(context).pop();
//                                 }),
//                           ],
//                         );
//                       });
//                 } else {
//                   showDialog(
//                       context: context,
//                       builder: (BuildContext context) {
//                         return AlertDialog(
//                           title: Text('권한 오류'),
//                           content: Text('해당 게시글의 작성자가 아닙니다.'),
//                           actions: [
//                             TextButton(
//                               child: Text('확인'),
//                               onPressed: () {
//                                 Navigator.of(context).pop();
//                               },
//                             ),
//                           ],
//                         );
//                       });
//                 }
//               },
//               child: Text('삭제'),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   padding: EdgeInsets.all(5),
//                   child: Column(
//                     children: [
//                       Icon(Icons.remove_red_eye_outlined),
//                       Text(questionData.views_count.toString()),],
//                   )
//                 ),
//                 Container(
//                   padding: EdgeInsets.all(5),
//                   child: Column(
//                     children: [
//                       Container(
//                         child: InkWell(
//                           child: Icon(Icons.thumb_up_alt_outlined),
//                         onTap: () {},
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ]
//             ),
//           ],
//         )
//       ),
//     );
//   }
// }