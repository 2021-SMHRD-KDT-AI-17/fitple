import 'dart:io';

import 'package:fitple/screens/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class JoinTrainer extends StatefulWidget {
  const JoinTrainer({super.key});

  @override
  State<JoinTrainer> createState() => _JoinTrainerState();
}

class _JoinTrainerState extends State<JoinTrainer> {

  // final TextEditingController emailCon = TextEditingController();
  // final TextEditingController pwCon = TextEditingController();
  // final TextEditingController repwCon = TextEditingController();
  // final TextEditingController nickCon = TextEditingController();
  // final TextEditingController nameCon = TextEditingController();
  // final TextEditingController genderCon = TextEditingController();
  // final TextEditingController ageCon = TextEditingController();

  final gender = ['남자', '여자']; //변수명 변경 = trainer
  String? selectGender = '남자'; // = selectTrainer

  final trainer = ['대표 강사', '강사']; //변수명 변경 = trainer
  String? selectTrainer = '대표 강사'; // = selectTrainer

  File? _image;

  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } catch (e) {
      print('이미지를 선택할 수 없습니다: $e');
    }
  }



  // @override
  // void dispose() {
  //   emailCon.dispose();
  //   pwCon.dispose();
  //   repwCon.dispose();
  //   nickCon.dispose();
  //   nameCon.dispose();
  //   genderCon.dispose();
  //   ageCon.dispose();
  //   super.dispose();
  // }

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
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 10),
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
                      margin: EdgeInsets.only(top: 30),
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: TextField(
                        //controller: emailCon,
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
                        onPressed: () {}, // 중괄호는 지워도 무방 오류 방지 임시방편 - 기능 넣고 해당 주석 지워주세요
                        // async {
                        //   final idCheck = await confirmIdCheck(emailCon.text);
                        //   print('idCheck:$idCheck');
                        //
                        //   if (idCheck != '0') {
                        //     showDialog(
                        //       context: context,
                        //       builder: (BuildContext context) {
                        //         return AlertDialog(
                        //           title: Text('알림'),
                        //           content: Text('입력한 이메일이 이미 존재합니다'),
                        //           actions: [
                        //             TextButton(
                        //               onPressed: () {
                        //                 Navigator.of(context).pop();
                        //               },
                        //               child: Text('닫기'),
                        //             ),
                        //           ],
                        //         );
                        //       },
                        //     );
                        //   } else {
                        //     showDialog(
                        //       context: context,
                        //       builder: (BuildContext context) {
                        //         return AlertDialog(
                        //           title: Text('알림'),
                        //           content: Text('이메일 사용 가능'),
                        //           actions: [
                        //             TextButton(
                        //               onPressed: () {
                        //                 Navigator.of(context).pop();
                        //               },
                        //               child: Text('닫기'),
                        //             ),
                        //           ],
                        //         );
                        //       },
                        //     );
                        //   }
                        // },
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
                        //controller: pwCon,
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
                        //controller: repwCon,
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
                        //controller: nameCon,
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
                        //controller: ageCon,
                        style: TextStyle(color: Colors.black),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          //FilteringTextInputFormatter.digitsOnly,
                          //LengthLimitingTextInputFormatter(2),
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
                          Icon(Icons.person),
                          SizedBox(width: 14,),
                          DropdownButton<String>(
                            style: TextStyle(color: Colors.grey[600], fontSize: 16),
                            underline: SizedBox.shrink(),
                            value: selectGender, // selectGender를 DropdownButton의 value로 설정
                            items: gender.map((value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectGender = value; // 선택한 값으로 selectGender 업데이트
                              });
                            },
                          ),
                        ],
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
                            value: selectTrainer, // selectGender를 DropdownButton의 value로 설정
                            items: trainer.map((value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectTrainer = value; // 선택한 값으로 selectGender 업데이트
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        margin: EdgeInsets.only(top: 10),
                        width: 300,
                        height: _image != null ? 400 : 50, // 이미지 선택 여부에 따라 높이 조정
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey),
                          image: _image != null
                              ? DecorationImage(
                            image: FileImage(_image!),
                            fit: BoxFit.fill,
                          )
                              : DecorationImage(
                            image: AssetImage('assets/placeholder.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: _image == null
                            ? Center(
                          child: Text(
                            '대표 강사는 사업자 등록증을,\n강사는 근로계약서를 업로드 해주세요',
                            style: TextStyle(color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        )
                            : null,
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(top: 30),
                      width: 200,
                      height: 40,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all(Colors.blueAccent),
                        ),
                         onPressed: () {}, // 중괄호는 지워도 무방 오류 방지 임시방편 - 기능 넣고 주석 지워주세요
                        // async {
                        //   if (pwCon.text != repwCon.text) {
                        //     showDialog(
                        //       context: context,
                        //       builder: (BuildContext context) {
                        //         return AlertDialog(
                        //           title: Text('알림'),
                        //           content: Text('입력한 비밀번호가 같지 않습니다'),
                        //           actions: [
                        //             TextButton(
                        //               onPressed: () {
                        //                 Navigator.of(context).pop();
                        //               },
                        //               child: Text('닫기'),
                        //             ),
                        //           ],
                        //         );
                        //       },
                        //     );
                        //   } else {
                        //     insertMember(
                        //       emailCon.text,
                        //       pwCon.text,
                        //       nickCon.text,
                        //       nameCon.text,
                        //       selectGender!,
                        //       int.parse(ageCon.text),
                        //     );
                        //
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(builder: (context) => Login()),
                        //     );
                        //     showDialog(
                        //       context: context,
                        //       builder: (BuildContext context) {
                        //         return AlertDialog(
                        //           title: Text('알림'),
                        //           content: Text('회원가입이 완료되었습니다.'),
                        //           actions: [
                        //             TextButton(
                        //               onPressed: () {
                        //                 Navigator.of(context).pop();
                        //               },
                        //               child: Text('닫기'),
                        //             ),
                        //           ],
                        //         );
                        //       },
                        //     );
                        //   }
                        // },
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
      ),
    );
  }
}
