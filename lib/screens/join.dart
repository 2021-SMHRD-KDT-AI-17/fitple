import 'package:fitple/DB/LoginDB.dart';
import 'package:fitple/screens/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const Join());
}

class Join extends StatefulWidget {
  const Join({super.key});

  @override
  _JoinState createState() => _JoinState();
}

class _JoinState extends State<Join> {
  final TextEditingController emailCon = TextEditingController();
  final TextEditingController pwCon = TextEditingController();
  final TextEditingController repwCon = TextEditingController();
  final TextEditingController nickCon = TextEditingController();
  final TextEditingController nameCon = TextEditingController();
  final TextEditingController genderCon = TextEditingController();
  final TextEditingController ageCon = TextEditingController();

  final gender = ['남자', '여자'];
  String? selectGender = '남자';

  @override
  void dispose() {
    emailCon.dispose();
    pwCon.dispose();
    repwCon.dispose();
    nickCon.dispose();
    nameCon.dispose();
    genderCon.dispose();
    ageCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Login()),
            );
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 30),
                child: Text(
                  'FITPLE',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 60,
                  ),
                ),
              ),
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 40),
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: TextField(
                      controller: emailCon,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        icon: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Icon(Icons.email_outlined),
                        ),
                        label: Text(
                          '이메일',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 0.1),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                      ),
                      onPressed: () async {
                        final idCheck = await confirmIdCheck(emailCon.text);
                        print('idCheck:$idCheck');

                        if (idCheck != '0') {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('알림'),
                                content: Text('입력한 이메일이 이미 존재합니다'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('닫기'),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('알림'),
                                content: Text('이메일 사용 가능'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('닫기'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      child: Text(
                        '이메일 중복체크',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: TextField(
                      controller: pwCon,
                      obscureText: true,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        icon: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Icon(Icons.vpn_key_outlined),
                        ),
                        label: Text(
                          '비밀번호',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 0.1),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: TextField(
                      controller: repwCon,
                      obscureText: true,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        icon: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Icon(Icons.vpn_key_outlined),
                        ),
                        label: Text(
                          '비밀번호 확인',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 0.1),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: TextField(
                      controller: nameCon,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        icon: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Icon(Icons.person_outlined),
                        ),
                        label: Text(
                          '이름',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 0.1),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: TextField(
                      controller: nickCon,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        icon: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Icon(Icons.face),
                        ),
                        label: Text(
                          '닉네임',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 0.1),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: TextField(
                      controller: ageCon,
                      style: TextStyle(color: Colors.black),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(2),
                      ],
                      decoration: InputDecoration(
                        icon: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Icon(Icons.cake_outlined),
                        ),
                        label: Text(
                          '나이',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 0.1),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 12,),
                        Icon(Icons.group),
                        SizedBox(width: 14,),
                        DropdownButton<String>(
                          style: TextStyle(color: Colors.grey[600], fontSize: 16),
                          underline: SizedBox.shrink(),
                          value: selectGender,
                          items: gender.map((value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectGender = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    width: 200,
                    height: 40,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(Colors.blueAccent),
                      ),
                      onPressed: () async {
                        if (pwCon.text != repwCon.text) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('알림'),
                                content: Text('입력한 비밀번호가 같지 않습니다'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('닫기'),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          insertMember(
                            emailCon.text,
                            pwCon.text,
                            nickCon.text,
                            nameCon.text,
                            selectGender!,
                            int.parse(ageCon.text),
                          );
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('알림'),
                                content: Text('회원가입이 완료되었습니다.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('닫기'),
                                  ),
                                ],
                              );
                            },
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Login()),
                          );
                        }
                      },
                      child: Text(
                        '회원가입',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
