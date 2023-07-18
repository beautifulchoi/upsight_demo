/*
내 활동 홈 화면
 */

import 'package:flutter/material.dart';

class MyActivityScreen extends StatefulWidget {
  @override
  _MyActivityScreenState createState() => _MyActivityScreenState();
}

class _MyActivityScreenState extends State<MyActivityScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16,),
        Container(
          width: 322,
          height: 81.19,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            shadows: [
              BoxShadow(
                color: Color(0x19000000),
                blurRadius: 4,
                offset: Offset(0, 0),
                spreadRadius: 2,
              )
            ]
          ),
          child: Row(
            children: [
              SizedBox(width: 15,),
              Expanded(
                  child: Align(
                    child: Row(
                      children: [
                        Image.asset('images/profile.png', width: 48.67),
                        SizedBox(width: 13),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('사용자 01 - 임차인',
                              style: TextStyle(
                                color: Color(0xFF0F4C82),
                                fontSize: 20,
                                fontFamily: 'Pretendard Variable',
                                fontWeight: FontWeight.w600,),),
                            Row(
                              children: [
                                Icon(Icons.autorenew, color: Color(0xFFBED0E0),),
                                SizedBox(width: 5),
                                Text('임대인으로 전환',
                                  style: TextStyle(
                                    color: Color(0xFFBED0E0),
                                    fontSize: 14,
                                    fontFamily: 'Pretendard Variable',
                                    fontWeight: FontWeight.w400,
                                  ),),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ))
            ],
          ),
        ),
        SizedBox(height: 25,),
        Container(
          width: 322,
          height: 97.83,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            shadows: [
              BoxShadow(
                color: Color(0x19000000),
                blurRadius: 4,
                offset: Offset(0, 0),
                spreadRadius: 2,
              )
            ],
          ),
          child: Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {

                      },
                      child: Container(
                        width: 55.39,
                        height: 55.39,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: OvalBorder(),
                          shadows: [
                            BoxShadow(
                              color: Color(0x19000000),
                              blurRadius: 4,
                              offset: Offset(0, 0),
                              spreadRadius: 2,
                            )
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned(
                                child: Icon(
                                  Icons.pending_actions,
                                  color: Color(0xFF585858),
                                ))
                          ],
                        ),
                      ),
                    ),
                    Text('내 계약',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: 'Pretendard Variable',
                        fontWeight: FontWeight.w400,
                      ),),
                  ],
                ),
                SizedBox(width: 20,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {

                      },
                      child: Container(
                        width: 55.39,
                        height: 55.39,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: OvalBorder(),
                          shadows: [
                            BoxShadow(
                              color: Color(0x19000000),
                              blurRadius: 4,
                              offset: Offset(0, 0),
                              spreadRadius: 2,
                            )
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned(
                                child: Icon(
                                  Icons.edit,
                                  color: Color(0xFF585858),
                                ))
                          ],
                        ),
                      ),
                    ),
                    Text('내 게시글',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: 'Pretendard Variable',
                        fontWeight: FontWeight.w400,
                      ),),
                  ],
                ),
                SizedBox(width: 20,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {

                      },
                      child: Container(
                        width: 55.39,
                        height: 55.39,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: OvalBorder(),
                          shadows: [
                            BoxShadow(
                              color: Color(0x19000000),
                              blurRadius: 4,
                              offset: Offset(0, 0),
                              spreadRadius: 2,
                            )
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned(
                                child: Icon(
                                  Icons.messenger_outline,
                                  color: Color(0xFF585858),
                                ))
                          ],
                        ),
                      ),
                    ),
                    Text('내 댓글',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: 'Pretendard Variable',
                        fontWeight: FontWeight.w400,
                      ),),
                  ],
                ),
                SizedBox(width: 20,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {

                      },
                      child: Container(
                        width: 55.39,
                        height: 55.39,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: OvalBorder(),
                          shadows: [
                            BoxShadow(
                              color: Color(0x19000000),
                              blurRadius: 4,
                              offset: Offset(0, 0),
                              spreadRadius: 2,
                            )
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned(
                                child: Icon(
                                  Icons.favorite_border,
                                  color: Color(0xFF585858),
                                ))
                          ],
                        ),
                      ),
                    ),
                    Text('내 좋아요',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: 'Pretendard Variable',
                        fontWeight: FontWeight.w400,
                      ),),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 25,),
        Container(
          width: 322,
          height: 253.17,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            shadows: [
              BoxShadow(
                color: Color(0x19000000),
                blurRadius: 4,
                offset: Offset(0, 0),
                spreadRadius: 2,
              )
            ],
          ),
          child: Align(
            alignment: Alignment.center,
            child: ListView(
              children: [
                ListTile(
                  title: Text(
                    '사용자 정보',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Pretendard Variable',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  onTap: () {

                  },
                ),
                Divider(thickness: 1,),
                ListTile(
                  title: Text(
                    '설정',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Pretendard Variable',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  onTap: () {

                  },
                ),
                Divider(thickness: 1,),
                ListTile(
                  title: Text(
                    '공지사항',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Pretendard Variable',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  onTap: () {

                  },
                ),
                Divider(thickness: 1,),
                ListTile(
                  title: Text(
                    '서비스 정보',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Pretendard Variable',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  onTap: () {

                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}