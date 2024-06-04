import 'package:flutter/material.dart';

class AdminApprove extends StatefulWidget {
  const AdminApprove({super.key});

  @override
  State<AdminApprove> createState() => _AdminApproveState();
}

class _AdminApproveState extends State<AdminApprove> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('승인 관리'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color(0x4CE0E0E0),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Color(0xFFE0E0E0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('회원 이메일', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
                      Text('회원 이름, 근무 헬스장'),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: (){ print('승인 버튼 입니다.');}, // 승인 기능 여기에
                  child: Container(
                    width: 50,
                    height: 30,
                    margin: EdgeInsets.only(right: 15),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text('승인',
                      style: TextStyle(color: Colors.white, fontSize : 15, fontWeight: FontWeight.w500),),
                  ),
                )
              ],
            ),
          ),
        )
    );
  }
}
