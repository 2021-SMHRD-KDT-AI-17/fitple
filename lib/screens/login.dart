import 'package:fitple/screens/first.dart';
import 'package:fitple/screens/home_1.dart';
import 'package:fitple/screens/join.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Login());
}

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
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
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 10),
                          border: InputBorder.none,
                          hintText: '비밀번호',
                          hintStyle: TextStyle(color: Colors.grey[500])
                      ),
                    )
                ),
                Container(
                  margin: EdgeInsets.only(top: 30),
                  width: 200,
                  height: 40,
                  child: ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blueAccent)),
                    onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => Home1() ));},//Navigator.push(context, MaterialPageRoute(builder: (context) => ,)),
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