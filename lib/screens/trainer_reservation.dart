import 'package:fitple/DB/trainerDB.dart';
import 'package:flutter/material.dart';

class TrainReservation extends StatefulWidget {
  final String trainer_email;

  const TrainReservation({Key? key, required this.trainer_email}) : super(key: key);

  @override
  _TrainReservationState createState() => _TrainReservationState();
}

class _TrainReservationState extends State<TrainReservation> {
  late Future<List<Map<String, dynamic>>> _reservationFuture;

  @override
  void initState() {
    super.initState();
    _reservationFuture = purchaseList(widget.trainer_email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원 예약 관리'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _reservationFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('에러 발생: ${snapshot.error}'),
              );
            } else {
              List<Map<String, dynamic>> reservations = snapshot.data ?? [];
              return Container(
                width: double.infinity,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(0x4CE0E0E0),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Color(0xFFE0E0E0)),
                ),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '회원 예약 정보',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      for (var reservation in reservations)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10),
                            Text(
                              '회원 이메일 : ${reservation["user_email"]}',
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              '헬스장 : ${reservation["gym_name"]}',
                              style: TextStyle(fontSize: 15),
                            ),
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '상품명 : ${reservation["pt_name"]}',
                                  style: TextStyle(fontSize: 15),
                                ),
                                Text(
                                  '금액 : ${reservation["pt_price"]}',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '결제날짜 : ${reservation["purchase_date"]}',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                            Divider(),
                          ],
                        ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
