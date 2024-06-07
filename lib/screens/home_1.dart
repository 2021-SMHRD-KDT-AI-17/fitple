import 'package:fitple/DB/GymDB.dart';
import 'package:fitple/Diary/diary_user.dart';
import 'package:fitple/screens/chat_list.dart';
import 'package:fitple/screens/diary.dart';
import 'package:fitple/screens/info_1.dart';
import 'package:fitple/screens/map.dart';
import 'package:fitple/screens/mypage.dart';
import 'package:fitple/screens/recommend_trainer.dart';
import 'package:fitple/screens/search.dart';
import 'package:fitple/screens/search2.dart';
import 'package:fitple/screens/trainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:fitple/DB/trainerDB.dart'; // trainerDB.dart 파일 import

class Home1 extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String Check;
  const Home1({super.key, required this.userName, required this.userEmail, required this.Check});

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
      MyPage(userEmail: widget.userEmail, Check: widget.Check)
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
  List<Map<String, dynamic>> _gyms = []; // 헬스장 데이터를 저장할 리스트
  bool _showAllGyms = false; // 헬스장 모두 보기 여부
  bool _showAllTrainers = false; // 트레이너 모두 보기 여부
  int _trainerShowMoreCount = 0; // 더보기 클릭 횟수 카운터

  @override
  void initState() {
    super.initState();
    _address = widget.address;
    fetchTrainers(); // 트레이너 데이터를 가져오는 함수 호출
    fetchGyms(); // 헬스장 데이터를 가져오는 함수 호출
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

  // 헬스장 데이터를 가져오는 함수
  void fetchGyms() async {
    List<Map<String, dynamic>> gyms = await loadGym();
    setState(() {
      _gyms = gyms;
    });
  }

  @override
  Widget build(BuildContext context) {
    int displayTrainerCount = _showAllTrainers ? _trainers.length : (_trainerShowMoreCount == 1 ? 8 : (_trainers.length > 4 ? 4 : _trainers.length));
    int displayGymCount = _showAllGyms ? _gyms.length : (_gyms.length > 6 ? 6 : _gyms.length);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Address and filter button
              Container(
                padding: EdgeInsets.only(top: 25, left: 25, right: 25),
                child: Row(
                  children: [
                    Text(
                      _address,
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
                                _updateAddress(newAddress);
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
              // Recommended trainers section
              Container(
                // alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(top: 13, left: 30, right: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${widget.userName} 님을 위한 추천 트레이너',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Search()),
                          );
                        },
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
              SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: displayTrainerCount,
                itemBuilder: (context, index) {
                  var trainer = _trainers[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Trainer(
                          trainerName: trainer['trainer_name'] ?? '',
                          gymName: trainer['gym_name'] ?? '무소속',
                          trainerPicture: trainer['trainer_picture'],
                          trainerEmail: trainer['trainer_email'] ?? '',
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
                                    trainer['trainer_name'] ?? '',
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
              if (_trainers.length > 4 && !_showAllTrainers)
                TextButton(
                  onPressed: () {
                    setState(() {
                      if (_trainerShowMoreCount == 0) {
                        _trainerShowMoreCount++;
                      } else if (_trainerShowMoreCount == 1) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RecommendTrainer(userName: '')),
                        );
                      }
                    });
                  },
                  child: Text('더보기'),
                ),
              // Recommended gyms section
              Container(
                //alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(top: 30, left: 30, right: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${widget.userName} 님을 위한 추천 헬스장',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Search2()),
                          );
                        },
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
              SizedBox(height: 10),
              Container(
                child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.all(20),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 5,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: displayGymCount,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    var gym = _gyms[index];
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
                              child: gym['gym_picture'] != null
                                  ? Image.memory(
                                gym['gym_picture'],
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              )
                                  : Image.asset(
                                'assets/gym3.jpg',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                          ),
                          Text(
                            gym['gym_name'] ?? '',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            gym['gym_address'] ?? '',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              if (_gyms.length > 6 && !_showAllGyms)
                TextButton(
                  onPressed: () {
                    setState(() {
                      _showAllGyms = true;
                    });
                  },
                  child: Text('더보기'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
