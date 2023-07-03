import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:board_project/models/question.dart';
import 'package:board_project/providers/question_firestore.dart';
import 'package:board_project/screens/detail_screen.dart';

class SearchScreen extends StatefulWidget {
  //final List<Question> questions = [];
  //final Question eachQuestion;
  //SearchScreen(this.eachQuestion);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  QuestionFirebase questionFirebase = QuestionFirebase();
  late String documentId;

  @override
  void initState() {
    super.initState();
    setState(() {
      questionFirebase.initDb();
    });
  }

  // ** 검색창(상단) 만들기 **
  // 검색창 입력 내용 controller
  TextEditingController searchTextController = TextEditingController();
  // DB에서 검색한 게시글을 가져오는데 활용되는 변수
  Future<QuerySnapshot>? searchResults = null;

  // X 아이콘 클릭시 검색어 삭제
  emptyTextFormField() {
    searchTextController.clear();
  }

  // 검색어 입력 후 submit하게 되면 DB에서 검색어와 일치하거나 포함하는 결과 가져와서 future 변수에 저장
  controlSearching(str) {
    print(str);
    // 일단 제목만 검색되게 함
    Future<QuerySnapshot> allQuestions = questionFirebase.questionReference.where('title', isEqualTo: str).get();
    print(allQuestions);
    print("_______________-------------------------------");
    setState(() {
      // DB에서 필터링한 Question들 저장
      searchResults = allQuestions;
    });
  }

  // 검색 페이지 상단 부분
  AppBar searchPageHeader() {
    return AppBar(
      backgroundColor: Colors.red,
      title: TextFormField(
        // 검색창 controller
        controller: searchTextController,
        decoration: InputDecoration(
          hintText: '글 제목, 내용',
          hintStyle: TextStyle(
            color: Colors.black
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.green,)
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.yellow,)
          ),
          filled: true,
          prefixIcon: Icon(Icons.search,),
          suffixIcon: IconButton(icon: Icon(Icons.clear,), onPressed: emptyTextFormField)
        ),
        style: TextStyle(
          color: Colors.black
        ),
        textInputAction: TextInputAction.search,
        onFieldSubmitted: controlSearching,
      ),
    );
  }

  // ** 검색 결과(하단) 만들기 **
  // 검색어 입력 전 초기 상태
  displayNoSearchResultScreen() {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Icon(Icons.search, size: 50,),
            Text(
              '게시판의 글을 검색해보세요',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 20
              ),
            )
          ],
        ),
      ),
    );
  }

  // 검색어로 검색 후 결과 화면
  displayBoardsFountScreen() {
    return FutureBuilder(
        future: searchResults,
        builder: (context, snapshot) {
          if(!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          List<Question> searchBoardResult = [];
          snapshot.data!.docs.forEach((document) {
            Question question = Question.fromSnapshot(document);
            //SearchScreen questionResult = SearchScreen(questions);
            print(question.title);
            searchBoardResult.add(question);
          });

          if(searchBoardResult.isEmpty) {
            return Container(
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Icon(Icons.sentiment_dissatisfied_outlined, size: 50,),
                    Text(
                      '해당 게시글이 없어요',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 20
                      ),
                    )
                  ],
                ),
              ),
            );
          } else {
            return ListView.builder(
                itemCount: searchBoardResult.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(searchBoardResult[index].title),
                    trailing: Column(
                      children: [
                        Text(searchBoardResult[index].author),
                        Text(searchBoardResult[index].create_date),
                      ],
                    ),
                    onTap: () async {
                      await increaseViewsCount(searchBoardResult[index]);

                      QuerySnapshot snapshot = await questionFirebase
                          .questionReference
                          .where('title', isEqualTo: searchBoardResult[index].title)
                          .where(
                          'content', isEqualTo: searchBoardResult[index].content)
                          .where(
                          'author', isEqualTo: searchBoardResult[index].author)
                          .where('create_date',
                          isEqualTo: searchBoardResult[index].create_date)
                          .get();

                      if (snapshot.docs.isNotEmpty) {
                        documentId = snapshot.docs.first.id;
                      }

                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (BuildContext context) => DetailScreen(data: searchBoardResult[index], dataId: documentId,),),
                      );
                    },
                  );
                }
            );
          }
        });
  }

  Future<void> increaseViewsCount(Question question) async {
    QuerySnapshot snapshot = await questionFirebase.questionReference
        .where('title', isEqualTo: question.title)
        .where('content', isEqualTo: question.content)
        .where('author', isEqualTo: question.author)
        .where('create_date', isEqualTo: question.create_date)
        .get();

    if (snapshot.docs.isNotEmpty) {
      String documentId = snapshot.docs.first.id;

      await questionFirebase.questionReference.doc(documentId).update({
        'views_count': FieldValue.increment(1),
      });
      question.views_count += 1;
    }
  }

  // ** 검색창 화면 구성 **
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: searchPageHeader(),
      body: searchResults == null ? displayNoSearchResultScreen() : displayBoardsFountScreen(),
    );
  }
}





// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:board_project/models/question.dart';
// import 'package:board_project/providers/question_firestore.dart';
//
// class SearchScreen extends StatefulWidget {
//   final Question eachQuestion;
//   SearchScreen(this.eachQuestion);
//
//   @override
//   _SearchScreenState createState() => _SearchScreenState();
// }
//
// class _SearchScreenState extends State<SearchScreen> {
//   QuestionFirebase questionFirebase = QuestionFirebase();
//
//   @override
//   void initState() {
//     super.initState();
//     setState(() {
//       questionFirebase.initDb();
//     });
//   }
//
//   // ** 검색창(상단) 만들기 **
//   // 검색창 입력 내용 controller
//   TextEditingController searchTextController = TextEditingController();
//   // DB에서 검색한 게시글을 가져오는데 활용되는 변수
//   late Future<QuerySnapshot> searchResults;
//
//   // X 아이콘 클릭시 검색어 삭제
//   emptyTextFormField() {
//     searchTextController.clear();
//   }
//
//   // 검색어 입력 후 submit하게 되면 DB에서 검색어와 일치하거나 포함하는 결과 가져와서 future 변수에 저장
//   controlSearching(str) {
//     print(str);
//     // 일단 제목만 검색되게 함
//     Future<QuerySnapshot> allQuestions = questionFirebase.questionReference.where('title', isGreaterThanOrEqualTo: str).get();
//     setState(() {
//       // DB에서 필터링한 Question들 저장
//       searchResults = allQuestions;
//     });
//   }
//
//   // 검색 페이지 상단 부분
//   AppBar searchPageHeader() {
//     return AppBar(
//       backgroundColor: Colors.red,
//       title: TextFormField(
//         // 검색창 controller
//         controller: searchTextController,
//         decoration: InputDecoration(
//             hintText: '글 제목, 내용',
//             hintStyle: TextStyle(
//                 color: Colors.black
//             ),
//             enabledBorder: UnderlineInputBorder(
//                 borderSide: BorderSide(color: Colors.green,)
//             ),
//             focusedBorder: UnderlineInputBorder(
//                 borderSide: BorderSide(color: Colors.yellow,)
//             ),
//             filled: true,
//             prefixIcon: Icon(Icons.search,),
//             suffixIcon: IconButton(icon: Icon(Icons.clear,), onPressed: emptyTextFormField)
//         ),
//         style: TextStyle(
//             color: Colors.black
//         ),
//         textInputAction: TextInputAction.search,
//         onFieldSubmitted: controlSearching,
//       ),
//     );
//   }
//
//   // ** 검색 결과(하단) 만들기 **
//   // 검색어 입력 전 초기 상태
//   displayNoSearchResultScreen() {
//     final Orientation orientation = MediaQuery.of(context).orientation;
//     return Container(
//       child: Center(
//         child: ListView(
//           shrinkWrap: true,
//           children: <Widget>[
//             Icon(Icons.search, size: 50,),
//             Text(
//               '게시판의 글을 검색해보세요',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.w500,
//                   fontSize: 20
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   // 검색어로 검색 후 결과 화면
//   displayBoardsFountScreen() {
//     return FutureBuilder(
//         future: searchResults,
//         builder: (context, snapshot) {
//           if(!snapshot.hasData) {
//             return Center(child: CircularProgressIndicator());
//           }
//
//           List<SearchScreen> searchBoardResult = [];
//           snapshot.data!.docs.forEach((document) {
//             Question questions = Question.fromSnapshot(document);
//             SearchScreen questionResult = SearchScreen(questions);
//             searchBoardResult.add(questionResult);
//           });
//           return ListView(
//               children: searchBoardResult
//           );
//         });
//   }
//
//   // ** 검색창 화면 구성 **
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.blueAccent,
//       appBar: searchPageHeader(),
//       body: searchResults == null ? displayNoSearchResultScreen() : displayBoardsFountScreen(),
//     );
//   }
// }