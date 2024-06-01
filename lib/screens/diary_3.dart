import 'package:fitple/screens/diary.dart';
import 'package:fitple/screens/diary_2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Diary3 extends StatefulWidget {
  final DateTime selectedDay;
  const Diary3({Key? key, required this.selectedDay}) : super(key: key);

  @override
  State<Diary3> createState() => _Diary3State();
}

class _Diary3State extends State<Diary3> {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 45),
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Text(
                DateFormat('yyyy년 MM월 dd일 (E)', 'ko_KR').format(widget.selectedDay),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                  letterSpacing: -0.34,
                ),
              ),
            ),
            SizedBox(height: 30),

          ],
        ),
      ),
    );
  }
}
