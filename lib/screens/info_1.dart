import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fitple/screens/home_1.dart';

class Info extends StatefulWidget {
  const Info({Key? key}) : super(key: key);

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
                builder: (context) => Home1(userName: ''),
              ),
            );
          },
        ),
        title: Text('육체미 첨단점'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 45),
            Container(
              margin: EdgeInsets.only(left: 35),
              child: Text(
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
            ),
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.only(right: 350, left: 20, bottom: 20),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(25),
                ),
                labelColor: Colors.black,
                unselectedLabelColor: Colors.black,
                tabs: [
                  _buildTab('상세'), // 첫 번째 탭
                  _buildTab('리뷰'), // 두 번째 탭
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
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
                              image: AssetImage('assets/gym4.jpg'), // 이미지 경로 설정
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          width: 400,
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(bottom: 20),
                          decoration: ShapeDecoration(
                            color: Color(0xFFF5F5F5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Center(
                              child:
                                  Text('광주 광산구 첨단중앙로170번길 92 첨단스포츠센터 5층, 육체미')),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 35),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '트레이너',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                              height: 1.5,
                              letterSpacing: -0.34,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
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
                          child: Row(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    'assets/train3.png',
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '박성주 트레이너',
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        '육체미 첨단점',
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        '바디프로필, 다이어트, 대회준비 전문',
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
                      ],
                    ),
                  ),
                  Column(
                   children: [ Container(
                      width: 400,
                      alignment: Alignment.center,
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
                                'assets/train3.png',
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
                                    '박성주 트레이너',
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    '육체미 첨단점',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    '바디프로필, 다이어트, 대회준비 전문',
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
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String text) {
    return Container(
      height: 20, // 탭의 높이 조절
      child: Align(
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(fontSize: 15),
        ),
      ),
    );
  }
}
