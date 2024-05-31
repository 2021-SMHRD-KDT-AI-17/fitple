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
                '등록',
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
            height: 600,
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: 30, top: 20,),
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
                Text(
                  '2024년 6월 20일 (목)',
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
                SizedBox(height: 30), // 텍스트와 컨테이너 사이 간격 추가
                Container(
                  width: 322,
                  height: 470,
                  child: Stack(
                    children: [
                      Container(
                        width: 322,
                        height: 320,
                        padding: const EdgeInsets.all(10),
                        decoration: ShapeDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/i1.jpg'),
                            fit: BoxFit.fill,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        top: 334,
                        child: Container(
                          width: 147,
                          height: 39,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                          decoration: ShapeDecoration(
                            color: Color(0xCC285FEB),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '하이로우 3세트',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                height: 0.09,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        top: 382,
                        child: Container(
                          width: 217,
                          height: 39,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                          decoration: ShapeDecoration(
                            color: Color(0xCC285FEB),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '스트레이트 암풀다운 3세트',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                height: 0.09,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        top: 431,
                        child: Container(
                          width: 195,
                          height: 39,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                          decoration: ShapeDecoration(
                            color: Color(0xCC285FEB),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '케이블 암풀다운 3세트',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                height: 0.09,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
