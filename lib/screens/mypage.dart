//import 'package:fitple/DB/LoginDB.dart';
//import 'package:fitple/screens/info_1.dart';
import 'package:fitple/screens/login.dart';
import 'package:fitple/screens/myinfo.dart';
import 'package:fitple/screens/myreser.dart';
import 'package:fitple/screens/review_my.dart';
import 'package:fitple/screens/trainer_gym.dart';
import 'package:fitple/screens/trainer_reservation.dart';
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
                onTap: (){ Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyInfo()));},
                child: Container(
                  height: 60,
                  margin: EdgeInsets.only(left: 35, right: 35),
                  //color: Colors.grey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('회원 정보 수정', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),),
                      Icon(Icons.chevron_right)
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: (){Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyReser()));},
                child: Container(
                  height: 60,
                  margin: EdgeInsets.only(left: 35, right: 35),
                  //color: Colors.grey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('PT 예약내역', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),),
                      Icon(Icons.chevron_right)
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: (){Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ReviewMyPage()));},
                child: Container(
                  height: 60,
                  margin: EdgeInsets.only(left: 35, right: 35),
                  //color: Colors.grey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('My 리뷰', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),),
                      Icon(Icons.chevron_right)
                    ],
                  ),
                ),
              ),



              // 트레이너 전용 -- 시작
              // 헬스장 관리 -- 대표만 설정
              InkWell(
                onTap: (){ Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TrainerGym()));},
                child: Container(
                  height: 60,
                  margin: EdgeInsets.only(left: 35, right: 35),
                  //color: Colors.grey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('헬스장 관리', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),),
                      Icon(Icons.chevron_right)
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: (){ Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyInfo()));},
                child: Container(
                  height: 60,
                  margin: EdgeInsets.only(left: 35, right: 35),
                  //color: Colors.grey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('회원 정보 수정', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),),
                      Icon(Icons.chevron_right)
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: (){Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TrainReservation()));},
                child: Container(
                  height: 60,
                  margin: EdgeInsets.only(left: 35, right: 35),
                  //color: Colors.grey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('회원 예약 관리', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),),
                      Icon(Icons.chevron_right)
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: (){Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ReviewMyPage()));},
                child: Container(
                  height: 60,
                  margin: EdgeInsets.only(left: 35, right: 35),
                  //color: Colors.grey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('회원 일정 관리', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),),
                      Icon(Icons.chevron_right)
                    ],
                  ),
                ),
              ),

              // 트레이너 전용 -- 끝



              
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
                          )
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
                onTap: (){
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
                  height: 60,
                  margin: EdgeInsets.only(left: 35, right: 35),
                  //color: Colors.grey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('회원탈퇴', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),),
                      Icon(Icons.chevron_right)
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