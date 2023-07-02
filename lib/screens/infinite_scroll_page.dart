import 'package:board_project/providers/question_firestore.dart';
import 'package:board_project/screens/search_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:board_project/models/question.dart';
import 'package:board_project/screens/create_screen.dart';
import 'package:board_project/screens/detail_screen.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class InfiniteScrollPage extends StatefulWidget {
  @override
  _InfiniteScrollPageState createState() => _InfiniteScrollPageState();
}

class _InfiniteScrollPageState extends State<InfiniteScrollPage> {
  List<Question> questions = [];
  QuestionFirebase questionFirebase = QuestionFirebase();
  late String user;

  int pageSize = 20;
  DocumentSnapshot? lastDocument;
  bool isLoading = false;
  bool isLastPage = false;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_scrollListener);
    setState(() {
      questionFirebase.initDb();
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        //generateData();
        fetchData();
      });
    });
    user = 'admin';
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> generateData() async {
    CollectionReference questionsRef = questionFirebase.questionReference;

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

  Future<void> fetchData() async {
    if (isLoading || isLastPage) return;

    setState(() {
      isLoading = true;
    });

    Query query = questionFirebase.questionReference.orderBy('create_date', descending: true);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument!);
    }

    query = query.limit(pageSize);

    QuerySnapshot querySnapshot = await query.get();
    List<QueryDocumentSnapshot> newItems = querySnapshot.docs;

    setState(() {
      questions.addAll(newItems.map((doc) => Question.fromSnapshot(doc)).toList());
      lastDocument = newItems.isNotEmpty ? newItems.last : null;
      isLoading = false;
      if (newItems.length < pageSize) {
        isLastPage = true;
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
        await increaseViewsCount(question);

        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (BuildContext context) => DetailScreen(data: question)),
        );
      },
    );
  }

  void _scrollListener() {
    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (currentScroll >= maxScroll && !isLoading && !isLastPage) {
      fetchData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('게시판'),
        actions: <Widget>[
          InkWell(
            onTap: () async {
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
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        child: Text('+', style: TextStyle(fontSize: 25)),
        onPressed: () async {
          final newQuestion = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => CreateScreen(),
            ),
          );
          if (newQuestion != null) {
            setState(() {
              questions.insert(0, newQuestion);
            });
          }
        },
      ),
      body: ListView.builder(
        itemCount: questions.length + (isLastPage ? 0 : 1),
        itemBuilder: (BuildContext context, int index) {
          if (index == questions.length) {
            if (isLoading) {
              return Center(child: CircularProgressIndicator());
            } else {
              return SizedBox.shrink();
            }
          }
          return _buildItemWidget(questions[index]);
        },
        controller: _scrollController,
      ),
    );
  }
}