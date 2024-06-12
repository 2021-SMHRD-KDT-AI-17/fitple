import 'package:fitple/screens/mypage.dart';
import 'package:fitple/screens/pay_history.dart';
import 'package:fitple/screens/review_write.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fitple/DB/payDB.dart';

class MyReser extends StatefulWidget {
  final String userEmail;
  const MyReser({super.key, required this.userEmail});

  @override
  State<MyReser> createState() => _MyReserState();
}

class _MyReserState extends State<MyReser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        // leading: IconButton(
        //   onPressed: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(builder: (context) => MyPage(userEmail: '',Check: '',)),
        //     );
        //   },
        //   icon: Icon(Icons.arrow_back_ios_new),
        //   iconSize: 20.0,
        // ),
        title: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            'PT 예약 내역',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: GestureDetector(
            onTap: () {},
            child: ListView.builder(
              itemCount: 1,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                  height: 180,
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black12, width: 2),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
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
                              //color: Colors.red,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'trainer_name적는곳', // 예시 텍스트
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    'gym_name적는곳', // 예시 텍스트
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 11, top: 5, right: 11),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'purchase_date적는곳',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'pt_price적는곳',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => PayHistory()),
                              );},
                              child: Container(
                                width: 140,
                                height: 35,
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(left: 20, top: 20),
                                decoration: BoxDecoration(
                                  color: Colors.blueAccent,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  '결제내역',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector( //ReviewWrite
                              onTap: () {Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ReviewWrite()),
                              );},
                              child: Container(
                                width: 140,
                                height: 35,
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(left: 10, top: 20),
                                decoration: BoxDecoration(
                                  color: Colors.blueAccent,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  '리뷰작성',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
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
        ),
      ),
    );
  }
}
