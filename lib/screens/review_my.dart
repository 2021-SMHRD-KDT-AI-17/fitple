import 'package:fitple/screens/mypage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(ReviewMyPage());
}


class ReviewMyPage extends StatefulWidget {
  @override
  _ReviewMyPageState createState() => _ReviewMyPageState();
}

class _ReviewMyPageState extends State<ReviewMyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyPage()),
            );
          },
          child: Icon(Icons.arrow_back_ios_new),
        ),
        title: Text('My 리뷰'),
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(top: 20, left: 70),
          width: 343,
          height: 364,
          decoration: ShapeDecoration(
            color: Color(0x4CE0E0E0),
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: Color(0xFFE0E0E0)),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 20,
                top: 173,
                child: SizedBox(
                  width: 304,
                  height: 360,
                  child: Text(
                    '혼자 운동하다가 수업 받아보고 싶어서 후기 보고 박성주 선생님께 PT 10회 받았습니다! 자세는 물론 평소에 가지고 있었던 안 좋은 운동 습관도 잡아주시고 무엇보다 수업하면서 멘탈 관리 엄청 잘 해주십니다.. 실제로 10만큼 할 수 있는데 스스로 6에서 한계 느낀다고 하면, 거기서 7 8 9 점점 더 나아가도록 이끌어주는 수업이었습니다. 인바디는 물론이고 몸을 보았을 때도 변화가 느껴지니 운동 의욕도 더 생겼네요 ',
                  ),
                ),
              ),
              Positioned(
                left: 9,
                top: 15,
                child: SizedBox(
                  width: 129,
                  height: 17,
                  child: Text(
                    '2023.06.15 20:07',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      height: 0.11,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 14,
                top: 31,
                child: Container(
                  width: 315,
                  height: 127,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 14,
                        child: Container(
                          width: 315,
                          height: 113,
                          decoration: ShapeDecoration(
                            color: Color(0xFFE8E8E8),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  width: 1, color: Color(0xFFD1D1D1)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 18,
                        top: 31,
                        child: Container(
                          width: 59,
                          height: 61,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 51,
                                height: 52,
                                clipBehavior: Clip.antiAlias,
                                decoration: ShapeDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        "https://via.placeholder.com/51x52"),
                                    fit: BoxFit.fill,
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 109,
                        top: 38,
                        child: Container(width: 105, height: 38),
                      ),
                      Positioned(
                        left: 84,
                        top: 40,
                        child: SizedBox(
                          width: 137,
                          child: Text(
                            '박성주 트레이너',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              height: 0.08,
                              letterSpacing: -0.30,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 84,
                        top: 62,
                        child: Text(
                          '육체미 첨단점',
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 0.12,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 18,
                        top: 98,
                        child: SizedBox(
                          width: 146,
                          child: Text(
                            '개인PT (1시간) 10회 + 헬스',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              height: 0.10,
                              letterSpacing: -0.24,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 239,
                        top: 96,
                        child: Text(
                          '400,000원',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            height: 0.12,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 54,
                        top: 0,
                        child: Container(width: 180, height: 18),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
