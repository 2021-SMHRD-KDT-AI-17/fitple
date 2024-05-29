import 'package:flutter/material.dart';

void main() {
  runApp(const Login());
}

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
        ),
        home: Scaffold(
          body: ListView(
            children: const [
              SignIn(),
            ],
          ),
        ),
      ),
    );
  }
}

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        height: 812, // 화면 높이를 디바이스에 맞추기 위해 고정된 높이 사용
        decoration: const BoxDecoration(color: Colors.white),
        child: Stack(
          children: [

            const Positioned(
              left: 84,
              top: 119,
              child: Text(
                'FITPLE',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF285FEB),
                  fontSize: 66,
                  fontFamily: 'Kanit',
                  fontWeight: FontWeight.w900,
                  height: 1.2,
                  letterSpacing: -0.66,
                ),
              ),
            ),
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: 375,
                height: 44,
                decoration: const BoxDecoration(),
                child: Stack(
                  children: [
                    Positioned(
                      left: 293.67,
                      top: 17.33,
                      child: Container(
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
                                child: const SizedBox(),
                              ),
                            ),
                            Positioned(
                              left: 22.03,
                              top: 0,
                              child: Container(
                                width: 15.27,
                                height: 10.97,
                                decoration: const BoxDecoration(
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
                                decoration: const BoxDecoration(
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
                    ),
                    Positioned(
                      left: 21,
                      top: 12,
                      child: Container(
                        width: 54,
                        height: 21,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                        ),
                        child: const FlutterLogo(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 19,
              top: 326,
              child: Container(
                width: 335,
                height: 47,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: Color(0xFFE0E0E0)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '이메일 입력',
                    hintStyle: TextStyle(
                      color: Color(0xFF828282),
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 19,
              top: 384,
              child: Container(
                width: 335,
                height: 47,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: Color(0xFFE0E0E0)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '비밀번호 입력',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                  ),
                  obscureText: true,
                ),
              ),
            ),
            Positioned(
              left: 91,
              top: 464,
              child: Container(
                width: 193,
                height: 47,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: ShapeDecoration(
                  color: const Color(0xFF285FEB),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Center(
                  child: Text(
                    '로그인',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
