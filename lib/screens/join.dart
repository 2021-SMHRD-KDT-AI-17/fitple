import 'package:fitple/screens/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const Join());
}

class Join extends StatelessWidget {
  const Join({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.white,
        leading: IconButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => Login() ));},
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
                margin: EdgeInsets.only(top: 30),
                child: Text('FITPLE', textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 60,
                  ),),
              ),
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top:40),
                    width: 300,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey)
                      //borderRadius: BorderRadius.all(10),
                    ),
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        icon: Padding(padding: EdgeInsets.only(left: 10),
                            child: Icon(Icons.email_outlined,  )),
                        label: Text('이메일', style: TextStyle(color: Colors.grey[600]),),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 0.1),
                      ),
                    ),
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
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        icon: Padding(padding: EdgeInsets.only(left: 10),
                            child: Icon(Icons.vpn_key_outlined,  )),
                        label: Text('비밀번호', style: TextStyle(color: Colors.grey[600]),),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 0.1),
                      ),
                    ),
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
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        icon: Padding(padding: EdgeInsets.only(left: 10),
                            child: Icon(Icons.vpn_key_outlined,  )),
                        label: Text('비밀번호 확인', style: TextStyle(color: Colors.grey[600]),),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 0.1),
                      ),
                    ),
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
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        icon: Padding(padding: EdgeInsets.only(left: 10),
                            child: Icon(Icons.person_outlined,  )),//accessibility
                        label: Text('이름', style: TextStyle(color: Colors.grey[600]),),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 0.1),
                      ),
                    ),
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
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        icon: Padding(padding: EdgeInsets.only(left: 10),
                            child: Icon(Icons.face,  )),
                        label: Text('닉네임', style: TextStyle(color: Colors.grey[600]),),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 0.1),
                      ),
                    ),
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
                      style: TextStyle(color: Colors.black),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(2),],
                      decoration: InputDecoration(
                        icon: Padding(padding: EdgeInsets.only(left: 10),
                            child: Icon(Icons.cake_outlined,  )),
                        label: Text('나이', style: TextStyle(color: Colors.grey[600]),),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 0.1),
                      ),
                    ),
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
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        icon: Padding(padding: EdgeInsets.only(left: 10),
                            child: Icon(Icons.home_outlined,  )),
                        label: Text('주소', style: TextStyle(color: Colors.grey[600]),),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 0.1),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 45),
                    width: 200,
                    height: 40,
                    child: ElevatedButton(
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blueAccent)),
                      onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => Login() ));},
                      child: Text('회원가입',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold ),),
                    ),
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

