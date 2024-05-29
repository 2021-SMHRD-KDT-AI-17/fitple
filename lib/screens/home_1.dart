import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(const Home1());
}

class Home1 extends StatelessWidget {
  const Home1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'FITPLE',
          style: TextStyle(
            fontSize: 30,
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
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
                    Spacer(),
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
                  'Krystal 님을 위한 추천 트레이너',
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
                    onTap: () {},
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
                                'image/train1.png',
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
                  'Krystal 님을 위한 추천 헬스장',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(height: 10),
              // Expanded 사용하여 GridView가 남은 공간을 차지하게 함
              Container(
                height: 500, // GridView의 고정 높이 설정
                child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(), // GridView 스크롤 비활성화
                  padding: EdgeInsets.all(20),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 한 축에 들어갈 그리드 개수
                    mainAxisSpacing: 30, // 그리드의 위 아래 간격 조율
                    crossAxisSpacing: 5, // 그리드의 양 옆 간격 조율
                  ),
                  itemCount: 8, // 아이템 개수 지정
                  shrinkWrap: true, // GridView에 shrinkWrap 속성 추가
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 150,
                            margin: EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                'image/gym3.jpg',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity, // 높이도 꽉 채우도록 수정
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