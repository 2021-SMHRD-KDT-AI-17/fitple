import 'package:fitple/DB/DB.dart';
import 'package:fitple/screens/mypage.dart';
import 'package:fitple/screens/pay_history.dart';
import 'package:fitple/screens/review_write.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fitple/DB/payDB.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class MyReser extends StatefulWidget {
  final String userEmail;

  const MyReser({super.key, required this.userEmail});

  @override
  State<MyReser> createState() => _MyReserState();
}

class _MyReserState extends State<MyReser> {
  late Future<List<Map<String, dynamic>>> _reservationList;

  @override
  void initState() {
    super.initState();
    _reservationList = payList(widget.userEmail);
  }

  Future<String?> _getImageUrlFromFirebase(String? trainername) async {
    if (trainername == null || trainername.isEmpty) {
      return null;
    }
    try {
      final conn = await dbConnector();
      final result = await conn.execute(
        'SELECT trainer_picture FROM fit_trainer WHERE trainer_name = :trainer_name',
        {'trainer_name': trainername},
      );
      await conn.close();

      if (result.rows.isNotEmpty) {
        final imagePath = result.rows.first.colByName('trainer_picture');
        if (imagePath != null) {
          final ref = firebase_storage.FirebaseStorage.instance.refFromURL(imagePath);
          return await ref.getDownloadURL();
        }
      }
      return null;
    } catch (e) {
      print("Error getting image URL from Firebase: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
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
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _reservationList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('결제한 내역이 없습니다.'));
            }

            final reservations = snapshot.data!;
            return SingleChildScrollView(
              child: ListView.builder(
                itemCount: reservations.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final reservation = reservations[index];
                  return FutureBuilder<String?>(
                    future: _getImageUrlFromFirebase(reservation['trainer_name']),
                    builder: (context, snapshot) {
                      final imageUrl = snapshot.data;
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
                                    child: imageUrl != null
                                        ? Image.network(
                                      imageUrl,
                                      fit: BoxFit.cover,
                                      width: 60,
                                      height: 60,
                                    )
                                        : Image.asset(
                                      'assets/train1.png',
                                      fit: BoxFit.cover,
                                      width: 60,
                                      height: 60,
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          reservation['trainer_name'] ?? '',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          reservation['gym_name'] ?? '',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.black54,
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
                              margin: EdgeInsets.only(left: 11, top: 5, right: 11),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    reservation['purchase_date'] ?? '',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    reservation['pt_price'] != null
                                        ? '${reservation['pt_price']}원'
                                        : '',
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
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PayHistory(userEmail: widget.userEmail),
                                        ),
                                      );
                                    },
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
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ReviewWrite(
                                            trainer_email: reservation['trainer_email'],
                                            trainer_name: reservation['trainer_name'],
                                            gym_name: reservation['gym_name'],
                                            pt_name: reservation['pt_name'],
                                          ),
                                        ),
                                      );
                                    },
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
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}