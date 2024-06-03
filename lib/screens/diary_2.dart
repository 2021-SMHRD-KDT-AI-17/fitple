import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'package:mysql_client/mysql_client.dart';
import 'package:intl/intl.dart';
import 'package:fitple/DB/LoginDB.dart'; // UserSession 클래스를 사용하기 위해 임포트

class Diary2 extends StatefulWidget {
  final DateTime selectedDay;
  final Function(DateTime) onAddAttendance;

  const Diary2({Key? key, required this.selectedDay, required this.onAddAttendance}) : super(key: key);

  @override
  _Diary2State createState() => _Diary2State();
}

class _Diary2State extends State<Diary2> {
  File? _image;
  final List<String> _exerciseList = [];
  final TextEditingController _controller = TextEditingController();

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

  void _addExercise() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _exerciseList.add(_controller.text);
        _controller.clear();
      });
    }
  }

  Future<void> _sendDataToServer(String email) async {
    try {
      final conn = await dbConnector();

      final query = """
        INSERT INTO fit_log (user_email, log_text, log_date, log_picture) 
        VALUES (:user_email, :log_text, :log_date, :log_picture)
      """;

      final logText = jsonEncode(_exerciseList);
      final logDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(widget.selectedDay); // 형식 변환
      final logPicture = _image != null ? base64Encode(_image!.readAsBytesSync()) : null;

      await conn.execute(
        query,
        {
          'user_email': email,
          'log_text': logText,
          'log_date': logDate,
          'log_picture': logPicture,
        },
      );

      await conn.close();

      print('운동 기록 추가 성공');
    } catch (e) {
      print('운동 기록 추가 실패: $e');
    }
  }

  Future<MySQLConnection> dbConnector() async {
    print("Connecting to mysql server...");

    final conn = await MySQLConnection.createConnection(
      host: 'project-db-cgi.smhrd.com',
      port: 3307,
      userName: 'wldhz',
      password: '126',
      databaseName: 'wldhz',
    );

    await conn.connect();

    print("Connected");

    return conn;
  }

  @override
  Widget build(BuildContext context) {
    final userEmail = UserSession().userEmail;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('운동 기록'),
        actions: [
          TextButton(
            onPressed: () async {
              if (userEmail != null) {
                await _sendDataToServer(userEmail);
                widget.onAddAttendance(widget.selectedDay);
                Navigator.pop(context);
              } else {
                print('User email not available');
              }
            },
            child: Text(
              '완료',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: 400,
          alignment: Alignment.center,
          margin: EdgeInsets.only(left: 30, top: 20),
          padding: EdgeInsets.only(bottom: 20),
          decoration: ShapeDecoration(
            color: Color(0xFFF5F5F5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 45),
              Container(
                margin: EdgeInsets.only(left: 20),
                child: Text(
                  DateFormat('yyyy년 MM월 dd일 (E)', 'ko_KR').format(widget.selectedDay),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 0.08,
                    letterSpacing: -0.34,
                  ),
                ),
              ),
              SizedBox(height: 30),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: 322,
                  height: 320,
                  padding: const EdgeInsets.all(10),
                  decoration: ShapeDecoration(
                    image: _image != null
                        ? DecorationImage(
                      image: FileImage(_image!),
                      fit: BoxFit.fill,
                    )
                        : DecorationImage(
                      image: AssetImage('assets/placeholder.png'),
                      fit: BoxFit.fill,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _image == null
                      ? Center(
                    child: Text(
                      '이미지를 선택하려면 여기를 누르세요',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                      : null,
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(hintText: '운동을 입력하세요'),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: _addExercise,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _exerciseList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_exerciseList[index]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}