import 'package:fitple/bootpay/autopay.dart';
import 'package:fitple/bootpay/bootpay.dart';
import 'package:fitple/screens/home_1.dart';
import 'package:fitple/screens/pay_completed.dart';
import 'package:fitple/screens/trainer.dart';
import 'package:flutter/material.dart';

class Pay extends StatefulWidget {
  const Pay({super.key});

  @override
  State<Pay> createState() => _PayState();
}

class _PayState extends State<Pay> {
  String? selectPay = '카드 선택'; // 초기값 설정
  List<String> pay = ['카드 선택', 'BC카드', '국민은행', '광주은행', '카카오뱅크'];
  String? selectedMethod;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(
              context,
              MaterialPageRoute(
                builder: (context) => Trainer(),
              ),
            );
          },
          child: Icon(
            Icons.arrow_back_ios_new,
            size: 18,
          ),
        ),
        title: Text('결제 하기'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 70), // 하단 버튼의 높이만큼 패딩 추가
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(15),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Color(0x4CE0E0E0),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Color(0xFFE0E0E0))),
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
                margin: EdgeInsets.only(left: 15, right: 15,),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Color(0x4CE0E0E0),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Color(0xFFE0E0E0))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('개인 PT (1시간) 10회 + 헬스', style: TextStyle(fontWeight: FontWeight.bold),),
                    Text('400,000원', style: TextStyle(fontSize:15 ,fontWeight: FontWeight.bold),),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(left: 20, top: 20),
                child: Text('결제 수단 선택', style: TextStyle(fontSize:17 ,fontWeight: FontWeight.bold),),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.only(left: 17, right:17),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedMethod = '신용/체크 카드';
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 105,
                        height: 45,
                        decoration: BoxDecoration(
                          color: selectedMethod == '신용/체크 카드'
                              ? Colors.blueAccent
                              : Color(0x4CE0E0E0),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Color(0xFFE0E0E0)),
                        ),
                        child: Text(
                          '신용/체크 카드',
                          style: TextStyle(
                              color: selectedMethod == '신용/체크 카드'
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(width: 15),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedMethod = '카카오 페이';
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 105,
                        height: 45,
                        decoration: BoxDecoration(
                          color: selectedMethod == '카카오 페이'
                              ? Colors.blueAccent
                              : Color(0x4CE0E0E0),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Color(0xFFE0E0E0)),
                        ),
                        child: Text(
                          '카카오 페이',
                          style: TextStyle(
                              color: selectedMethod == '카카오 페이'
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(width: 15),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedMethod = '계좌이체';
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 105,
                        height: 45,
                        decoration: BoxDecoration(
                          color: selectedMethod == '계좌이체'
                              ? Colors.blueAccent
                              : Color(0x4CE0E0E0),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Color(0xFFE0E0E0)),
                        ),
                        child: Text(
                          '계좌이체',
                          style: TextStyle(
                              color: selectedMethod == '계좌이체'
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (selectedMethod == '신용/체크 카드') // '신용/체크 카드' 선택 시만 드롭다운 표시
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(left: 23, top: 20 ,right: 23),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                      color: Color(0x4CE0E0E0),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Color(0xFFE0E0E0))
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      style: TextStyle(color: Colors.grey[800],),
                      value: selectPay,
                      items: pay.map((value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectPay = value;
                        });
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TotalPayment(), // null이면 빈 문자열 반환
            ),);
        },
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: 60,
          color: Colors.blueAccent,
          child: Text(
            '400,000원 결제하기',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
