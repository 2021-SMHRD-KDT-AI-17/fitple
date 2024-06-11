import 'dart:io';
import 'package:fitple/screens/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fitple/DB/trainerDB.dart';
import 'package:mysql_client/mysql_client.dart';

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

  // Future<void> insertTrainer(String trainer_email, String trainer_password, String trainer_name, String gender, int age, int trainer_idx, File? trainer_picture) async {
  //   final conn = await dbConnector();
  //
  //   try {
  //     await conn.execute(
  //       "INSERT INTO fit_trainer(trainer_email, trainer_password, trainer_name, gender, age, trainer_idx, trainer_picture) VALUES (:trainer_email, :trainer_password, :trainer_name, :gender, :age, :trainer_idx, :trainer_picture)",
  //       {
  //         "trainer_email": trainer_email,
  //         "trainer_password": trainer_password,
  //         "trainer_name": trainer_name,
  //         "gender": gender,
  //         "age": age,
  //         "trainer_idx": trainer_idx,
  //         "trainer_picture": trainer_picture != null ? trainer_picture.readAsBytesSync() : null,
  //       },
  //     );
  //     print('DB 연결 성공');
  //   } catch (e) {
  //     print('DB 연결 실패: $e');
  //   } finally {
  //     await conn.close();
  //   }
  // }

  // Future<String?> confirmIdCheck(String trainer_email) async {
  //   final conn = await dbConnector();
  //
  //   IResultSet? result;
  //
  //   try {
  //     result = await conn.execute(
  //         "SELECT IFNULL((SELECT trainer_email FROM fit_trainer WHERE trainer_email=:trainer_email), 0) as idCheck",
  //         {"trainer_email": trainer_email}
  //     );
  //
  //     if (result.isNotEmpty) {
  //       for (final row in result.rows) {
  //         return row.colAt(0);
  //       }
  //     }
  //   } catch (e) {
  //     print('DB 연결 실패: $e');
  //   } finally {
  //     await conn.close();
  //   }
  //   return '-1';
  // }

  void _register() async {
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
      return;
    }

    final int trainerIdx = selectTrainer == '대표 강사' ? 0 : 1;

    try {
      await insertTrainer(
        emailCon.text,
        pwCon.text,
        nameCon.text,
        selectGender!,
        int.parse(ageCon.text),
        trainerIdx,
        _image,
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
    } catch (e) {
      print('회원가입 중 오류 발생: $e');
    }
  }

  void _checkEmail() async {
    try {
      final idCheck = await confirmIdCheck(emailCon.text);
      print('idCheck: $idCheck');

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
    } catch (e) {
      print('이메일 확인 중 오류 발생: $e');
    }
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
