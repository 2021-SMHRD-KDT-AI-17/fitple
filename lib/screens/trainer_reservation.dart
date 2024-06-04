import 'package:flutter/material.dart';

class TrainReservation extends StatefulWidget {
  const TrainReservation({super.key});

  @override
  State<TrainReservation> createState() => _TrainReservationState();
}

class _TrainReservationState extends State<TrainReservation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('회원 예약 관리'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
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
                  Text('회원이름 (회원 이메일)', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
                  Text('헬스장', style: TextStyle(fontSize: 15),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('상품명', style: TextStyle(fontSize: 15),),
                      Text('금액', style: TextStyle(fontSize: 15),),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('결제날짜', style: TextStyle(fontSize: 15),),
                      Text('2024.06.21', style: TextStyle(fontSize: 15),),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }
}
