import 'package:fitple/bootpay/bootpay.dart';
import 'package:fitple/screens/home_1.dart';
import 'package:fitple/screens/pay_completed.dart';
import 'package:fitple/screens/trainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fitple/DB/payDB.dart';

class Pay extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String trainerEmail; // 추가된 부분

  const Pay({super.key, required this.userName, required this.userEmail, required this.trainerEmail}); // 수정된 부분

  @override
  State<Pay> createState() => _PayState();
}

class _PayState extends State<Pay> {
  String? selectGoods = '상품 선택'; // 초기값 설정
  List<Map<String, dynamic>> goods = [{'pt_name': '상품 선택', 'pt_price': 0}];
  String amount = '0';

  String? selectPay = '카드 선택'; // 초기값 설정
  List<String> pay = ['카드 선택', 'BC카드', '국민은행', '광주은행', '카카오뱅크'];
  String? selectedMethod;

  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  void fetchItems() async {
    List<Map<String, dynamic>> items = await loadItem(widget.trainerEmail); // 수정된 부분
    setState(() {
      goods = [{'pt_name': '상품 선택', 'pt_price': 0}];
      goods.addAll(items);
    });
  }

  void updateAmount(String? selectedGoods) {
    var selectedItem = goods.firstWhere((item) => item['pt_name'] == selectedGoods, orElse: () => {'pt_price': 0});
    amount = selectedItem['pt_price'].toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(
              context,
              MaterialPageRoute(
                builder: (context) => Trainer(
                  userEmail: widget.userEmail,
                  trainerName: '트레이너 이름', // 필요한 경우 수정
                  gymName: '헬스장 이름', // 필요한 경우 수정
                  trainerEmail: widget.trainerEmail, // 수정된 부분
                  trainerPicture: null, // 필요한 경우 수정
                  userName: widget.userName,
                ),
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
                width: double.infinity,
                margin: EdgeInsets.only(left: 15 ,right: 15),
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                    color: Color(0x4CE0E0E0),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Color(0xFFE0E0E0))
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    style: TextStyle(color: Colors.grey[800],),
                    value: selectGoods,
                    items: goods.map((value) {
                      return DropdownMenuItem<String>(
                        value: value['pt_name'].toString(),
                        child: Text(value['pt_name'].toString()),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectGoods = value;
                        updateAmount(value); // update the amount based on selected goods
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
          var selectedItem = goods.firstWhere((item) => item['pt_name'] == selectGoods);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TotalPayment(
                item: selectedItem, userEmail: '', userName: '', // 선택된 상품 정보를 전달
              ),
            ),
          );
        },
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: 60,
          color: Colors.blueAccent,
          child: Text(
            '${amount}원 결제하기',
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