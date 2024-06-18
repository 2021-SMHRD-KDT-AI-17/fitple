import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fitple/DB/trainerDB.dart';
import 'package:fitple/screens/login.dart';

class JoinTrainer extends StatefulWidget {
  const JoinTrainer({super.key});

  @override
  State<JoinTrainer> createState() => _JoinTrainerState();
}

class _JoinTrainerState extends State<JoinTrainer> {
  final TextEditingController emailCon = TextEditingController();
  final TextEditingController pwCon = TextEditingController();
  final TextEditingController repwCon = TextEditingController();
  final TextEditingController nameCon = TextEditingController();
  final TextEditingController ageCon = TextEditingController();

  final gender = ['남자', '여자'];
  String? selectGender = '남자';

  final trainer = ['대표 강사', '직원'];
  String? selectTrainer = '대표 강사';

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

  @override
  void dispose() {
    emailCon.dispose();
    pwCon.dispose();
    repwCon.dispose();
    nameCon.dispose();
    ageCon.dispose();
    super.dispose();
  }

  void _register() async {
    if (pwCon.text != repwCon.text) {
      _showErrorDialog('입력한 비밀번호가 같지 않습니다');
      return;
    }

    final int trainerIdx = selectTrainer == '대표 강사' ? 0 : 1;

    try {
      Uint8List? imageBytes;
      if (_image != null) {
        imageBytes = await _image!.readAsBytes();
      }

      await insertTrainer(
        emailCon.text,
        pwCon.text,
        nameCon.text,
        selectGender!,
        int.parse(ageCon.text),
        trainerIdx,
        imageBytes,
      );

      _showSuccessDialog('회원가입이 완료되었습니다.');
    } catch (e) {
      print('회원가입 중 오류 발생: $e');
    }
  }

  void _checkEmail() async {
    try {
      final idCheck = await confirmIdCheck(emailCon.text);
      print('idCheck: $idCheck');

      if (idCheck != '0') {
        _showErrorDialog('입력한 이메일이 이미 존재합니다');
      } else {
        _showSuccessDialog('이메일 사용 가능');
      }
    } catch (e) {
      print('이메일 확인 중 오류 발생: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('알림'),
          content: Text(message),
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

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('알림'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
              child: Text('닫기'),
            ),
          ],
        );
      },
    );
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
            Navigator.pop(context);
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
                        onPressed: _checkEmail,
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
                        controller: ageCon,
                        style: TextStyle(color: Colors.black),
                        keyboardType: TextInputType.number,
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
                          SizedBox(width: 12),
                          Icon(Icons.person),
                          SizedBox(width: 14),
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
                      margin: EdgeInsets.only(top: 10),
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 12),
                          Icon(Icons.group),
                          SizedBox(width: 14),
                          DropdownButton<String>(
                            style: TextStyle(color: Colors.grey[600], fontSize: 16),
                            underline: SizedBox.shrink(),
                            value: selectTrainer,
                            items: trainer.map((value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectTrainer = value;
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
                      margin: EdgeInsets.only(top: 30, bottom: 30),
                      width: 200,
                      height: 40,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
                        ),
                        onPressed: _register,
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