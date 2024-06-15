import 'package:fitple/screens/home_1.dart';
import 'package:fitple/screens/myreser.dart';
import 'package:fitple/screens/pay.dart';
import 'package:flutter/material.dart';
import 'package:fitple/DB/payDB.dart';

class PayCompeleted extends StatefulWidget {
  final String userEmail;
  final String trainerName;
  final String gymName;
  const PayCompeleted({super.key, required this.userEmail, required this.trainerName, required this.gymName});

  @override
  State<PayCompeleted> createState() => _PayCompeletedState();
}

class _PayCompeletedState extends State<PayCompeleted> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 50),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 65,
                    color: Colors.blueAccent,
                  ),
                  SizedBox(height: 10),
                  Text(
                    '결제완료',
                    style: TextStyle(color: Colors.black, fontSize: 22),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '거래번호 20240601201056',
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              width: double.infinity,
              height: 6,
              color: Colors.grey[200],
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 15),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CircleAvatar(
                            radius: 16,
                            backgroundImage:
                            AssetImage('assets/gym1.png'), // Local asset image
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          '${widget.gymName}',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    width: double.infinity,
                    height: 1,
                    color: Colors.grey[200],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10, left: 15, right: 15),
                    width: double.infinity,
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            'assets/train1.png',
                            fit: BoxFit.cover,
                            width: 70,
                            height: 70,
                          ),
                        ),
                        SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.trainerName} 트레이너',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 3),
                            Text(
                              '${widget.gymName}',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    width: double.infinity,
                    height: 1,
                    color: Colors.grey[200],
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.only(left: 15, top: 10, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '결제 금액',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '200,000원',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              width: double.infinity,
              height: 6,
              color: Colors.grey[200],
            ),
            Container(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(left: 15, top: 10),
                    child: Text(
                      '결제 내역',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    width: double.infinity,
                    height: 1,
                    color: Colors.grey[200],
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15, top: 10, right: 15),
                    child: Row(
                      children: [
                        Text('신용/체크 카드'),
                        Text('(BC카드/일시불)')
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15, top: 10, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('상품 금액'),
                        Text('200,000원')
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15, top: 10, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('결제 날짜'),
                        Text('2024.06.01 20:10:56')
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    width: double.infinity,
                    height: 6,
                    color: Colors.grey[200],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Home1(userName: '',userEmail: '',Check: '',), // null이면 빈 문자열 반환
                              ),);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: 130,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '홈으로',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyReser(userEmail: ''), // null이면 빈 문자열 반환
                              ),);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: 130,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '나의 PT 내역',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
