import 'dart:ui';
import 'package:fitple/screens/map.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fitple/screens/trainer.dart';
import 'package:fitple/screens/home_1.dart';

class Info extends StatefulWidget {
  final String userEmail;
  const Info({Key? key, required this.userEmail});

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('육체미 첨단점'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 15),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 35),
                alignment: AlignmentDirectional.topStart,
                child: Row(
                  children: [
                    Text(
                      '육체미 첨단점',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        height: 1.5,
                        letterSpacing: -0.34,
                      ),
                    ),
                    Spacer(),
                    ElevatedButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Review()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide.none,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '리뷰 2개',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          Icon(
                            Icons.navigate_next,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 400,
                      height: 320,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: AssetImage('assets/gym4.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: 400,
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(20),
                      decoration: ShapeDecoration(
                        color: Color(0xFFF5F5F5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: (){
                              //Navigator.push(context, MaterialPageRoute(builder: (context)=>NaverMapView()));
                            },
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.black,
                              ),
                              SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  '광주 광산구 첨단중앙로170번길 92 첨단스포츠센터 5층, 육체미',
                                  style: TextStyle(color: Colors.black),
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time_outlined,
                                color: Colors.black,
                              ),
                              SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  '매일 05:00 ~ 24:00',
                                  style: TextStyle(color: Colors.black),
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(
                                Icons.phone,
                                color: Colors.black,
                              ),
                              SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  '010-1234-5678',
                                  style: TextStyle(color: Colors.black),
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.attach_money,
                                color: Colors.black,
                              ),
                              SizedBox(width: 2),
                              Expanded(
                                child: Text(
                                  '헬스 1개월:    20,000원\n'
                                      '헬스 3개월:    60,000원\n'
                                      '헬스 6개월:    120,000원\n'
                                      '헬스 12개월:    240,000원\n'
                                      '개인PT (1시간) 10회 + 헬스:    400,000원\n'
                                      '개인PT (1시간) 20회 + 헬스:    700,000원\n'
                                      '개인PT (1시간) 30회 + 헬스:    1,000,000원\n'
                                      '그룹PT - 상담 후 결정:      무료',
                                  style: TextStyle(color: Colors.black),
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Column(
                      children: [
                        trainerCard(context, '박성주 트레이너', '육체미 첨단점', '바디프로필, 다이어트, 대회준비 전문', 'assets/train3.png'),
                        SizedBox(height: 10),
                        trainerCard(context, '라영웅 트레이너', '육체미 첨단점', '체력단련, 근력 강화', 'assets/train2.png'),
                        SizedBox(height: 10),
                        trainerCard(context, '김시우 트레이너', '육체미 첨단점', '다이어트 전문', 'assets/train4.png'),
                        // Add more trainer cards here as needed
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget trainerCard(BuildContext context, String name, String gym, String specialty, String imagePath) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Trainer(trainerName: "trainerName", gymName: "gymName", trainerEmail: "trainerEmail",userEmail: widget.userEmail,),
          ),
        );
      },
      child: Container(
        width: 400,
        padding: EdgeInsets.all(20),
        decoration: ShapeDecoration(
          color: Color(0xFFF5F5F5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  width: 70,
                  height: 70,
                ),
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Container(
                height: 80,
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      gym,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      specialty,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class Review extends StatefulWidget {
  @override
  _ReviewState createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('리뷰'),
        centerTitle: true, // 중앙 정렬
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                width: 470,
                alignment: Alignment.center,
                padding: EdgeInsets.all(20),
                decoration: ShapeDecoration(
                  color: Color(0xFFF5F5F5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '깔끔하고 시원하네요',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Container(),
                        ),
                        Text(
                          '2024. 05. 22    이XX',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 3),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                width: 470,
                alignment: Alignment.center,
                padding: EdgeInsets.all(20),
                decoration: ShapeDecoration(
                  color: Color(0xFFF5F5F5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '열정적인 헬스장! 추천합니다',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Container(),
                        ),
                        Text(
                          '2024. 05. 23    김XX',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 3),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}