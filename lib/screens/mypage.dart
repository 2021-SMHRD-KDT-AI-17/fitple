import 'package:fitple/DB/LoginDB.dart';
import 'package:fitple/DB/trainerDB.dart';
import 'package:fitple/screens/gym_info.dart';
import 'package:fitple/screens/login.dart';
import 'package:fitple/screens/myinfo.dart';
import 'package:fitple/screens/myinfo_trainer.dart';
import 'package:fitple/screens/myreser.dart';
import 'package:fitple/screens/review_my.dart';
import 'package:fitple/screens/trainer_calender1.dart';
import 'package:fitple/screens/trainer_gym.dart';
import 'package:fitple/screens/trainer_reservation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white, // Set scaffold background to white
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white, // Set AppBar background to white
          elevation: 0.0, // Remove AppBar elevation
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),
      home: MyPage(userEmail: '', Check: '', userName: ''),
    );
  }
}

class MyPage extends StatefulWidget {
  final String userEmail;
  final String Check;
  final String userName;
  const MyPage({super.key, required this.userEmail, required this.Check, required this.userName});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  bool isLoggedIn = false;
  String? oneTopCheck;

  @override
  void initState() {
    super.initState();
    isLoggedIn = widget.userEmail.isNotEmpty;

    oneTop(widget.userEmail).then((userResult) {
      if (userResult != null) {
        setState(() {
          oneTopCheck = userResult['oneTopCheck'] ?? '';
        });
      }
    });
  }
  void _delAutoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    print('Token deleted'); // Debug print
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Ensure Scaffold background is white
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // 로그인 안했을때
              if (!isLoggedIn) ...[
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  },
                  child: Container(
                    height: 60,
                    margin: EdgeInsets.only(left: 35, top: 15, right: 35),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '로그인이 필요한 기능입니다.',
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'FITPLE 로그인 및 회원가입',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Icon(Icons.chevron_right),
                      ],
                    ),
                  ),
                ),
                Container(
                  color: Colors.black12,
                  height: 2.3,
                ),
              ],

              // 로그인 했을때
              if (isLoggedIn) ...[
                Container(
                  alignment: Alignment.centerLeft,
                  height: 60,
                  margin: EdgeInsets.only(left: 35, top: 15, right: 35),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.userName}님 안녕하세요!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.userEmail,
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Colors.black12,
                  height: 2.3,
                  margin: EdgeInsets.only(bottom: 10),
                ),
                if (widget.Check == "1") ...[
                  if (oneTopCheck == "1") ...[
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TrainerGym(
                              gymName: '',
                              address: '',
                              onAddressUpdated: (value) => '',
                              trainerEmail: widget.userEmail,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 60,
                        margin: EdgeInsets.only(left: 35, right: 35),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '헬스장 등록',
                              style:
                              TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                            Icon(Icons.chevron_right),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GymInfo(
                              gymName: '',
                              address: '',
                              onAddressUpdated: (value) => '',
                              trainerEmail: widget.userEmail,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 60,
                        margin: EdgeInsets.only(left: 35, right: 35),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '헬스장 정보 수정',
                              style:
                              TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                            Icon(Icons.chevron_right),
                          ],
                        ),
                      ),
                    ),
                  ],
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyInfoTrainer(userEmail: widget.userEmail,)),
                      );
                    },
                    child: Container(
                      height: 60,
                      margin: EdgeInsets.only(left: 35, right: 35),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '회원 정보 수정',
                            style:
                            TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                          Icon(Icons.chevron_right),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TrainReservation(trainer_email: widget.userEmail),
                        ),
                      );
                    },
                    child: Container(
                      height: 60,
                      margin: EdgeInsets.only(left: 35, right: 35),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '회원 예약 관리',
                            style:
                            TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                          Icon(Icons.chevron_right),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TrainerCalendar(trainer_email: widget.userEmail)),
                      );
                    },
                    child: Container(
                      height: 60,
                      margin: EdgeInsets.only(left: 35, right: 35),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '회원 일정 관리',
                            style:
                            TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                          Icon(Icons.chevron_right),
                        ],
                      ),
                    ),
                  ),
                ] else ...[
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyInfo(userEmail: widget.userEmail)),
                      );
                    },
                    child: Container(
                      height: 60,
                      margin: EdgeInsets.only(left: 35, right: 35),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '회원 정보 수정',
                            style:
                            TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                          Icon(Icons.chevron_right),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyReser(userEmail: widget.userEmail)),
                      );
                    },
                    child: Container(
                      height: 60,
                      margin: EdgeInsets.only(left: 35, right: 35),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'PT 예약내역',
                            style:
                            TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                          Icon(Icons.chevron_right),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReviewMyPage(
                            userEmail: widget.userEmail,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 60,
                      margin: EdgeInsets.only(left: 35, right: 35),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'My 리뷰',
                            style:
                            TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                          Icon(Icons.chevron_right),
                        ],
                      ),
                    ),
                  ),
                ],
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
                                _delAutoLogin();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => Login()),
                                );
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
                    child: Text(
                      '로그아웃',
                      style:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
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
                                logout(widget.userEmail);
                                Navigator.of(context).pop();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => Login()),
                                );
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '회원탈퇴',
                          style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                        Icon(Icons.chevron_right),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
