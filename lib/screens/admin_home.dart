import 'package:fitple/screens/admin_approve.dart';
import 'package:fitple/screens/admin_management.dart';
import 'package:fitple/screens/login.dart';
import 'package:flutter/material.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 15, top: 20),
          child: Text(
            'FITPLE',
            style: TextStyle(
              fontSize: 30,
              color: Colors.blueAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(left: 32, top: 30),
                alignment: Alignment.centerLeft,
                child: Text('관리자 페이지',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              ),
              SizedBox(height: 30,),
              InkWell(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdminManangement()));
                  },
                child: Container(
                  height: 60,
                  margin: EdgeInsets.only(left: 35, right: 35),
                  //color: Colors.grey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('회원 관리', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),),
                      Icon(Icons.chevron_right)
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdminApprove()));
                  },
                child: Container(
                  height: 60,
                  margin: EdgeInsets.only(left: 35, right: 35),
                  //color: Colors.grey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('트레이너 승인', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),),
                      Icon(Icons.chevron_right)
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

            ],
          ),
        ),
      ),
    );
  }
}
