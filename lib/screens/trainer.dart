import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fitple/screens/chat_tr.dart';
import 'package:fitple/screens/pay.dart';
import 'package:fitple/screens/home_1.dart';

class Trainer extends StatefulWidget {
  const Trainer({Key? key}) : super(key: key);

  @override
  State<Trainer> createState() => _TrainerState();
}

class _TrainerState extends State<Trainer> with SingleTickerProviderStateMixin {
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

  Widget _buildTab(String text) {
    return Container(
      height: 20,
      child: Align(
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(fontSize: 15),
        ),
      ),
    );
  }

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
        title: Text('박성주 트레이너'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 15),
            Center(
              child: Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Wrap(
                  children: [
                    TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.black,

                      tabs: [
                        _buildTab('상세'),
                        _buildTab('리뷰'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildDetailsTab(),
                  _buildReviewsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildTrainerInfo(),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildTrainerInfo() {
    return Column(
      children: [
        Container(
          width: 470,
          alignment: Alignment.center,
          padding: EdgeInsets.all(20),
          decoration: ShapeDecoration(
            color: Color(0xFFF5F5F5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                      SizedBox(height: 50),
                      SingleChildScrollView(
                        child: Text(
                          '전) 팀라온 휘트니스 트레이너\n'
                              '전) 대한보디빌딩 협회 소속 선수\n'
                              '현) 육체미 첨단점 수석트레이너\n\n'
                              '생활체육지도자 보디빌딩 2급\n'
                              'NSCA-CPT (국제공인 퍼스널 트레이너)\n'
                              '의료관리자 자격증\n'
                              '응급처치 및 심폐소생술 CPR 교육수료\n\n'
                              '2023 NPCA 전남 보디빌딩 퍼스트 2위\n'
                              '2023 NPCA 세종 클래식피지크 입상\n'
                              '2023 NPCA 세종 보디빌딩 -65kg 입상\n\n'
                              '바디프로필, 다이어트, 대회준비 전문',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        Container(
          width: 470,
          padding: EdgeInsets.all(20),
          decoration: ShapeDecoration(
            color: Color(0xFFF5F5F5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            '개인PT (1시간) 10회 + 헬스:    400,000원\n'
                '개인PT (1시간) 20회 + 헬스:    700,000원\n'
                '개인PT (1시간) 30회 + 헬스:    1,000,000원\n'
                '그룹PT - 상담 후 결정:      무료',
            style: TextStyle(
              fontSize: 15,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatTr(userName: ''),
                    ),
                  );
                },
                child: Container(
                  alignment: Alignment.center,
                  margin:
                  EdgeInsets.only(left: 20, top: 20, bottom: 5, right: 10),
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blueAccent,
                  ),
                  child: Text(
                    '채팅하기',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Pay(),
                    ),
                  );
                },
                child: Container(
                  alignment: Alignment.center,
                  margin:
                  EdgeInsets.only(left: 10, top: 20, bottom: 5, right: 20),
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blueAccent,
                  ),
                  child: Text(
                    '결제하기',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReviewsTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 20),
          Container(
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
                  '친절하시고 자세하게 봐주십니다 !',
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
          SizedBox(height: 10),
          Container(
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
                  '어디 근육을 써야하는지 이해가 쏙쏙',
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
                      '2024. 05. 22    임XX',
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
    );
  }
}
