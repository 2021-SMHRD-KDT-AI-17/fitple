import 'package:flutter/material.dart';
import 'package:fitple/DB/payDB.dart';
import 'package:fitple/screens/trainer.dart';

import '../bootpay/bootpay.dart';

class Pay extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String trainerEmail;
  final String trainerName;
  final String gymName;
  final int gymIdx;
  final String? trainerPictureUrl;

  const Pay({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.trainerEmail,
    required this.gymIdx,
    required this.trainerName,
    required this.gymName,
    required this.trainerPictureUrl,
  });

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
    List<Map<String, dynamic>> items = await PayDB.loadItem(widget.trainerEmail);
    setState(() {
      goods = [{'pt_name': '상품 선택', 'pt_price': 0}];
      goods.addAll(items);
    });
  }

  void updateAmount(String? selectedGoods) {
    var selectedItem = goods.firstWhere(
          (item) => item['pt_name'] == selectedGoods,
      orElse: () => {'pt_price': 0},
    );
    setState(() {
      amount = selectedItem['pt_price'].toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Trainer Picture URL in Pay: ${widget.trainerPictureUrl}'); // URL 로그 출력
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(
              context,
              MaterialPageRoute(
                builder: (context) => Trainer(
                  userEmail: widget.userEmail,
                  trainerName: widget.trainerName,
                  gymName: widget.gymName,
                  trainerEmail: widget.trainerEmail,
                  trainerPictureUrl: widget.trainerPictureUrl,
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
                  border: Border.all(color: Color(0xFFE0E0E0)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: widget.trainerPictureUrl != null
                            ? Image.network(
                          widget.trainerPictureUrl!, // 이미지 URL 사용
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/train3.png',
                              fit: BoxFit.cover,
                            );
                          },
                        )
                            : Image.asset(
                          'assets/train3.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${widget.trainerName}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            '${widget.gymName}',
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
                width: double.infinity,
                margin: EdgeInsets.only(left: 15, right: 15),
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Color(0x4CE0E0E0),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Color(0xFFE0E0E0)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    style: TextStyle(color: Colors.grey[800]),
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
                        updateAmount(value);
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
                item: selectedItem,
                userEmail: widget.userEmail,
                userName: widget.userName,
                gymIdx: widget.gymIdx,
                gymName: widget.gymName,
                trainerName: widget.trainerName,
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