import 'package:board_project/screens/activity/my_activity_screen.dart';
import 'package:board_project/screens/rounge/infinite_scroll_page.dart';
import 'package:board_project/screens/space/building_board_screen.dart';
import 'package:flutter/material.dart';

class TabScreen extends StatefulWidget {
  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  int _selectedPageIndex = 0;

  List _pages = [
    Text('홈'),
    InfiniteScrollPage(),
    BuildingBoardScreen(),
    Text('캘린더'),
    MyActivityScreen(),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _pages[_selectedPageIndex],),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onItemTapped,
        currentIndex: _selectedPageIndex,
        fixedColor: Color(0xFF0F4C82),
        unselectedItemColor: Color(0xFF9C9EA1),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.sms), label: '라운지'),
          BottomNavigationBarItem(icon: Icon(Icons.now_wallpaper), label:'공간기록'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: '캘린더'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '내 활동'),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }
}