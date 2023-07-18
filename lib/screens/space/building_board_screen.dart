/*
전체 건물 보여주는 list page : 무한 스크롤 페이지네이션, 정렬 기능 구현
 */

import 'package:board_project/providers/building_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:board_project/screens/space/building_create_screen.dart';
import 'package:board_project/models/building.dart';
import 'package:board_project/screens/space/building_information_screen.dart';

class BuildingBoardScreen extends StatefulWidget {
  @override
  _BuildingBoardScreenState createState() => _BuildingBoardScreenState();
}

class _BuildingBoardScreenState extends State<BuildingBoardScreen> {
  // DB에서 받아온 building 컬렉션 데이터 담을 list
  List<Building> buildings = [];
  BuildingFirebase buildingFirebase = BuildingFirebase();

  // 화면에서 한 번에 보여줄 리스트 갯수, 밑으로 스크롤하면 해당 크기만큼 추가로 로딩됨
  int pageSize = 10;
  // 스크롤하여 가장 마지막에 로드된 building document 위치 저장하는 변수
  DocumentSnapshot? lastDocument;
  // 데이터 로딩 중인지 유무 저장하는 변수
  bool isLoading = false;
  // DB에서 불러온 마지막 데이터인지 유무 저장하는 변수
  bool isLastPage = false;
  // 스크롤컨트롤러 생성
  ScrollController _scrollController = ScrollController();

  // 게시글(building) 하나를 눌렀을 때 상세화면에 넘겨줄 해당 게시글 documentId
  late String documentId;

  // 즐겨찾기 버튼 눌렀는지 유무 저장하는 변수
  bool bookmarkData = false;

  // 검색된 게시글의 document Id를 저장할 변수
  late String searchDocumentId;

  // 검색어 저장할 변수
  String searchText = '';

  @override
  void initState() {
    super.initState();

    // _scrollController에 리스너 추가
    _scrollController.addListener(_scrollListener);
    setState(() {
      buildingFirebase.initDb();
      // Widget의 build 이후에 callback을 받기 위한 코드
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        // DB 데이터 받아오는 함수
        fetchData();
      });
    });
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

  // DB 데이터 받아오는 함수
  Future<void> fetchData() async {
    // 로딩 중인지 DB에서 받아온 데이터가 마지막인지 확인
    if (isLoading || isLastPage) return;

    setState(() {
      isLoading = true;
    });

    // 처음 앱을 실행했을 때 생성일 순으로 building 데이터를 보여주기 위한 코드
    Query query = buildingFirebase.buildingReference.orderBy('create_date', descending: true);

    // DB에서 현재 받아온 마지막 데이터가 DB의 마지막 데이터인지 확인
    if (lastDocument != null) {
      // 데이터를 읽어올 시작 document를 lastDocument로 변경
      query = query.startAfterDocument(lastDocument!);
    }

    // 데이터 수 제한
    query = query.limit(pageSize);
    // 가져온 query 데이터의 DocumentSnapshot() 저장
    QuerySnapshot querySnapshot = await query.get();
    // snapshot을 통해 가져온 building 데이터들을 list로 저장
    List<QueryDocumentSnapshot> newItems = querySnapshot.docs;

    setState(() {
      // type 맞춰서 기존 buildings에 스크롤로 로딩할 때마다 가져온 query 데이터 추가
      buildings.addAll(newItems.map((doc) => Building.fromSnapshot(doc)).toList());
      // 가져온 query 데이터가 비어있으면 null 저장, 아니라면 가져온 query 데이터의 마지막 값 저장
      lastDocument = newItems.isNotEmpty ? newItems.last : null;

      isLoading = false;
      // 가져온 query 데이터의 크기가 한번에 가져올 데이터 수보다 작다면 마지막 페이지
      if (newItems.length < pageSize) {
        isLastPage = true;
      }
    });
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
    searchText = str;
    // 제목만 검색되게 함
    Future<QuerySnapshot> allBuildings = buildingFirebase.buildingReference.where('name', isEqualTo: str).get();
    setState(() {
      // DB에서 필터링한 Building들 저장
      searchResults = allBuildings;
    });
  }

  // 건물 목록을 보여줄 UI 위젯
  Widget _buildItemWidget(Building building) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Color(0x11000000),),
      ),
      title: Text(building.name,
        style: TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontFamily: 'Pretendard Variable',
          fontWeight: FontWeight.w500,
      ),),
      subtitle: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: building.address,
              style: TextStyle(
                color: Color(0xFF585858),
                fontSize: 14,
                fontFamily: 'Pretendard Variable',
                fontWeight: FontWeight.w300,
              ),
            ),
            TextSpan(
              text: '\n'
            ),
            TextSpan(
              text: building.create_date,
              style: TextStyle(
                color: Color(0xFF585858),
                fontSize: 10,
                fontFamily: 'Pretendard Variable',
                fontWeight: FontWeight.w300,
              ),
            )
          ]
        )
      ),
      trailing: IconButton(
          onPressed: () async {
            QuerySnapshot snapshot = await buildingFirebase.buildingReference
                .where('name', isEqualTo: building.name)
                .where('address', isEqualTo: building.address)
                .where('create_date', isEqualTo: building.create_date)
                .get();

            // 해당 건물의 즐겨찾기 유무를 반대로 바꿔줌
            if (snapshot.docs.isNotEmpty) {
              bookmarkData = building.bookmark;
              String documentId = snapshot.docs.first.id;
              await buildingFirebase.buildingReference.doc(documentId).update({'bookmark': !building.bookmark});
              setState(() {
                building.bookmark = !bookmarkData;
              });
            }
          },
          icon: Icon(
            // 즐겨찾기 유무에 따라 다른 icon을 보여줌
              color: Color(0xFF0F4C82),
              building.bookmark ? Icons.stars_rounded : Icons.stars_outlined
          )),
      onTap: () async {
        QuerySnapshot snapshot = await buildingFirebase.buildingReference
            .where('name', isEqualTo: building.name)
            .where('address', isEqualTo: building.address)
            .where('content', isEqualTo: building.content)
            .where('create_date', isEqualTo: building.create_date)
            .get();

        if (snapshot.docs.isNotEmpty) {
          documentId = snapshot.docs.first.id;
        }

        // 건물의 정보조회 화면을 보여주는 screen으로 화면 전환(인자: 해당 건물 데이터, 해당 건물의 document Id)
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (BuildContext context) => BuildingInformationScreen(data: building, dataId: documentId)),
        );
      },
    );
  }

  // 전체 building 목록을 보여주기 위한 함수
  Widget _totalItemWidget() {
    return ListView.builder(
        itemCount: buildings.length + (isLastPage ? 0 : 1),
        itemBuilder: (BuildContext context, int index) {
          // 현재 index가 buildings 크기와 같은지 판별하는 코드
          if (index == buildings.length) {
            // 로딩 중이라면 로딩 circle 보여줌
            if (isLoading) {
              return Center(child: CircularProgressIndicator());
            } else {
              // 로딩 중이 아니라면 빈 위젯 보여줌
              return SizedBox.shrink();
            }
          }
          // 현재 index가 buildings 크기보다 작다면 해당 순서의 building 데이터로 list 보여주는 함수 실행
          return Padding(padding: EdgeInsets.only(top: 3, bottom: 3, left: 15, right: 15), child: _buildItemWidget(buildings[index]));
        },
      controller: _scrollController,
    );
  }

  // 검색된 building 목록을 보여주기 위한 함수
  Widget _searchItemWidget() {
    return FutureBuilder(
        future: searchResults,
        builder: (context, snapshot) {
          // snapshot에 데이터가 없으면 로딩 circle 보여줌
          if(!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          // 검색어로 검색된 building 데이터들을 저장할 list
          List<Building> searchBuildingResult = [];
          snapshot.data!.docs.forEach((document) {
            Building building = Building.fromSnapshot(document);
            // 각 building 순서대로 list에 추가
            searchBuildingResult.add(building);
          });

          // 검색된 결과가 없을 경우
          if(searchBuildingResult.isEmpty) {
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
            // 검색된 결과들을 보여주는 UI 코드
            return ListView.builder(
                itemCount: searchBuildingResult.length,
                itemBuilder: (BuildContext context, int index) {
                  return _buildItemWidget(searchBuildingResult[index]);
                },
              controller: _scrollController,
            );
          }
        }
    );
  }

  // 위젯을 만들고 화면에 보여주는 함수
  @ override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('공간 기록',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontFamily: 'Pretendard Variable',
            fontWeight: FontWeight.w600,),
        ),
      ),
      // 새 공간 생성하기 버튼
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: 148.04,
          height: 49,
          decoration: ShapeDecoration(
            color: Color(0xFF628AAE),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(23.50),
            ),
          ),
          child: FloatingActionButton(
            onPressed: () async {
              // 해당 버튼을 눌렀을 경우 건물 생성 screen으로 화면 전환, 다시 본 screen으로 넘어올 때 새로 생성된 건물의 데이터를 받아옴
              final newBuilding = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => BuildingCreateScreen(),
                ),
              );
              // 새로 생성된 건물의 데이터가 null인지 확인하는 코드
              if (newBuilding != null) {
                setState(() {
                  // questions에 새로 생성된 게시글 추가
                  buildings.insert(0, newBuilding);
                });
              }
            },
            backgroundColor: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_home_outlined, color: Colors.white,),
                SizedBox(width: 5,),
                Text('새 공간 추가',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'Pretendard Variable',
                    fontWeight: FontWeight.w600,
                  ),)
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          // 나중에 wigdet 디렉터리로 빼야 함
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Text('모든 공간',
                  style: TextStyle(
                    color: Color(0xFF0F4C82),
                    fontSize: 14,
                    fontFamily: 'Pretendard Variable',
                    fontWeight: FontWeight.w700,
                  ),),),
              Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Text('하자',
                  style: TextStyle(
                    color: Color(0xFF75777C),
                    fontSize: 14,
                    fontFamily: 'Pretendard Variable',
                    fontWeight: FontWeight.w700,
                  ),),),
              Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Text('계약',
                  style: TextStyle(
                    color: Color(0xFF75777C),
                    fontSize: 14,
                    fontFamily: 'Pretendard Variable',
                    fontWeight: FontWeight.w700,
                  ),),),
              Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Text('보고서 관리',
                  style: TextStyle(
                    color: Color(0xFF75777C),
                    fontSize: 14,
                    fontFamily: 'Pretendard Variable',
                    fontWeight: FontWeight.w700,
                  ),),),
            ],
          ),
          // 검색창
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextFormField(
              // 검색창 controller
              controller: searchTextController,
              decoration: InputDecoration(
                hintText: '공간 별칭을 검색하세요.',
                hintStyle: TextStyle(
                  color: Color(0xFF9C9EA0),
                  fontSize: 14,
                  fontFamily: 'Pretendard Variable',
                  fontWeight: FontWeight.w400,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                prefixIcon: Icon(Icons.search,),
                suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: emptyTextFormField,
                ),
                // 폼 필드의 기본 테두리
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide(color: Color(0x11000000),),
                ),
                // 폼 필드가 활성화되어 있을 때 적용되는 테두리
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide(color: Color(0x11000000),),
                ),
                // 폼 필드 위에 마우스가 올라왔을 때 적용되는 테두리
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide(color: Color(0x11000000),),
                ),
              ),
              style: TextStyle(
                  color: Colors.black
              ),
              // 키보드의 search 버튼을 누르면 게시물 검색 함수 실행
              textInputAction: TextInputAction.search,
              onFieldSubmitted: controlSearching,
            ),),
          // 건물 리스트
          Expanded(
              child: searchText.isEmpty ? _totalItemWidget() : _searchItemWidget()
          )
        ],
      )
    );
  }
}