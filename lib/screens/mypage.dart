import 'package:fitple/DB/LoginDB.dart';
import 'package:fitple/screens/login.dart';
import 'package:fitple/screens/myinfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(MyPage());
}

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  String user_email = "email"; // 실제 이메일로 대체하세요

  // 회원탈퇴 메서드
  Future<void> withdraw() async {
    bool success = await logout(user_email);
    if (success) {
      print('회원 탈퇴 성공');
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
    } else {
      print('회원 탈퇴 실패');
      // 탈퇴 실패 시 사용자에게 알림
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('알림'),
            content: Text('회원 탈퇴에 실패했습니다. 다시 시도해 주세요.'),
            actions: [
              TextButton(
                child: Text('확인'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 50,),
              Container(
                color: Colors.black12,
                height: 2.3,
                margin: EdgeInsets.only(bottom: 10),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MyInfo()));
                },
                child: Container(
                  height: 60,
                  margin: EdgeInsets.only(left: 35, right: 35),
                  //color: Colors.grey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('회원 정보 수정', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),),
                      Icon(Icons.chevron_right),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  height: 60,
                  margin: EdgeInsets.only(left: 35, right: 35),
                  //color: Colors.grey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('PT 예약내역', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),),
                      Icon(Icons.chevron_right),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  height: 60,
                  margin: EdgeInsets.only(left: 35, right: 35),
                  //color: Colors.grey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('My 리뷰', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),),
                      Icon(Icons.chevron_right),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('알림'),
                        content: Text('로그아웃하시겠습니까?'),
                        actions: [
                          TextButton(
                            child: Text('아니오'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                            },
                            child: Text('예'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Container(
                  alignment: Alignment.centerLeft,
                  height: 60,
                  margin: EdgeInsets.only(left: 35, right: 35),
                  //color: Colors.grey,
                  child: Text('로그아웃', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),),
                ),
              ),
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('알림'),
                        content: Text('회원 탈퇴를 하시겠습니까?'),
                        actions: [
                          TextButton(
                            child: Text('아니오'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              withdraw();
                            },
                            child: Text('예'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Container(
                  height: 60,
                  margin: EdgeInsets.only(left: 35, right: 35),
                  //color: Colors.grey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('회원탈퇴', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),),
                      Icon(Icons.chevron_right),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
