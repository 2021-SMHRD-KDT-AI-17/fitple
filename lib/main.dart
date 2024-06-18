import 'package:fitple/DB/LoginDB.dart';
import 'package:fitple/screens/admin_home.dart';
import 'package:fitple/screens/admin_management.dart';
import 'package:fitple/screens/chat_ai.dart';
import 'package:fitple/screens/chat_tr.dart';
import 'package:fitple/screens/diary.dart';
import 'package:fitple/screens/first.dart';
import 'package:fitple/screens/home_1.dart';
import 'package:fitple/screens/info_1.dart';
import 'package:fitple/screens/join.dart';
import 'package:fitple/screens/join_trainer.dart';
import 'package:fitple/screens/loading.dart';
import 'package:fitple/screens/login.dart';
import 'package:fitple/screens/myreser.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const TokenCheck());
}

// 자동 로그인 확인
// 토큰 있음 : 메인 페이지
// 토큰 없음 : 로딩 화면
class TokenCheck extends StatefulWidget {
  const TokenCheck({super.key});

  @override
  State<TokenCheck> createState() => _TokenCheckState();
}

class _TokenCheckState extends State<TokenCheck> {
  bool isToken = false;
  String? token;
  String? userEmail;
  String? userPassword;
  String userName = '';
  String check = '';

  @override
  void initState() {
    super.initState();
    _autoLoginCheck();
  }

  void _autoLoginCheck() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    userEmail = prefs.getString('userEmail');
    userPassword = prefs.getString('userPassword');
    print('Token 존재: $token'); // Debug print

    if (token != null && userEmail != null && userPassword != null) {
      final loginResult = await login(userEmail!, userPassword!);
      print('Login result: $loginResult');

      setState(() {
        if (loginResult != null) {
          userName = loginResult['user_nick'] ?? '';
          check = loginResult['check'] ?? '';
          isToken = true;
        } else {
          isToken = false;
        }
      });
    } else {
      setState(() {
        isToken = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: isToken ? Home1(userName: userName, userEmail: userEmail!, Check: check,) : Loading(),
    );
  }
}
