import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitple/DB/LoginDB.dart';
import 'package:fitple/Diary/diary_user.dart';
import 'package:fitple/screens/admin_home.dart';
import 'package:fitple/screens/first.dart';
import 'package:fitple/screens/home_1.dart';

void main() {
  runApp(const TokenCheck());
}

// 자동 로그인 확인
// 토큰 있음 : 메인 페이지
// 토큰 없음 : 로그인 화면
class TokenCheck extends StatefulWidget {
  const TokenCheck({super.key});

  @override
  State<TokenCheck> createState() => _TokenCheckState();
}

class _TokenCheckState extends State<TokenCheck> {
  bool isToken = false;
  String? token;

  @override
  void initState() {
    super.initState();
    _autoLoginCheck();
  }

  void _autoLoginCheck() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    print('Token retrieved: $token'); // Debug print

    if (token != null) {
      setState(() {
        isToken = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: isToken ? Home1(userName: '', userEmail: '', Check: '') : Login(),
    );
  }
}

// 로그인 페이지
class LoginMainPage extends StatelessWidget {
  const LoginMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Login(),
    );
  }
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool switchValue = false;
  final TextEditingController emailCon = TextEditingController();
  final TextEditingController pwCon = TextEditingController();
  final TextEditingController nickCon = TextEditingController();

  // 자동 로그인 설정
  void _setAutoLogin(String token, String userEmail, String userpassword) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('userEmail', userEmail);
    await prefs.setString('userpassword', userpassword);
    print('토큰저장: $token , $userEmail , $userpassword'); // Debug print
  }

  // 자동 로그인 해제
  void _delAutoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    print('Token deleted'); // Debug print
  }

  @override
  void dispose() {
    emailCon.dispose();
    pwCon.dispose();
    nickCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 200),
                  child: Text(
                    'FITPLE',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 60,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 50),
                  width: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: TextField(
                    controller: emailCon,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10),
                      border: InputBorder.none,
                      hintText: '이메일',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  width: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: TextField(
                    controller: pwCon,
                    obscureText: true,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10),
                      border: InputBorder.none,
                      hintText: '비밀번호',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  width: 300,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '자동로그인',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Switch(
                        activeColor: Colors.blueAccent,
                        value: switchValue,
                        onChanged: (value) {
                          setState(() {
                            switchValue = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 0),
                Container(
                  margin: EdgeInsets.only(top: 15),
                  width: 200,
                  height: 40,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all(Colors.blueAccent),
                    ),
                    onPressed: () async {
                      final loginResult = await login(
                        emailCon.text,
                        pwCon.text,
                      );
                      print('Login result: $loginResult'); // Debug print
                      if (loginResult == null || loginResult['error'] == '-1') {
                        print('로그인 실패');
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('알림'),
                              content: Text('아이디 또는 비밀번호가 올바르지 않습니다'),
                              actions: [
                                TextButton(
                                  child: Text('닫기'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        if (loginResult['admin_check'] == '1') {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AdminHome()));
                        } else {
                          // Store the token if auto-login is enabled
                          if (switchValue == true && loginResult.isNotEmpty) {
                            String token = loginResult['token'] ?? ''; // Assuming 'token' is part of loginResult
                            String userEmail = emailCon.text;
                            String userPassword = pwCon.text;
                            if (token.isNotEmpty) {
                              _setAutoLogin(token, userEmail, userPassword);
                            }
                          } else {
                            _delAutoLogin();
                          }

                          // 로그인 성공 시 이메일 설정
                          diaryuser().setUserEmail(emailCon.text);
                          // 사용자 정보를 Navigator를 통해 전달
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Home1(
                                  userName: loginResult['user_nick'] ?? '',
                                  userEmail: loginResult['user_email'] ?? '',
                                  Check: loginResult['check'] ?? '', // null이면 빈 문자열 반환
                                ),
                              ));
                        }
                      }
                    },
                    child: Text(
                      '로그인',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 7),
                  width: 200,
                  height: 35,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => First()),
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blueAccent,
                    ),
                    child: Text(
                      '아직 회원이 아니신가요?',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
