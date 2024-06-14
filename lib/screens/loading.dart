import 'package:fitple/screens/home_1.dart';
import 'package:flutter/material.dart';
import 'package:fitple/screens/first.dart';
import 'package:fitple/screens/join.dart';
import 'package:fitple/screens/login.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Loading(),
    );
  }
}

class Loading extends StatefulWidget {
  Loading({Key? key}) : super(key: key);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: 0);

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    Future.delayed(Duration(seconds: 2), () {
      _animationController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            children: [
              // 첫 번째 페이지
              Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.white,
                child: Stack(
                  children: [
                    Positioned(
                      top: 350, // Adjusted top position
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 30),
                          child: const Text(
                            'FITPLE',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 88,
                              fontFamily: 'Kanit',
                              fontWeight: FontWeight.w900,
                              height: 0.9,
                              letterSpacing: -0.66,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 350,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'FITPLE에 오신 것을 환영합니다!\n로그인 또는 가입을 하시면\nFITPLE과 함께한 운동을 모두 확인하실 수 있습니다.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 170,
                      left: 250,
                      right: 0,
                      child: Center(
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> Home1(userName: '', userEmail: '', Check: '')));
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                '건너뛰기 >>',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // 두 번째 페이지
              Container(
                color: Colors.white70,
                child: Stack(
                  children: [
                    Positioned(
                      top: 200, // 이미지 위치를 위로 조정
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Image.asset(
                          'assets/home.png',
                          width: 350,
                          height: 400,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 200,
                      left: 0,
                      right: 0,
                      child: Container(
                        color: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Center(
                          child: Column(
                            children: [
                              Text(
                                '트레이너 추천',
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '나의 첫 운동, 첫 PT \n 개인화된 추천, \n  나만을 위한 트레이너와 함께 시작하세요'
                                    , textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // 세 번째 페이지
              Container(
                color: Colors.white70,
                child: Stack(
                  children: [
                    Positioned(
                      top: 200, // 이미지 위치를 위로 조정
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Image.asset(
                          'assets/calendar.png',
                          width: 350,
                          height: 400,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 200,
                      left: 0,
                      right: 0,
                      child: Container(
                        color: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Center(
                          child: Column(
                            children: [
                              Text(
                                '운동 일기',
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '모든 운동의 매 순간이 \n 기록으로 남겨집니다. \n FITPLE과 함께 기록해보세요 !'
                                , textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // 네 번째 페이지
              Stack(
                children: [
                  Container(
                    color: Colors.white,
                    child: Center(
                      child: Text(
                        'FITPLE',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 88,
                          fontFamily: 'Kanit',
                          fontWeight: FontWeight.w900,
                          height: 0.9,
                          letterSpacing: -0.66,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: FadeTransition(
                        opacity: _opacityAnimation,
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => First(),
                                    ),
                                  );
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.blueAccent,
                                  ),
                                  child: const Text(
                                    '가입하기',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Login(),
                                    ),
                                  );
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.blueAccent,
                                  ),
                                  child: const Text(
                                    '로그인',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Center(
              child: FadeTransition(
                opacity: _opacityAnimation,
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: 4, // 페이지 수를 4로 수정
                  effect: WormEffect(
                    dotColor: Colors.grey,
                    activeDotColor: Colors.black,
                    dotHeight: 12,
                    dotWidth: 12,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}
