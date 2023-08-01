/*
로그인 page
 */

import 'package:flutter/material.dart';

import '../constants/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';
import"package:logger/logger.dart";

var logger=Logger();

class CustomButton extends StatelessWidget {
  final String buttonText;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onPressed;
  String companyLogoPath='';

  CustomButton({
    required this.buttonText,
    required this.backgroundColor,
    required this.textColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 222,
      height: 49,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: backgroundColor,
        ),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              companyLogoPath.trim().isEmpty ? SizedBox() : Image.asset(companyLogoPath, width: 30),
              SizedBox(width: 10),
              Text(
                buttonText,
                style: TextStyle(
                  color: textColor,
                  fontSize: 12,
                  fontFamily: 'Pretendard Variable',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AuthScreenYJ extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreenYJ> {
  @override
  void initState() {
    super.initState();
    checkAuthState();
  }

  void checkAuthState() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // User is already authenticated, navigate to the main screen
      logger.d("tab 페이지 이동");
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/tab', (route) => false, arguments: {"update": true});
      });
    }
  }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 로고 사진
                Container(
                  width: 316,
                  height: 79,
                  child: Image.asset('assets/images/logo.png'),
                ),
                Text('Upsight. CO., Ltd',
                  style: TextStyle(
                    color: D_GREY,
                    fontSize: 16,
                    fontFamily: 'Pretendard Variable',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 80),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomButton(
                        buttonText: '로그인',
                        backgroundColor: Colors.white,
                        textColor: Colors.grey,
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
      );
    }
  }


