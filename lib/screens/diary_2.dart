import 'package:flutter/material.dart';
import 'diary.dart'; // 다이어리 화면을 import 합니다.

void main() {
  runApp(const Diary2());
}

class Diary2 extends StatelessWidget {
  const Diary2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Diary()), // 다이어리 화면으로 이동합니다.
              );
            },
          ),
          title: Text('운동 기록'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '6월 20일 (목)',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                      letterSpacing: -0.34,
                    ),
                  ),
                  Image(image: AssetImage('assets/i1.jpg'),width: 300,height: 400,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
