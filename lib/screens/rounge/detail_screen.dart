/*
게시글(question)의 상세 화면을 보여주는 page : 좋아요, 댓글 기능 구현
 */

import 'package:board_project/providers/answer_firestore.dart';
import 'package:board_project/providers/user_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:board_project/models/question.dart';
import 'package:board_project/screens/rounge/modify_screen.dart';
import 'package:board_project/providers/question_firestore.dart';
import 'package:board_project/models/answer.dart';
import 'package:intl/intl.dart';

import '../../constants/colors.dart';
import '../../constants/size.dart';

class DetailScreen extends StatefulWidget {
  // infinite_scroll_page에서 전달받는 해당 question 데이터
  final Question data;
  // infinite_scroll_page에서 전달받는 해당 questionId 데이터
  final String dataId;
  // infinite_scroll_page에서 전달받는 해당 questionDoc 데이터
  final DocumentSnapshot dataDoc;

  DetailScreen({required this.data, required this.dataId, required this.dataDoc});

  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  QuestionFirebase questionFirebase = QuestionFirebase();
  AnswerFirebase answerFirebase = AnswerFirebase();
  UserFirebase userFirebase = UserFirebase();

  // 전달받은 question 데이터 저장할 변수
  late Question questionData;
  // 전달받은 questionId 데이터 저장할 변수
  late String questionId;
  // 전달받은 questionId 데이터 저장할 변수
  late DocumentSnapshot questionDoc;

  // 해당 question의 answer 데이터들  DocumentSnapshot 저장할 변수
  QuerySnapshot? answer_snapshot;
  QuerySnapshot? question_snapshot;
  DocumentSnapshot? views_question;

  // 임의로 지정할 user name, 추후 user model과 연결해야해서 DB 연결시켜야함
  late String user;

  // 좋아요 버튼 눌렀는지 유무 저장하는 변수
  bool likeData = false;

  // 댓글 입력할 TextEditingController 선언
  final _commentTextEditController = TextEditingController();

  // 해당 게시글(question)의 답변 목록 길이 초기화
  int answers_null_len = COMMON_INIT_COUNT;

  @override
  void initState() {
    super.initState();
    // 전달받은 question 데이터 저장
    questionData = widget.data;
    // 전달받은 questionId 데이터 저장
    questionId = widget.dataId;
    // 전달받은 questionDoc 데이터 저장
    questionDoc = widget.dataDoc;

    setState(() {
      questionFirebase.initDb();
      answerFirebase.initDb();
      userFirebase.initDb();
      fetchQuestionData();
      // 해당 question의 answer 데이터의 snapshot 저장
      fetchData();
      fetchUser();
    });
    user = 'admin';
  }

  // 해당 question 데이터의 snapshot 저장하는 함수
  Future<void> fetchQuestionData() async {
    // 해당 question의 answer 데이터의 DocumentSnapshot() 찾아서 저장
    final querySnapshot = await questionFirebase.questionReference
        .where('title', isEqualTo: questionData.title)
        .where('content', isEqualTo: questionData.content)
        .where('author', isEqualTo: questionData.author)
        .where('create_date', isEqualTo: questionData.create_date)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      question_snapshot = querySnapshot;
    }
  }

  // 해당 question의 answer 데이터의 snapshot 저장하는 함수
  Future<void> fetchData() async {
    // 해당 question의 answer 데이터의 DocumentSnapshot() 찾아서 저장
    answer_snapshot = await answerFirebase.answerReference
        .where('question', isEqualTo: questionId)
        .get();
    setState(() {
      // 해당 게시글(question)의 답변 목록 길이 저장
      answers_null_len = answer_snapshot!.docs.length;
    });
  }

  Future<void> fetchUser() async {
    final userSnapshot = await userFirebase.userReference.get();
    late DocumentSnapshot document;

    if (userSnapshot.docs.isNotEmpty) {
      document = userSnapshot.docs.first;
    }
    user = (document.data() as Map<String, dynamic>)['user_id'];
  }

  @override
  void dispose() {
    // 댓글 입력하는 TextEditingController 제거
    _commentTextEditController.dispose();
    super.dispose();
  }

  // 위젯을 만들고 화면에 보여주는 함수
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WHITE,

      // appBar 구현 코드
      appBar: AppBar(
          backgroundColor: WHITE,
          title: Text(
            '임차인-자유게시판',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontFamily: 'Pretendard Variable',
              fontWeight: FontWeight.w600,
            ),
          )),
      // appBar 아래 UI 구현 코드
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(children: <Widget>[
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
                  subtitle: Text(questionData.create_date + "     " + questionData.modify_date),
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
                        // 수정 버튼
                        Container(
                          width: 112.95,
                          height: 41.94,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Container(
                                  width: 112.95,
                                  height: 41.94,
                                  decoration: ShapeDecoration(
                                    color: BLACK,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 11.92,
                                top: 9.64,
                                child: SizedBox(
                                  width: 91.96,
                                  height: 28.64,
                                  child: TextButton(
                                    onPressed: () {
                                      // 현재 user와 해당 게시글의 작성자가 같은지 확인
                                      if (user == questionData.author) {
                                        // 해당 question 데이터 가지고 수정 screen으로 전환
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                ModifyScreen(
                                                    data: questionData),
                                          ),
                                        );
                                      } else {
                                        // 현재 user와 해당 게시글의 작성자가 같지 않다면 수정을 할 수 없게 함
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('권한 오류'),
                                              content:
                                              Text('해당 게시글의 작성자가 아닙니다.'),
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
                                    child: Text(
                                      'Edit post',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: L_GREY,
                                        fontSize: 20,
                                        fontFamily: 'Pretendard Variable',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // 삭제 버튼
                        Container(
                          width: 118.50,
                          height: 41.94,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 2.78,
                                top: 0,
                                child: Container(
                                  width: 112.95,
                                  height: 41.94,
                                  decoration: ShapeDecoration(
                                    color: Color(0xFF628AAE),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 0,
                                top: 9.64,
                                child: SizedBox(
                                  width: 118.50,
                                  height: 28.64,
                                  child: TextButton(
                                    onPressed: () {
                                      // 현재 user와 해당 게시글의 작성자가 같은지 확인
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
                                                    QuerySnapshot snapshot =
                                                    await questionFirebase.questionReference
                                                        .where('title', isEqualTo: questionData.title)
                                                        .where('content', isEqualTo: questionData.content)
                                                        .where('author', isEqualTo: questionData.author)
                                                        .where('create_date', isEqualTo: questionData.create_date)
                                                        .get();

                                                    if (snapshot.docs.isNotEmpty) {
                                                      String documentId = snapshot.docs.first.id;
                                                      // 해당 question 데이터 삭제
                                                      await questionFirebase.questionReference.doc(documentId).delete();

                                                      // 해당 question의 answer 데이터 삭제
                                                      for (int i = 0; i < answer_snapshot!.docs.length; i++) {
                                                        await answerFirebase.answerReference.doc(answer_snapshot!.docs[i].id).delete();
                                                      }

                                                      // 게시물 list screen으로 전환
                                                      Navigator.pushNamed(context, '/test');
                                                    }
                                                  },
                                                ),
                                                TextButton(
                                                  child: Text('취소'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      } else {
                                        // 현재 user와 해당 게시글의 작성자가 같지 않다면 삭제를 할 수 없게 함
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('권한 오류'),
                                              content:
                                              Text('해당 게시글의 작성자가 아닙니다.'),
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
                                    child: Text(
                                      'Delete post',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: WHITE,
                                        fontSize: 20,
                                        fontFamily: 'Pretendard Variable',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
                // 조회수, 좋아요
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(children: [
                      Container(
                        padding: EdgeInsets.all(5),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 25.91,
                              child: Text(
                                'View  ',
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  color: TEXT_GREY,
                                  fontSize: 10,
                                  fontFamily: 'Pretendard Variable',
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                            // 조회수 보여주는 코드
                            Text(
                              (questionDoc.data() as Map<String, dynamic>)['views_count'].toString(),
                              style: TextStyle(
                                fontFamily: 'Pretendard Variable',
                                // 원하는 폰트 패밀리로 변경
                                fontSize: 10,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: IconButton(
                          onPressed: () async {
                            QuerySnapshot snapshot = await questionFirebase.questionReference
                                .where('title', isEqualTo: questionData.title)
                                .where('content', isEqualTo: questionData.content)
                                .where('author', isEqualTo: questionData.author)
                                .where('create_date', isEqualTo: questionData.create_date)
                                .get();
                            // 해당 게시글의 좋아요 유무를 반대로 바꿔줌
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
                            // 좋아요가 true이면 blue, false이면 black으로 아이콘 색을 보여줌
                            color: questionData.isLikeClicked
                                ? Colors.blue : Colors.black,
                            Icons.thumb_up_alt_outlined,
                          ),
                        ),
                      ),
                    ])),
                // 경계
                SizedBox(
                  height: 1,
                ),
                Divider(
                  thickness: 1,
                ),
                // 답변 목록이 null일 경우
                answers_null_len == COMMON_INIT_COUNT
                    ? Center(
                  child: Text('아직 작성된 답변이 없습니다'),
                )
                // 답변 목록이 null이 아닐 경우
                    : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: answer_snapshot!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      // answer의 데이터 저장
                      List<DocumentSnapshot> sortedDocs = answer_snapshot!.docs;
                      // answer 데이터들을 최신순으로 sort
                      sortedDocs.sort((a, b) {
                        return a['create_date'].compareTo(b['create_date']);
                      });
                      DocumentSnapshot answerData = sortedDocs[index];

                      return ListTile(
                        title: Row(
                          children: [
                            Text(answerData['content']),
                            // 삭제 버튼
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
                                                questionFirebase.questionReference.doc(questionId).update({
                                                  'answerCount': FieldValue.increment(DECREASE_COUNT),});

                                                QuerySnapshot snapshot = await answerFirebase.answerReference
                                                    .where('question', isEqualTo: answerData['question'])
                                                    .where('content', isEqualTo: answerData['content'])
                                                    .where('create_date', isEqualTo: answerData['create_date'])
                                                    .get();
                                                if (snapshot.docs.isNotEmpty) {
                                                  String documentId = snapshot.docs.first.id;
                                                  await answerFirebase.answerReference.doc(documentId).delete();
                                                  // 게시물 list screen으로 전환
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
                            //Text(answerData['modify_date']),
                          ],
                        ),
                      );
                    }),
              ]),
            ),
          ),
          // 댓글 입력창
          Container(
            width: 348.84,
            height: 54.22,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 0,
                  child: Container(
                    width: 348.84,
                    height: 54.22,
                    decoration: ShapeDecoration(
                      color: L_GREY,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      shadows: [
                        BoxShadow(
                          color: L_GREY,
                          blurRadius: 4,
                          offset: Offset(0, 0),
                          spreadRadius: 2,
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 15,
                  top: 12,
                  child: Container(
                    width: 270,
                    child: TextFormField(
                      controller: _commentTextEditController,
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return '댓글을 입력해주세요';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '댓글을 입력해주세요',
                        hintStyle: TextStyle(
                          color: SUB_BLUE,
                          fontSize: 14,
                          fontFamily: 'Pretendard Variable',
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 15,
                  top: 12,
                  child: IconButton(
                    icon: Icon(
                      Icons.send,
                      color: SUB_BLUE,
                    ),
                    onPressed: () {
                      // 입력받은 answer 데이터
                      String commentText = _commentTextEditController.text;
                      if (commentText.trim().isEmpty) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('댓글 오류'),
                              content: Text('댓글을 입력해주세요.'),
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
                      } else {
                        Answer newAnswer = Answer(
                          question: questionId,
                          content: commentText,
                          author: user,
                          create_date: DateFormat('yy/MM/dd/HH/mm/ss').format(DateTime.now()),
                          //modify_date: 'Null',
                        );
                        // DB의 answer 컬렉션에 newAnswer document 추가
                        answerFirebase.addAnswer(newAnswer);
                        questionFirebase.questionReference.doc(questionId).update({
                          'answerCount': FieldValue.increment(INCREASE_COUNT),
                        });
                        // 댓글 입력창을 비웁니다.
                        _commentTextEditController.clear();
                        // 데이터를 다시 불러옵니다.
                        fetchData();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
