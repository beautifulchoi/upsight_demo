/*
전체 게시글 보여주는 list page : 무한 스크롤 페이지네이션, 정렬 기능 구현
 */

import 'package:board_project/providers/question_firestore.dart';
import 'package:board_project/screens/search_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:board_project/models/question.dart';
import 'package:board_project/screens/create_screen.dart';
import 'package:board_project/screens/detail_screen.dart';
import 'package:intl/intl.dart';

class InfiniteScrollPage extends StatefulWidget {
  @override
  _InfiniteScrollPageState createState() => _InfiniteScrollPageState();
}

class _InfiniteScrollPageState extends State<InfiniteScrollPage> {
  // DB에서 받아온 question 컬렉션 데이터 담을 list
  List<Question> questions = [];
  QuestionFirebase questionFirebase = QuestionFirebase();
  // 임의로 지정할 user name, 추후 user model과 연결해야해서 DB 연결시켜야함
  late String user;

  // 화면에서 한 번에 보여줄 리스트 갯수, 밑으로 스크롤하면 해당 크기만큼 추가로 로딩됨
  int pageSize = 20;
  // 스크롤하여 가장 마지막에 로드된 question document 위치 저장하는 변수
  DocumentSnapshot? lastDocument;
  // 데이터 로딩 중인지 유무 저장하는 변수
  bool isLoading = false;
  // DB에서 불러온 마지막 데이터인지 유무 저장하는 변수
  bool isLastPage = false;
  // 스크롤컨트롤러 생성
  ScrollController _scrollController = ScrollController();

  // 게시글(question) 하나를 눌렀을 때 상세화면에 넘겨줄 해당 게시글 documentId
  late String documentId;

  // 화면에 보여질 게시글 정렬 기준(true일 경우 생성일 순, false일 경우 조회수 순)
  bool isCreateSort = true;

  // _InfiniteScrollPageState가 생성될 때 호출(맨 처음에 한 번만 실행되는 초기화 함수)
  @override
  void initState() {
    super.initState();

    // _scrollController에 리스너 추가
    _scrollController.addListener(_scrollListener);
    setState(() {
      questionFirebase.initDb();
      // Widget의 build 이후에 callback을 받기 위한 코드
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        // 테스트용 코드 : DB에 데이터 한꺼번에 생성하는 함수
        //generateData();
        // DB 데이터 받아오는 함수
        fetchData();
      });
    });
    user = 'admin';
  }

  // _InfiniteScrollPageState가 제거될 때 호출
  @override
  void dispose() {
    // _scrollController에 리스너 삭제
    _scrollController.removeListener(_scrollListener);
    // 스크롤컨트롤러 제거
    _scrollController.dispose();
    super.dispose();
  }

  // 테스트용 코드 : DB에 데이터 한꺼번에 생성하는 함수
  Future<void> generateData() async {
    // question collection의 reference 받아오는 코드
    CollectionReference questionsRef = questionFirebase.questionReference;

    // 22번 question DB 데이터 생성 및 저장
    for (int i = 0; i < 22; i++) {
      await questionsRef.add({
        'title': '$i번째 제목',
        'content': '$i번째 내용',
        'author': user,
        'create_date': DateFormat('yy/MM/dd/HH/mm/ss').format(DateTime.now()),
        'modify_date': 'Null',
        'category': '$i번째 카테고리',
        'views_count': 0,
        'isLikeClicked': false,
      });
    }
  }

  // DB 데이터 받아오는 함수
  Future<void> fetchData() async {
    // 로딩 중인지 DB에서 받아온 데이터가 마지막인지 확인
    if (isLoading || isLastPage) return;

    setState(() {
      isLoading = true;
    });

    // 처음 앱을 실행했을 때 생성일 순으로 question 데이터를 보여주기 위한 코드
    Query query = questionFirebase.questionReference.orderBy('create_date', descending: true);

    // DB에서 현재 받아온 마지막 데이터가 DB의 마지막 데이터인지 확인
    if (lastDocument != null) {
      // 데이터를 읽어올 시작 document를 lastDocument로 변경
      query = query.startAfterDocument(lastDocument!);
    }

    // 데이터 수 제한
    query = query.limit(pageSize);
    // 가져온 query 데이터의 DocumentSnapshot() 저장
    QuerySnapshot querySnapshot = await query.get();
    // snapshot을 통해 가져온 question 데이터들을 list로 저장
    List<QueryDocumentSnapshot> newItems = querySnapshot.docs;

    setState(() {
      // type 맞춰서 기존 questions에 스크롤로 로딩할 때마다 가져온 query 데이터 추가
      questions.addAll(newItems.map((doc) => Question.fromSnapshot(doc)).toList());
      // 가져온 query 데이터가 비어있으면 null 저장, 아니라면 가져온 query 데이터의 마지막 값 저장
      lastDocument = newItems.isNotEmpty ? newItems.last : null;

      isLoading = false;
      // 가져온 query 데이터의 크기가 한번에 가져올 데이터 수보다 작다면 마지막 페이지
      if (newItems.length < pageSize) {
        isLastPage = true;
      }
    });
  }

  // 조회수 증가시키는 함수
  Future<void> increaseViewsCount(Question question) async {
    // 조회수를 증가시킬 question document의 DocumentSnapshot() 저장
    QuerySnapshot snapshot = await questionFirebase.questionReference
        .where('title', isEqualTo: question.title)
        .where('content', isEqualTo: question.content)
        .where('author', isEqualTo: question.author)
        .where('create_date', isEqualTo: question.create_date)
        .get();

    // 해당 document Id 값 저장
    if (snapshot.docs.isNotEmpty) {
      String documentId = snapshot.docs.first.id;

      // 해당 question의 조회수를 증가된 값으로 업데이트
      await questionFirebase.questionReference.doc(documentId).update({
        'views_count': FieldValue.increment(1),
      });
      question.views_count += 1;
    }
  }

  // 게시글 목록을 보여줄 UI 위젯
  Widget _buildItemWidget(Question question) {
    return ListTile(
      title: Text(question.title),
      subtitle: Text(question.content),
      trailing: Column(
        children: [
          Text(question.author),
          Text(question.create_date),
        ],
      ),
      onTap: () async {
        // 게시글 중 하나를 눌렀을 경우 해당 게시글의 조회수 증가
        await increaseViewsCount(question);

        QuerySnapshot snapshot = await questionFirebase.questionReference
            .where('title', isEqualTo: question.title)
            .where('content', isEqualTo: question.content)
            .where('author', isEqualTo: question.author)
            .where('create_date', isEqualTo: question.create_date)
            .get();

        if (snapshot.docs.isNotEmpty) {
          documentId = snapshot.docs.first.id;
        }

        // 게시글의 상세화면을 보여주는 screen으로 화면 전환(인자: 해당 게시글 데이터, 해당 게시글의 document Id)
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (BuildContext context) => DetailScreen(data: question, dataId: documentId)),
        );
      },
    );
  }

  // 스크롤 이벤트를 처리하는 함수
  void _scrollListener() {
    // 클라이언트를 가지고 있는지 확인하여 아니라면 종료
    if (!_scrollController.hasClients) return;

    // 최대 스크롤 범위 할당
    final maxScroll = _scrollController.position.maxScrollExtent;
    // 현재 스크롤 위치 할당
    final currentScroll = _scrollController.position.pixels;

    // 스크롤을 최하단까지 내렸을 때 추가로 더 가져올 데이터가 있을 때 실행되는 코드
    if (currentScroll >= maxScroll && !isLoading && !isLastPage) {
      fetchData();
    }
  }

  // 위젯을 만들고 화면에 보여주는 함수
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar 구현 코드
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.red,
        title: Text('게시판'),
        // appBar의 우측에 생성되는 위젯
        actions: <Widget>[
          // 눌렀을 경우 퍼지는 효과? 애니메이션?을 주는 함수
          InkWell(
            onTap: () async {
              // 해당 아이콘을 눌렀을 경우 검색 screen으로 화면 전환
              await Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (BuildContext context) => SearchScreen()),
              );
            },
            child: Container(
              color: Colors.green,
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search),
                ],
              ),
            ),
          ),
        ],
      ),
      // 게시글 생성하는 버튼
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        child: Text('+', style: TextStyle(fontSize: 25)),
        onPressed: () async {
          // 해당 버튼을 눌렀을 경우 게시글 생성 screen으로 화면 전환, 다시 본 screen으로 넘어올 때 새로 생성된 게시글의 데이터를 받아옴
          final newQuestion = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => CreateScreen(),
            ),
          );
          // 새로 생성된 게시글의 데이터가 null인지 확인하는 코드
          if (newQuestion != null) {
            setState(() {
              // questions에 새로 생성된 게시글 추가
              questions.insert(0, newQuestion);
            });
          }
        },
      ),
      // appBar 아래 UI 구현 코드
      body: Column(
        children: [
          // 정렬 기준 바꿀 수 있는 textbutton
          TextButton.icon(
            icon: RotatedBox(
              quarterTurns: 1,
              child: Icon(Icons.compare_arrows, size: 28),
            ),
            label: Text(
              // 현재 정렬 기준이 정렬 기준이 최신순이라면 최신순으로, 아니라면 조회순으로 글자 보여줌
              isCreateSort ? '최신순' : '조회순',
              style: TextStyle(fontSize: 16),
            ),
            onPressed: () {
              setState(() {
                // 정렬 기준이 최신순이라면 최신순으로, 아니라면 조회순으로 보여줌
                isCreateSort = !isCreateSort;
              });
            },
          ),
          Expanded(
              child:
              ListView.builder(
                itemCount: questions.length + (isLastPage ? 0 : 1),
                itemBuilder: (BuildContext context, int index) {
                  // 정렬 기준이 최신순이라면 최신순으로, 아니라면 조회순으로 보여주는 코드
                  isCreateSort ? questions.sort((a, b) => b.create_date.compareTo(a.create_date)) : questions.sort((a, b) => b.views_count.compareTo(a.views_count));

                  // 현재 index가 questions 크기와 같은지 판별하는 코드
                  if (index == questions.length) {
                    // 로딩 중이라면 로딩 circle 보여줌
                    if (isLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      // 로딩 중이 아니라면 빈 위젯 보여줌
                      return SizedBox.shrink();
                    }
                  }
                  // 현재 index가 questions 크기보다 작다면 해당 순서의 question 데이터로 list 보여주는 함수 실행
                  return _buildItemWidget(questions[index]);
                },
                controller: _scrollController,
              ),
          )
        ],
      )
    );
  }
}