import 'package:fitple/DB/LoginDB.dart';
import 'package:fitple/screens/first.dart';
import 'package:fitple/screens/home_1.dart';
import 'package:fitple/screens/join.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/cupertino.dart';

void main() {
  runApp(const Login());
}

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {

    bool switchValue = false;

    final TextEditingController emailCon = TextEditingController();
    final TextEditingController pwCon = TextEditingController();

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          foregroundColor: Colors.white,
          backgroundColor: Colors.white,
          leading: IconButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => First() ));},
            icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.black,),),
        ),
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 150),
                  //color: Colors.grey,
                  child: Text('FITPLE', textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 60,
                    ),),
                ),
                Container(
                    margin: EdgeInsets.only(top:50),
                    width: 300,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey)
                      //borderRadius: BorderRadius.all(10),
                    ),
                    child: TextField(
                      controller: emailCon,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 10),
                          border: InputBorder.none,
                          hintText: '이메일',
                          hintStyle: TextStyle(color: Colors.grey[500])
                      ),
                    )
                ),
                Container(
                    margin: EdgeInsets.only(top:10),
                    width: 300,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey)
                      //borderRadius: BorderRadius.all(10),
                    ),
                    child: TextField(
                      controller: pwCon,
                      obscureText: true,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 10),
                          border: InputBorder.none,
                          hintText: '비밀번호',
                          hintStyle: TextStyle(color: Colors.grey[500])
                      ),
                    )
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
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Switch(
                        value: switchValue,
                        onChanged: (value) {
                          // setState(() {
                          //   switchValue = value;
                          // });
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
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blueAccent)),
                    onPressed: () async{
                      final loginCheck = await login(
                          emailCon.text, pwCon.text
                      );
                      print(loginCheck);
                      if(loginCheck == '-1'){
                        print('로그인 실패');
                        showDialog(context: context, builder: (BuildContext context){
                          return AlertDialog(
                            title: Text('알림'),
                            content: Text('아이디 또는 비밀번호가 올바르지 않습니다'),
                            actions: [
                              TextButton(
                                child: Text('닫기'),
                                onPressed: (){
                                  Navigator.of(context).pop();
                                },),
                            ],
                          );
                        });
                      }else
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Home1() ));},//Navigator.push(context, MaterialPageRoute(builder: (context) => ,)),
                    child: Text('로그인',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold ),),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 7),
                  width: 200,
                  height: 35,
                  child: TextButton(
                      onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => Join() ));},
                      style: TextButton.styleFrom(foregroundColor: Colors.blueAccent),
                      child: Text('아직 회원이 아니신가요?', style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),)
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}