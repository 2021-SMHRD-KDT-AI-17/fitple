import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'diary.dart';
import 'package:intl/intl.dart';

class Diary2 extends StatefulWidget {
  final DateTime selectedDay;

  const Diary2({Key? key, required this.selectedDay}) : super(key: key);

  @override
  _Diary2State createState() => _Diary2State();
}

class _Diary2State extends State<Diary2> {
  File? _image;
  final List<String> _exerciseList = []; // 운동 목록을 저장할 리스트
  final TextEditingController _controller = TextEditingController(); // 텍스트 입력 컨트롤러

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
        _controller.clear(); // 텍스트 필드 초기화
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Diary(),
              ),
            );
          },
        ),
        title: Text('운동 기록'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Diary()),
              );
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
              SizedBox(height: 45), // 상단 여백 추가
              Container(
                margin: EdgeInsets.only(left: 20),
                child: Text(
                  DateFormat('yyyy년 MM월 dd일 (E)', 'ko_KR').format(widget.selectedDay), // 선택한 날짜를 포맷하여 표시
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
                        decoration: InputDecoration(
                          hintText: '운동을 입력하세요',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: _addExercise,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: 322,
                child: Column(
                  children: _exerciseList.map((exercise) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: ShapeDecoration(
                        color: Color(0xCC285FEB),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        exercise,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
