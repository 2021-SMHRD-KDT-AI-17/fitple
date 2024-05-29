import 'package:fitple/screens/review_my.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: MyPage(),
      ),
    );
  }
}

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 배경색을 흰색으로 설정합니다.
      body: Stack(
        children: [
          Positioned(
            left: -56,
            top: 22,
            child: SizedBox(
              width: 241,
              height: 116,
              child: Text(
                'FITPLE',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF285FEB),
                  fontSize: 25,
                  fontFamily: 'Kanit',
                  fontWeight: FontWeight.w900,
                  height: 1,
                  letterSpacing: -0.25,
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 140,
            child: Name(),
          ),
          Positioned(
            left: 0,
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 78,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x19000000),
                    blurRadius: 0,
                    offset: Offset(0, -0.50),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 26.0, vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.home),
                        SizedBox(height: 4),
                        Text(
                          'Home',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.2),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            height: 1,
                            letterSpacing: -0.24,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat),
                        SizedBox(height: 4),
                        Text(
                          '채팅',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.3),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            height: 1,
                            letterSpacing: -0.24,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.access_alarm),
                        SizedBox(height: 4),
                        Text(
                          '운동 기록',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.3),
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            height: 1,
                            letterSpacing: -0.24,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.account_circle),
                        SizedBox(height: 3),
                        Text(
                          '마이페이지',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF285FEB),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            height: 1,
                            letterSpacing: -0.24,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Name extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            // 여기에 '회원 정보 수정'이 탭되었을 때 실행할 동작 추가
          },
          child: Container(
            width: 375,
            height: 49,
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 14),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 100,
                  child: Text(
                    '회원 정보 수정',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 20,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Opacity(
                          opacity: 0.50,
                          child: Container(
                            width: 20,
                            height: 20,
                            padding: const EdgeInsets.only(
                                top: 4.96, left: 14, bottom: 4.90),
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [],
                            ),
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_right_outlined),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            // 여기에 'PT 예약 내역'이 탭되었을 때 실행할 동작 추가
          },
          child: Container(
            width: 375,
            height: 49,
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 14),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 100,
                  child: Text(
                    'PT 예약 내역',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 20,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Opacity(
                          opacity: 0.50,
                          child: Container(
                            width: 20,
                            height: 20,
                            padding: const EdgeInsets.only(
                                top: 4.96, left: 14, bottom: 4.90),
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [],
                            ),
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_right_outlined),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>Review_my()),
            );
          },
          child: Container(
            width: 375,
            height: 49,
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 14),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 100,
                  child: Text(
                    'My 리뷰',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: double.infinity,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Opacity(
                          opacity: 0.50,
                          child: Container(
                            width: 20,
                            height: 20,
                            padding: const EdgeInsets.only(
                                top: 4.96, left: 14, bottom: 4.90),
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [],
                            ),
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_right_outlined),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            // 여기에 '회원탈퇴'가 탭되었을 때 실행할 동작 추가
          },
          child: Container(
            width: 375,
            height: 49,
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 14),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 100,
                  child: Text(
                    '회원탈퇴',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
                  ),
                ),
                Icon(Icons.keyboard_arrow_right_outlined),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            // 여기에 '로그아웃'이 탭되었을 때 실행할 동작 추가
          },
          child: Container(
            width: 375,
            height: 49,
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 14),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 100,
                  child: Text(
                    '로그아웃',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
                  ),
                ),
                Icon(Icons.keyboard_arrow_right_outlined),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
