import 'package:fitple/screens/home_1.dart';
import 'package:fitple/screens/mypage.dart';
import 'package:fitple/screens/myreser.dart';
import 'package:fitple/DB/payDB.dart';
import 'package:flutter/material.dart';

class PayHistory extends StatefulWidget {
  final String userEmail;

  const PayHistory({super.key, required this.userEmail,});

  @override
  State<PayHistory> createState() => _PayHistoryState();
}

class _PayHistoryState extends State<PayHistory> {
  late Future<List<Map<String, dynamic>>> _payHistory;

  @override
  void initState() {
    super.initState();
    _payHistory = payList(widget.userEmail,);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(
              context,
              MaterialPageRoute(builder: (context) => MyPage(userEmail: widget.userEmail, Check: '',userName: '',)),
            );
          },
          icon: Icon(Icons.arrow_back_ios_new),
          iconSize: 20.0,
        ),
        title: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            '결제 내역',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white, // Set the background color of the entire body to white
        child: SafeArea(
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: _payHistory,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No payment history found.'));
              }

              final payHistory = snapshot.data!;

              return ListView.builder(
                itemCount: payHistory.length,
                itemBuilder: (context, index) {
                  final payDetail = payHistory[index];

                  return Container(
                    color: Colors.white, // Set the background color to white
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(top: 10),
                          padding: EdgeInsets.only(left: 15, right: 15),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '거래번호 20240601201056', // Replace with actual transaction ID if available
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
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
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        payDetail['gym_name'] ?? 'Gym Name',
                                        style: TextStyle(fontWeight: FontWeight.w600),
                                        overflow: TextOverflow.ellipsis,
                                      ),
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
                                margin: EdgeInsets.only(top: 10, left: 15, right: 15),
                                width: double.infinity,
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        payDetail['trainer_picture'],
                                        fit: BoxFit.cover,
                                        width: 70,
                                        height: 70,
                                      ),
                                    ),
                                    SizedBox(width: 15),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            payDetail['trainer_name'] ?? 'Trainer Name',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 3),
                                          Text(
                                            payDetail['pt_name'] ?? 'PT Name',
                                            style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 14,
                                            ),
                                            overflow: TextOverflow.ellipsis,
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
                                      payDetail['pt_price'] != null
                                          ? '${payDetail['pt_price']}원'
                                          : '',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
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
                                  overflow: TextOverflow.ellipsis,
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
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('상품 금액'),
                                    Text(payDetail['pt_price'] != null
                                        ? '${payDetail['pt_price']}원'
                                        : '')
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 15, top: 10, right: 15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('결제 날짜'),
                                    Text(payDetail['purchase_date'] ?? '')
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                width: double.infinity,
                                height: 6,
                                color: Colors.grey[200],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
