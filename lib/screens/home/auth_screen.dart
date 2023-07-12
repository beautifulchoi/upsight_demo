/*
로그인 page
 */

import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
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
              child: Image.asset('images/logo.png'),
            ),
            Text('Upsight. CO., Ltd',
              style: TextStyle(
                color: Color(0xFF75777C),
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
                  SizedBox(
                    width: 222,
                    height: 49,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          primary: Colors.white,
                        ),
                        onPressed: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            children: [
                              Image.asset('images/google.png', width: 30),
                              SizedBox(width: 10),
                              Text(
                                'Google로 계속하기',
                                style: TextStyle(
                                  color: Color(0xFF75777C),
                                  fontSize: 12,
                                  fontFamily: 'Pretendard Variable',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        )),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: 222,
                    height: 49,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            primary: Colors.white,
                          ),
                          onPressed: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              children: [
                                Image.asset('images/apple.png',
                                    width: 30),
                                SizedBox(width: 10),
                                Text(
                                  'Apple로 계속하기',
                                  style: TextStyle(
                                    color: Color(0xFF75777C),
                                    fontSize: 12,
                                    fontFamily: 'Pretendard Variable',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          )),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: 222,
                    height: 49,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            primary: Color(0xFFFFDC4C),
                          ),
                          onPressed: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              children: [
                                Image.asset('images/kakao.png', width: 30),
                                SizedBox(width: 10),
                                Text(
                                  '카카오로 계속하기',
                                  style: TextStyle(
                                    color: Color(0xFF75777C),
                                    fontSize: 12,
                                    fontFamily: 'Pretendard Variable',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          )),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: 222,
                    height: 49,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            primary: Color(0xFF1EC800),
                          ),
                          onPressed: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              children: [
                                Image.asset('images/naver.png', width: 30),
                                SizedBox(width: 10),
                                Text(
                                  '네이버로 계속하기',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontFamily: 'Pretendard Variable',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ))
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