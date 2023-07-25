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
        SizedBox(height: 25,),
        Container(
          width: 358,
          height: 205.75,
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
          child: Column(
            children: [
              Expanded(
                  child: Align(
                    child: Row(
                      children: [
                        SizedBox(width: 25,),
                        Image.asset('assets/images/profile.png', width: 48.67),
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
                                Icon(Icons.cached, color: Color(0xFF7DC2E0),),
                                SizedBox(width: 5),
                                Text('프로필 전환',
                                  style: TextStyle(
                                    color: Color(0xFF7DC2E0),
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
                  )
              ),
              Divider(thickness: 1,),
              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 15),
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
              )
            ],
          )
        ),
        SizedBox(height: 25,),
        Container(
          width: 384,
          height: 274.25,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
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
                  title: Row(
                    children: [
                      Icon(Icons.account_circle_outlined),
                      SizedBox(width: 10,),
                      Text(
                        '사용자 정보',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Pretendard Variable',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {

                  },
                ),
                Divider(thickness: 1,),
                ListTile(
                  title: Row(
                    children: [
                      Icon(Icons.settings_outlined),
                      SizedBox(width: 10,),
                      Text(
                        '설정',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Pretendard Variable',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {

                  },
                ),
                Divider(thickness: 1,),
                ListTile(
                  title: Row(
                    children: [
                      Icon(Icons.error_outline),
                      SizedBox(width: 10,),
                      Text(
                        '공지사항',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Pretendard Variable',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {

                  },
                ),
                Divider(thickness: 1,),
                ListTile(
                  title: Row(
                    children: [
                      Icon(Icons.info_outline),
                      SizedBox(width: 10,),
                      Text(
                        '서비스 정보',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Pretendard Variable',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
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