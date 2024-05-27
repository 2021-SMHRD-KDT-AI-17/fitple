import 'package:fitple/screens/join.dart';
import 'package:fitple/screens/login.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const First());
}

class First extends StatelessWidget {
  const First({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
      ),
      home: Scaffold(
        body: ListView(
          children: [
            SignIn(),
          ],
        ),
      ),
    );
  }
}

class SignIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 375,
          height: 812,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(color: Color(0xFF285FEB)),
          child: Stack(
            children: [
              Positioned(
                left: 77,
                top: 143,
                child: SizedBox(
                  width: 223,
                  height: 107,
                  child: Text(
                    'FITPLE',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 66,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.w900,
                      height: 0.9,
                      letterSpacing: -0.66,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 17,
                top: 468,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Join()),
                    );
                  },
                  child: Container(
                    width: 343,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      shadows: [
                        BoxShadow(
                          color: Color(0x0C000000),
                          blurRadius: 2,
                          offset: Offset(0, 1),
                          spreadRadius: 0,
                        )
                      ],
                    ),
                    child: Text(
                      '회원가입',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF285FEB),
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w800,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 17,
                top: 406,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  },
                  child: Container(
                    width: 343,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      shadows: [
                        BoxShadow(
                          color: Color(0x0C000000),
                          blurRadius: 2,
                          offset: Offset(0, 1),
                          spreadRadius: 0,
                        )
                      ],
                    ),
                    child: Text(
                      '로그인',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF285FEB),
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w800,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 778,
                child: Container(
                  width: 375,
                  height: 34,
                  padding: const EdgeInsets.only(
                    top: 21,
                    left: 121,
                    right: 120,
                    bottom: 8,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 134,
                        height: 5,
                        decoration: ShapeDecoration(
                          color: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
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
      ],
    );
  }
}