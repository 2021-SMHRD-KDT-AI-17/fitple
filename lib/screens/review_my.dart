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
              MaterialPageRoute(builder: (context) => MyPage(userEmail: '',Check: '',)),
            );
          },
          child: Icon(
            Icons.arrow_back_ios_new,
            size: 18,
          ),
        ),
        title: Text('My 리뷰'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {},
          child: ListView.builder(
            itemCount: 2,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(left: 20, top: 10, right: 20),
                width: double.infinity,
                // height: 364, // Fixed height removed
                decoration: ShapeDecoration(
                  color: Color(0x4CE0E0E0),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: Color(0xFFE0E0E0)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(left: 17, top: 15, right: 17),
                      child: Text(
                        '2023.06.15 20:07',
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(15),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey)),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              'assets/train1.png',
                              fit: BoxFit.cover,
                              width: 60,
                              height: 60,
                            ),
                          ),
                          SizedBox(width: 20),
                          Container(
                            // color: Colors.red,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '박성주 트레이너', // 예시 텍스트
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.black),
                                ),
                                Text(
                                  '육체미 첨단점', // 예시 텍스트
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 17, right: 17, bottom: 10),
                      child: Text(
                        '혼자 운동하다가 수업 받아보고 싶어서 후기 보고 박성주 선생님께 PT 10회 받았습니다! '
                            '자세는 물론 평소에 가지고 있었던 안 좋은 운동 습관도 잡아주시고 무엇보다 수업하면서 멘탈 관리 엄청 잘 해주십니다..'
                            ' 실제로 10만큼 할 수 있는데 스스로 6에서 한계 느낀다고 하면, 거기서 7 8 9 점점 더 나아가도록 이끌어주는 수업이었습니다. '
                            '인바디는 물론이고 몸을 보았을 때도 변화가 느껴지니 운동 의욕도 더 생겼네요 ',
                        style: TextStyle(fontSize: 13, color: Colors.black54),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
