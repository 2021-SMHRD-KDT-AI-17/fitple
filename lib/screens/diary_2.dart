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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16), // 위에 간격 추가
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
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
            ),
            SizedBox(height: 16), // 텍스트와 이미지 사이에 간격 추가
            Center(
              child: Image(
                image: AssetImage('assets/i1.jpg'),
                width: 600,
                height: 400,
              ),
            ),
            SizedBox(height: 30,),
                Container(
                  margin: EdgeInsets.only(left: 20),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      '하이로우 3세트',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
            SizedBox(height: 15,),
                Container(
                  margin: EdgeInsets.only(left: 20),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      '스트레이트 암풀다운 3세트',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
            SizedBox(height: 15,),
                Container(
                  margin: EdgeInsets.only(left: 20),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      '케이블 암풀다운 3세트',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),




        ),

    );
  }
}
