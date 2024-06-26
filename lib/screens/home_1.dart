import 'package:fitple/DB/GymDB.dart';
import 'package:fitple/DB/chatDB.dart';
import 'package:fitple/Diary/diary_user.dart';
import 'package:fitple/screens/chat_list.dart';
import 'package:fitple/screens/diary.dart';
import 'package:fitple/screens/info_1.dart';
import 'package:fitple/screens/map.dart';
import 'package:fitple/screens/mypage.dart';
import 'package:fitple/screens/recommend_gym.dart';
import 'package:fitple/screens/recommend_trainer.dart';
import 'package:fitple/screens/search.dart';
import 'package:fitple/screens/search2.dart';
import 'package:fitple/screens/trainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:fitple/DB/trainerDB.dart'; // trainerDB.dart 파일 import

void main() {
  runApp(const ChatAI(userName: '', userEmail: '',));
}

class ChatAI extends StatelessWidget {
  final String userName;
  final String userEmail;
  const ChatAI({super.key, required this.userName, required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white, // Set scaffold background to white
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white, // Set AppBar background to white
          elevation: 0.0, // Remove AppBar elevation
          iconTheme: IconThemeData(color: Colors.black),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white, // Set BottomNavigationBar background to white
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
        ),
      ),
      home: Home1(userName: userName, userEmail: userEmail, Check: ''),
    );
  }
}

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
  String _selectedAddress = '광주광역시 남구 송암로 60';

  List<Widget> _navIndex = [];

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    _navIndex = [
      HomeContent(
        userEmail: widget.userEmail,
        userName: widget.userName,
        address: _selectedAddress,
        onAddressUpdated: (newAddress) {
          setState(() {
            _selectedAddress = newAddress;
          });
        },
      ),
      ChatList(userName: widget.userName, userEmail: widget.userEmail),
      Diary(userName: widget.userName, userEmail: widget.userEmail,),
      MyPage(userEmail: widget.userEmail, Check: widget.Check, userName: widget.userName,)
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
        elevation: 0.0, // Remove the shadow
        shadowColor: Colors.transparent, // Ensure no shadow is applied
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 15, top: 15),
          child: Text(
            'FITPLE',
            style: TextStyle(
              fontSize: 30,
              color: Colors.blueAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        //titleSpacing: 0, // Ensure no extra padding around the title
      ),
      body: _navIndex.elementAt(_selectedIndex),
      bottomNavigationBar: Container(
        color: Colors.white, // Ensure the bottom navigation bar container is white
        child: BottomNavigationBar(
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
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  final String userName;
  final String address;
  final String userEmail;
  final Function(String) onAddressUpdated;

  const HomeContent({super.key, required this.userName, required this.address, required this.onAddressUpdated, required this.userEmail});

  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  late String _address;
  List<Map<String, dynamic>> _trainers = []; // 트레이너 데이터를 저장할 리스트
  List<Map<String, dynamic>> _gyms = []; // 헬스장 데이터를 저장할 리스트
  bool _showAllTrainers = false; // 트레이너 모두 보기 여부
  int _trainerShowMoreCount = 0; // 트레이너 더보기 클릭 횟수 카운터
  int _gymShowMoreCount = 0; // 헬스장 더보기 클릭 횟수 카운터

  @override
  void initState() {
    super.initState();
    _address = widget.userName.isNotEmpty ? widget.address : '주소를 입력하세요';
    fetchTrainers(); // 트레이너 데이터를 가져오는 함수 호출
    fetchGyms(); // 헬스장 데이터를 가져오는 함수 호출
  }

  void _updateAddress(String newAddress, String newDetailAddress) {
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
    print("Fetched Gyms: $gyms");  // 데이터를 콘솔에 출력
    setState(() {
      _gyms = gyms;
    });
  }

  @override
  Widget build(BuildContext context) {
    int displayTrainerCount = _showAllTrainers
        ? _trainers.length
        : (_trainerShowMoreCount == 1
        ? 8
        : (_trainers.length > 4 ? 4 : _trainers.length));
    int displayGymCount = _gymShowMoreCount == 1
        ? (_gyms.length > 8 ? 8 : _gyms.length)
        : (_gyms.length > 6 ? 6 : _gyms.length);

    return Scaffold(
      backgroundColor: Colors.white,
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
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => NaverMapApp(
                              onAddressSelected: (newAddress, newDetailAddress) {
                                _updateAddress(newAddress, newDetailAddress);
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
                margin: EdgeInsets.only(top: 13, left: 30, right: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.userName.isEmpty ? '로그인을 하시면 맞춤 추천이 가능합니다!' : '${widget.userName} 님을 위한 추천 트레이너',
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600),
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
                            MaterialPageRoute(
                                builder: (context) => Search(
                                    userEmail: widget.userEmail,
                                    userName: widget.userName)),
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
                        MaterialPageRoute(
                            builder: (context) => Trainer(
                                trainerName: trainer['trainer_name'] ?? '',
                                gymName: trainer['gym_name'] ?? '무소속',
                                trainerEmail: trainer['trainer_email'] ?? '',
                                trainerPictureUrl: trainer['trainer_picture'], // 이 부분 추가
                                userEmail: widget.userEmail,
                                userName: widget.userName
                            )),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
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
                                  ? Image.network(
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
                                  Expanded( // Ensure the Text widget expands within the available space
                                    child: Text(
                                      trainer['trainer_intro'] ?? '바디프로필, 다이어트, 대회준비 전문',
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 13,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
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
                          MaterialPageRoute(
                            builder: (context) =>
                                RecommendTrainer(userName: widget.userName, userEmail: widget.userEmail,),
                          ),
                        );
                      }
                    });
                  },
                  child: Text('더보기'),
                ),
              // Recommended gyms section
              Container(
                margin: EdgeInsets.only(top: 30, left: 30, right: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.userName.isEmpty ? '로그인을 하시면 맞춤 추천이 가능합니다!' : '${widget.userName} 님을 위한 추천 헬스장',
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600),
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
                            MaterialPageRoute(
                              builder: (context) => Search2( userEmail: widget.userEmail),
                            ),
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
              GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.all(20),
                gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(
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
                        MaterialPageRoute(
                          builder: (context) => Info(userEmail: widget.userEmail, gymIdx: int.parse(gym['gym_idx'])),
                        ),
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
                                ? Image.network(
                              gym['gym_picture'],  // URL을 사용하여 이미지 로드
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
              if (_gyms.length > 6 && _gymShowMoreCount == 0)
                TextButton(
                  onPressed: () {
                    setState(() {
                      _gymShowMoreCount++;
                    });
                  },
                  child: Text('더보기'),
                ),
              if (_gyms.length > 8 && _gymShowMoreCount == 1)
                TextButton(
                  onPressed: () {
                    setState(() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              RecommendGym(userName: widget.userName, userEmail: widget.userEmail,),
                        ),
                      );
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
