/*
게시글(question) 생성하는 page
 */

import 'package:firebase_storage/firebase_storage.dart';
import 'package:board_project/models/user.dart';
import 'package:flutter/material.dart';
import 'package:board_project/models/question.dart';
import 'package:intl/intl.dart';
import 'package:board_project/providers/question_firestore.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:board_project/providers/user_firestore.dart';

import '../../constants/colors.dart';
import '../../constants/size.dart';


class CreateScreen extends StatefulWidget {
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  QuestionFirebase questionFirebase = QuestionFirebase();
  UserFirebase userFirebase = UserFirebase();

  // 새로 생성하는 question model의 각 필드 초기화
  String title = '';
  String content = '';
  String author = '';
  String create_date = '';
  String modify_date = 'Null';
  String category = '';
  int views_count = COMMON_INIT_COUNT;
  bool isLikeClicked = false;
  int answerCount = COMMON_INIT_COUNT;

  // 임의로 지정할 user name, 추후 user model과 연결해야해서 DB 연결시켜야함
  late String user;

  final List<File> _images = [];
  final picker = ImagePicker();

  // 비동기 처리를 통해 카메라와 갤러리에서 이미지를 가져옴
  getImage() async {
    final List<XFile> images = await picker.pickMultiImage();
    if (images != null) {
      images.forEach((e) {
        _images.add(File(e.path));
      });

      setState(() {});
    }
  }

  // 이미지 삭제하는 함수
  delImage(File image) {
    _images.remove(image);
  }

  // 이미지를 보여주는 위젯
  Widget showImage() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 3,
        crossAxisSpacing: 2.5,
        children: _images.map((e) => _gridImage(e)).toList(),
      ),
    );
  }

  Widget _gridImage(File image) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: FileImage(image),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  delImage(image);
                });
              },
              child: Container(
                width: 20,
                height: 20,
                child: Icon(
                  Icons.cancel,
                  size: 15,
                ),
              ),
            )
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      questionFirebase.initDb();
      userFirebase.initDb();
    });
    // 'user_id' 값을 가져와서 'user' 변수에 할당
    fetchUser();
  }

  // 사용자 데이터를 가져와서 'user' 변수에 할당하는 함수
  Future<void> fetchUser() async {
    final userSnapshot = await userFirebase.userReference.get();

    if (userSnapshot.docs.isNotEmpty) {
      final document = userSnapshot.docs.first;
      setState(() {
        user = (document.data() as Map<String, dynamic>)['user_id'];
      });
    }
  }

  // 위젯을 만들고 화면에 보여주는 함수
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar 구현 코드
      appBar: AppBar(
        // 뒤로가기 버튼 삭제
        // automaticallyImplyLeading: false,
          backgroundColor: WHITE,
          title: Text(
            '글 작성하기',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: BLACK,
              fontSize: 20,
              fontFamily: 'Pretendard Variable',
              fontWeight: FontWeight.w600,
            ),
          )
      ),
      // appBar 아래 UI 구현 코드
      body: SingleChildScrollView(
        child: Container(
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
                    category = value;
                  });
                },
                decoration: InputDecoration(labelText: '카테고리', prefixText: '#'),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Text('사진 업로드'),
                  // 카메라 촬영 버튼
                  // IconButton(
                  //   icon: Icon(Icons.add_a_photo),
                  //   onPressed: () {
                  //     getImage(ImageSource.camera);
                  //   },
                  // ),
                  // // 갤러리에서 이미지를 가져오는 버튼
                  // IconButton(
                  //   icon: Icon(Icons.wallpaper),
                  //   onPressed: () {
                  //     getImage(ImageSource.gallery);
                  //   },
                  // ),
                  IconButton(
                    icon: Icon(Icons.wallpaper),
                    onPressed: () {
                      getImage();
                    },
                  ),
                ],
              ),
              TextField(
                onChanged: (value) {
                  setState(() {
                    content = value;
                  });
                },
                decoration: InputDecoration(labelText: '내용'),
              ),
              SizedBox(height: 16),
              showImage(),
              SizedBox(height: 16),
              // 게시글 작성 완료 버튼
              GestureDetector(
                onTap: () {
                  // 버튼을 눌렀을 때 수행할 동작 추가
                  // 모든 필드가 작성되었는지 확인
                  if (title.isNotEmpty && content.isNotEmpty && category.isNotEmpty) {
                    // 입력받은 데이터로 새로운 question 데이터 생성하여 DB에 생성
                    Question newQuestion = Question(
                      title: title,
                      content: content,
                      author: user,
                      create_date: DateFormat('yy/MM/dd/HH/mm/ss').format(DateTime.now()),
                      modify_date: modify_date,
                      category: category,
                      views_count: views_count,
                      isLikeClicked: isLikeClicked,
                      answerCount: answerCount,
                    );
                    questionFirebase.addQuestion(newQuestion).then((value) {
                      // 새로 생성된 데이터는 이전 화면인 게시물 list screen으로 전환되면서 전달됨(현재 infinite_scroll_page)
                      Navigator.of(context).pop(newQuestion);
                    });
                    // 이미지 storage에 업로드
                    // for (int i = 0; i < _images.length; i++) {
                    //   FirebaseStorage.instance.ref("question/test_${i}").putFile(_images[i]);
                    // }
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
                child: Container(
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
                            color: SUB_BLUE,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20.98,
                        top: 9.64,
                        child: SizedBox(
                          width: 74.93,
                          height: 28.64,
                          child: Text(
                            '입력완료',
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
                    ],
                  ),
                ),
              )

              // 게시글 작성 취소 버튼
              // OutlinedButton(
              //   onPressed: () {
              //     // 이전 화면인 게시물 list screen으로 전환(현재 infinite_scroll_page)
              //     Navigator.of(context).pop();
              //   },
              //   style: ButtonStyle(
              //     minimumSize: MaterialStateProperty.all(Size(8.12, 15.46)),
              //     padding: MaterialStateProperty.all(EdgeInsets.zero),
              //     backgroundColor: MaterialStateProperty.all(Colors.transparent),
              //     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              //       RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(0),
              //       ),
              //     ),
              //   ),
              //   child: Container(
              //     width: 8.12,
              //     height: 15.46,
              //     child: Icon(
              //       Icons.arrow_back,
              //       color: Colors.black,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      )
    );
  }
}