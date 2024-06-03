import 'package:fitple/Diary/diary_user.dart';
import 'package:fitple/screens/chat_list.dart';
import 'package:fitple/screens/diary.dart';
import 'package:fitple/screens/info_1.dart';
import 'package:fitple/screens/info_2.dart';
import 'package:fitple/screens/mypage.dart';
import 'package:fitple/screens/trainer.dart';
import 'package:flutter/material.dart';
import 'package:fitple/DB/LoginDB.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';

class Home1 extends StatefulWidget {
  final String userName;
  const Home1({super.key, required this.userName});

  @override
  _Home1State createState() => _Home1State();
}

class _Home1State extends State<Home1> {
  int _selectedIndex = 0;

  final List<Widget> _navIndex = [
    Home_content(userName: ''), // 임시로 빈 값 전달
    ChatList(userName: ''),
    Diary(),
    MyPage()
  ];

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    _navIndex[0] = Home_content(userName: widget.userName);
    _navIndex[1] = ChatList(userName: widget.userName);

    // UserSession에 userEmail 설정
    final userEmail = diaryuser().userEmail;
    if (userEmail == null) {
      // 여기에 실제 로그인된 이메일을 설정해야 합니다.
      diaryuser().setUserEmail('로그인된_사용자_이메일');
    }
  }

  void _onNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 15, top: 20),
          child: Text(
            'FITPLE',
            style: TextStyle(
              fontSize: 30,
              color: Colors.blueAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: _navIndex.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            label: '채팅',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_emotions_outlined),
            label: '운동일기',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: '마이페이지',
          ),
        ],
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onNavTapped,
      ),
    );
  }
}

class Home_content extends StatefulWidget {
  final String userName;
  const Home_content({super.key, required this.userName});

  @override
  _Home_contentState createState() => _Home_contentState();
}

class _Home_contentState extends State<Home_content> {
  final TextEditingController emailCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 25, left: 30),
                child: Row(
                  children: [
                    Text(
                      '광산구 첨단중앙로 153',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    IconButton(
                      onPressed: null,
                      icon: Icon(
                        Icons.expand_more_outlined,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: 95,
                    ),
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        onPressed: null,
                        icon: Icon(
                          Icons.filter_alt_outlined,
                          color: Colors.black,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(top: 13, left: 30),
                child: Text(
                  '${widget.userName} 님을 위한 추천 트레이너',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(), // ListView 스크롤 비활성화
                itemCount: 3,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Trainer()),);},
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.blueAccent, width: 2),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                'assets/train1.png',
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
                  );
                },
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(top: 30, left: 30),
                child: Text(
                  '${widget.userName} 님을 위한 추천 헬스장',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(height: 10),
              // GridView의 높이를 아이템 높이와 텍스트 높이에 맞게 조정
              Container(
                child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  // GridView 스크롤 비활성화
                  padding: EdgeInsets.all(20),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 한 축에 들어갈 그리드 개수
                    mainAxisSpacing: 15, // 그리드의 위 아래 간격 조율
                    crossAxisSpacing: 5, // 그리드의 양 옆 간격 조율
                    childAspectRatio: 0.8, // 아이템의 가로 세로 비율 조정
                  ),
                  itemCount: 8,
                  // 아이템 개수 지정
                  shrinkWrap: true,
                  // GridView에 shrinkWrap 속성 추가
                  itemBuilder: (context, index) {                    return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Info()),);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 150,
                          margin: EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              'assets/gym3.jpg',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '육체미 첨단점',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '광산구 첨단중앙로170번길 92, 5층',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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