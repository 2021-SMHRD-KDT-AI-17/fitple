import 'package:fitple/Diary/diary_user.dart';
import 'package:fitple/screens/chat_list.dart';
import 'package:fitple/screens/diary.dart';
import 'package:fitple/screens/info_1.dart';
import 'package:fitple/screens/map.dart';
import 'package:fitple/screens/mypage.dart';
import 'package:fitple/screens/trainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:fitple/DB/trainerDB.dart'; // trainerDB.dart 파일 import

class Home1 extends StatefulWidget {
  final String userName;
  final String userEmail;
  const Home1({super.key, required this.userName, required this.userEmail});

  @override
  _Home1State createState() => _Home1State();
}

class _Home1State extends State<Home1> {
  int _selectedIndex = 0;
  String _selectedAddress = '광주광역시 동구 중앙로 196';

  List<Widget> _navIndex = [];

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    _navIndex = [
      HomeContent(
        userName: widget.userName,
        address: _selectedAddress,
        onAddressUpdated: (newAddress) {
          setState(() {
            _selectedAddress = newAddress;
          });
        },
      ),
      ChatList(userName: widget.userName, userEmail: widget.userEmail),
      Diary(),
      MyPage()
    ];

    final userEmail = diaryuser().userEmail;
    if (userEmail == null) {
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

class HomeContent extends StatefulWidget {
  final String userName;
  final String address;
  final Function(String) onAddressUpdated;

  const HomeContent({super.key, required this.userName, required this.address, required this.onAddressUpdated});

  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  late String _address;
  List<Map<String, dynamic>> _trainers = []; // 트레이너 데이터를 저장할 리스트

  @override
  void initState() {
    super.initState();
    _address = widget.address;
    fetchTrainers(); // 트레이너 데이터를 가져오는 함수 호출
  }

  void _updateAddress(String newAddress) {
    setState(() {
      _address = newAddress;
      widget.onAddressUpdated(newAddress);
    });
  }

  // 트레이너 데이터를 가져오는 함수
  void fetchTrainers() async {
    List<Map<String, dynamic>> trainers = await loadTrainersWithGym();
    setState(() {
      _trainers = trainers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 25, left: 25, right: 25),
                //margin: EdgeInsets.only(top: 25, left: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Text(
                            _address, // _address 사용
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            overflow: TextOverflow.ellipsis,
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (build) => NaverMapApp(
                                    onAddressSelected: (newAddress) {
                                      _updateAddress(newAddress); // 업데이트 메서드 호출
                                    },
                                  ),
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.expand_more_outlined,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
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
                itemCount: _trainers.length,
                itemBuilder: (context, index) {
                  var trainer = _trainers[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Trainer(
                          trainerName: trainer['trainer_name'],
                          gymName: trainer['gym_name'],
                          trainerPicture: trainer['trainer_picture'],
                          trainerEmail: trainer['trainer_email'],
                        )),
                      );
                    },
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
                              child: trainer['trainer_picture'] != null
                                  ? Image.memory(
                                trainer['trainer_picture'],
                                fit: BoxFit.cover,
                                width: 70,
                                height: 70,
                              )
                                  : Image.asset(
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
                                    trainer['trainer_name'],
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    trainer['gym_name'] ?? '무소속',
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
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Info()),
                        );
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