import 'package:flutter/material.dart';

void main() {
  runApp(const Diary3());
}

// Generated by: https://www.figma.com/community/plugin/842128343887142055/
class Diary3 extends StatelessWidget {
  const Diary3({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
      ),
      home: Scaffold(
        body: ListView(children: [
          Diary(),
        ]),
      ),
    );
  }
}

class Diary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 375,
          height: 812,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(color: Colors.white),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.only(
                    top: 12,
                    left: 21,
                    right: 14.67,
                    bottom: 11,
                  ),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(color: Colors.white),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          height: double.infinity,
                          padding: const EdgeInsets.only(
                            top: 5.17,
                            left: 12.45,
                            right: 13.12,
                            bottom: 4.74,
                          ),
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [

                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 218.67),
                      Container(
                        width: 66.66,
                        height: 11.34,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 42.33,
                              top: 0,
                              child: Container(
                                width: 24.33,
                                height: 11.33,
                                child: Stack(),
                              ),
                            ),
                            Positioned(
                              left: 22.03,
                              top: 0,
                              child: Container(
                                width: 15.27,
                                height: 10.97,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage("https://via.placeholder.com/15x11"),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 0,
                              top: 0.34,
                              child: Container(
                                width: 17,
                                height: 10.67,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage("https://via.placeholder.com/17x11"),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 52,
                child: Container(
                  width: 375,
                  padding: const EdgeInsets.symmetric(vertical: 9),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      left: BorderSide(color: Color(0xFFE6E6E6)),
                      top: BorderSide(color: Color(0xFFE6E6E6)),
                      right: BorderSide(color: Color(0xFFE6E6E6)),
                      bottom: BorderSide(width: 0.50, color: Color(0xFFE6E6E6)),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '운동 기록',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          height: 0.08,
                          letterSpacing: -0.34,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 52,
                child: Container(
                  width: 375,
                  height: 42,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      left: BorderSide(color: Color(0xFFE6E6E6)),
                      top: BorderSide(color: Color(0xFFE6E6E6)),
                      right: BorderSide(color: Color(0xFFE6E6E6)),
                      bottom: BorderSide(width: 0.50, color: Color(0xFFE6E6E6)),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 155,
                        top: 9,
                        child: Text(
                          '일정 등록',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            height: 0.08,
                            letterSpacing: -0.34,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 17,
                        top: 9,
                        child: Container(
                          width: 24,
                          height: 24,
                          padding: const EdgeInsets.only(
                            top: 3.57,
                            left: 6.94,
                            right: 7.57,
                            bottom: 3.57,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [

                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 328,
                        top: 12,
                        child: SizedBox(
                          width: 65,
                          child: Text(
                            '완료',
                            style: TextStyle(
                              color: Color(0xFF285FEB),
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              height: 0.10,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.only(
                    top: 12,
                    left: 21,
                    right: 14.67,
                    bottom: 11,
                  ),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(color: Colors.white),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          height: double.infinity,
                          padding: const EdgeInsets.only(
                            top: 5.17,
                            left: 12.45,
                            right: 13.12,
                            bottom: 4.74,
                          ),
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [

                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 218.67),
                      Container(
                        width: 66.66,
                        height: 11.34,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 42.33,
                              top: 0,
                              child: Container(
                                width: 24.33,
                                height: 11.33,
                                child: Stack(),
                              ),
                            ),
                            Positioned(
                              left: 22.03,
                              top: 0,
                              child: Container(
                                width: 15.27,
                                height: 10.97,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage("https://via.placeholder.com/15x11"),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 0,
                              top: 0.34,
                              child: Container(
                                width: 17,
                                height: 10.67,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage("https://via.placeholder.com/17x11"),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 25,
                top: 158,
                child: Container(
                  width: 327,
                  height: 43,
                  decoration: ShapeDecoration(
                    color: Color(0xFFF5F5F5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 25,
                top: 218,
                child: Container(
                  width: 327,
                  height: 85,
                  decoration: ShapeDecoration(
                    color: Color(0xFFF5F5F5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 41,
                top: 260,
                child: Container(
                  width: 294.01,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 2,
                        strokeAlign: BorderSide.strokeAlignCenter,
                        color: Color(0xFFE8E8E8),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 44,
                top: 170,
                child: Text(
                  '제목',
                  style: TextStyle(
                    color: Color(0xFFA7A7A7),
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 0.10,
                    letterSpacing: -0.28,
                  ),
                ),
              ),
              Positioned(
                left: 25,
                top: 320,
                child: Container(
                  width: 327,
                  height: 43,
                  decoration: ShapeDecoration(
                    color: Color(0xFFF5F5F5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 42,
                top: 332,
                child: Text(
                  '메모',
                  style: TextStyle(
                    color: Color(0xFFA7A7A7),
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 0.10,
                    letterSpacing: -0.28,
                  ),
                ),
              ),
              Positioned(
                left: 43,
                top: 230,
                child: Container(
                  width: 288,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 1,
                        child: Text(
                          '시작',
                          style: TextStyle(
                            color: Color(0xFFA7A7A7),
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            height: 0.10,
                            letterSpacing: -0.28,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 153,
                        top: 0,
                        child: Container(
                          width: 135,
                          height: 22,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 5,
                                top: 3,
                                child: Text(
                                  '2024. 6. 20',
                                  style: TextStyle(
                                    color: Color(0xFFA7A7A7),
                                    fontSize: 12,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                    height: 0.12,
                                    letterSpacing: -0.24,
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 95,
                                top: 3,
                                child: Text(
                                  '20:00',
                                  style: TextStyle(
                                    color: Color(0xFFA7A7A7),
                                    fontSize: 12,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                    height: 0.12,
                                    letterSpacing: -0.24,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 43,
                top: 231,
                child: Text(
                  '시작',
                  style: TextStyle(
                    color: Color(0xFFA7A7A7),
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 0.10,
                    letterSpacing: -0.28,
                  ),
                ),
              ),
              Positioned(
                left: 201,
                top: 233,
                child: Text(
                  '2024. 6. 20',
                  style: TextStyle(
                    color: Color(0xFFA7A7A7),
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 0.12,
                    letterSpacing: -0.24,
                  ),
                ),
              ),
              Positioned(
                left: 291,
                top: 233,
                child: Text(
                  '20:00',
                  style: TextStyle(
                    color: Color(0xFFA7A7A7),
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 0.12,
                    letterSpacing: -0.24,
                  ),
                ),
              ),
              Positioned(
                left: 43,
                top: 269,
                child: Text(
                  '종료',
                  style: TextStyle(
                    color: Color(0xFFA7A7A7),
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 0.10,
                    letterSpacing: -0.28,
                  ),
                ),
              ),
              Positioned(
                left: 201,
                top: 271,
                child: Text(
                  '2024. 6. 20',
                  style: TextStyle(
                    color: Color(0xFFA7A7A7),
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 0.12,
                    letterSpacing: -0.24,
                  ),
                ),
              ),
              Positioned(
                left: 291,
                top: 271,
                child: Text(
                  '20:00',
                  style: TextStyle(
                    color: Color(0xFFA7A7A7),
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 0.12,
                    letterSpacing: -0.24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}