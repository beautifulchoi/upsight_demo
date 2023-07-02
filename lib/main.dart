import 'package:board_project/screens/create_screen.dart';
import 'package:board_project/screens/detail_screen.dart';
import 'package:board_project/screens/infinite_scroll_page.dart';
import 'package:flutter/material.dart';
import 'package:board_project/screens/board_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:get/get.dart';
import 'package:board_project/screens/search_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      //initialRoute: '/',
      initialRoute: '/test',
      routes: {
        //'/': (context) => BoardScreen(),
        '/create': (context) => CreateScreen(),
        '/test': (context) => InfiniteScrollPage(),
        //'/search': (context) => SearchScreen(),
      },
      //home: BoardScreen(),
    );
  }
}