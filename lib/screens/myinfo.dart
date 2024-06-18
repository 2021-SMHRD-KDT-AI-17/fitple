import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:fitple/DB/LoginDB.dart';
import 'package:fitple/screens/home_1.dart';
import 'package:fitple/screens/mypage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MyInfo extends StatefulWidget {
  final String userEmail;
  const MyInfo({super.key, required this.userEmail});

  @override
  State<MyInfo> createState() => _MyInfoState();
}

class _MyInfoState extends State<MyInfo> {
  final TextEditingController emailCon = TextEditingController();
  final TextEditingController pwCon = TextEditingController();
  final TextEditingController repwCon = TextEditingController();
  final TextEditingController nameCon = TextEditingController();
  final TextEditingController nickCon = TextEditingController();
  final TextEditingController genderCon = TextEditingController();
  final TextEditingController ageCon = TextEditingController();

  Uint8List? _imageBytes;
  File? _image;

  @override
  void initState() {
    super.initState();
    userselect(widget.userEmail).then((userResult) {
      if (userResult != null) {
        setState(() {
          emailCon.text = widget.userEmail;
          nameCon.text = userResult['userRealName'] ?? '';
          nickCon.text = userResult['userNick'] ?? '';
          genderCon.text = userResult['userGender'] ?? '';
          ageCon.text = userResult['userAge'] ?? '';
          _imageBytes = userResult['userPicture'];
        });
      } else {
        print('null값임!!');
      }
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _image = File(image.path);
        _imageBytes = bytes;
      });
    }
  }

  Future<void> _saveChanges() async {
    try {
      String userName = nameCon.text;
      String userNick = nickCon.text;
      String userGender = genderCon.text;
      int? userAge = int.tryParse(ageCon.text);
      String userPw = pwCon.text;

      String? imageBase64;
      if (_imageBytes != null) {
        imageBase64 = base64Encode(_imageBytes!);
      }

      await updateUserInfo( widget.userEmail, userPw, userName, userNick, userGender, userAge, imageBase64);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('알림'),
            content: Text('회원정보가 수정되었습니다.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // 닫기
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Home1(
                        userName: userName,
                        userEmail: widget.userEmail,
                        Check: '0', // 예시 값, 필요에 따라 수정
                      ),
                    ),
                  );
                },
                child: Text('확인'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('오류'),
            content: Text('입력 값이 올바르지 않습니다.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // 닫기
                },
                child: Text('닫기'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          '회원 정보 수정',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
        ),
        actions: [
          TextButton(
            onPressed: _saveChanges,
            child: Text(
              '완료',
              style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Container(
                  width: 100,
                  height: 100,
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(1000),
                    ),
                  ),
                  child: _image != null
                      ? Image.file(_image!, fit: BoxFit.cover)
                      : (_imageBytes != null
                      ? Image.memory(_imageBytes!, fit: BoxFit.cover)
                      : Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/basicimage.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )),
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: _pickImage,
                    child: Text(
                      '사진 변경',
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30),
                  height: 1,
                  color: Colors.grey[300],
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Text(
                            '이메일',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                            emailCon.text,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Text(
                            '비밀번호 변경',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          child: TextField(
                            controller: pwCon,
                            obscureText: true,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Colors.black12)),
                              contentPadding: EdgeInsets.only(left: 0.1),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Text(
                            '비밀번호 확인',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          child: TextField(
                            controller: repwCon,
                            obscureText: true,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Colors.black12)),
                              contentPadding: EdgeInsets.only(left: 0.1),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Text(
                            '이름',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                            nameCon.text,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Text(
                            '닉네임',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          child: TextField(
                            controller: nickCon,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Colors.black12)),
                              contentPadding: EdgeInsets.only(left: 0.1),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Text(
                            '성별',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                            genderCon.text,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Text(
                            '나이',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                            ageCon.text,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 40),
                  height: 1,
                  color: Colors.grey[300],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}