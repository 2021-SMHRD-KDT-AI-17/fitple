import 'dart:ui';
import 'package:fitple/screens/map.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fitple/screens/trainer.dart';
import 'package:fitple/screens/home_1.dart';
import 'package:flutter/widgets.dart';

class Info extends StatefulWidget {
  const Info({Key? key}) : super(key: key);

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
                    //Spacer(),
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
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '리뷰 2개',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                            Icon(
                              size: 15,
                              Icons.navigate_next,
                              color: Colors.black,
                            ),
                          ],
                        ),
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
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>NaverMapApp()));
                            },
                            child: Container(
                              child: Row(
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
                            ),
                          ),
                          //SizedBox(height: 10),
                          Container(
                            margin: EdgeInsets.only(top: 8),
                            child: Row(
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
                          ),
                          //SizedBox(height: 10),
                          Container(
                            margin: EdgeInsets.only(top: 8),
                            child: Row(
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
                          ),
                          //SizedBox(height: 10),
                          Container(
                            margin: EdgeInsets.only(top: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.attach_money,
                                  color: Colors.black,
                                ),
                                SizedBox(width: 2),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('그룹PT - 상담 후 결정'), // DB값 연결
                                          Text('무료'), // DB값 연결
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Column(
                        children: [
                          trainerCard(context, '박성주 트레이너', '육체미 첨단점', '바디프로필, 다이어트, 대회준비 전문', 'assets/train3.png'),
                          SizedBox(height: 10),
                          trainerCard(context, '라영웅 트레이너', '육체미 첨단점', '체력단련, 근력 강화', 'assets/train2.png'),
                          SizedBox(height: 10),
                          trainerCard(context, '김시우 트레이너', '육체미 첨단점', '다이어트 전문', 'assets/train4.png'),
                          // 더 많은 트레이너 카드를 여기에 추가할 수 있습니다
                        ],
                      ),
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
            builder: (context) => Trainer(),
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
                    Row(
                      children: [
                        Icon(Icons.person, color: Colors.black),
                        SizedBox(width: 5),
                        Text(
                          '작성자: 홍길동',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      '리뷰 내용...',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
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
                    Row(
                      children: [
                        Icon(Icons.person, color: Colors.black),
                        SizedBox(width: 5),
                        Text(
                          '작성자: 김철수',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      '리뷰 내용...',
                      style: TextStyle(color: Colors.black),
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
}
