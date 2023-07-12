import 'package:board_project/screens/auth_screen.dart';
import 'package:board_project/screens/rounge/create_screen.dart';
import 'package:board_project/screens/rounge/detail_screen.dart';
import 'package:board_project/screens/rounge/infinite_scroll_page.dart';
import 'package:board_project/screens/tab_screen.dart';
import 'package:flutter/material.dart';
import 'package:board_project/screens/rounge/board_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:get/get.dart';
import 'package:board_project/screens/rounge/search_screen.dart';
import 'package:board_project/screens/space/building_board_screen.dart';

void main() async {
  // 플랫폼 채널의 위젯 바인딩을 보장하기 위한 코드
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase를 초기화 하기 위해서 네이티브 코드를 호출
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // router 코드 : 원래 /test 말고 /로 initialRoute 바꾸고 inifinte_scroll_page 코드를 boardscreen에 구현해야 함
      //initialRoute: '/',
      //initialRoute: '/test',
      //initialRoute: '/building',
      //initialRoute: '/auth',
      initialRoute: '/tab',
      routes: {
        //'/': (context) => BoardScreen(),
        '/create': (context) => CreateScreen(),
        '/test': (context) => InfiniteScrollPage(),
        //'/search': (context) => SearchScreen(),
        '/building': (context) => BuildingBoardScreen(),
        '/auth': (context) => AuthScreen(),
        '/tab': (context) => TabScreen(),
      },
      //home: BoardScreen(),
    );
  }
}