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
                onTap: (){},
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
                onTap: (){},
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
              InkWell(
                onTap: (){
                  showCupertinoModalPopup<void>(
                    context: context,
                    builder: (BuildContext context) => CupertinoAlertDialog(
                      title: const Text('알림'),
                      content: const Text('로그아웃하시겠습니까?'),
                      actions: <CupertinoDialogAction>[
                        CupertinoDialogAction(
                          isDefaultAction: true,
                          onPressed: () => Navigator.pop(context),
                          child: const Text('아니오'),
                        ),
                        CupertinoDialogAction(
                          isDestructiveAction: true,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (builder) => Login(),
                              ),
                            );
                          },
                          child: Text('예'),
                        ),
                      ],
                    ),
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
                onTap: (){},
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
