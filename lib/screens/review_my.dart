import 'package:fitple/DB/reviewDB.dart';
import 'package:flutter/material.dart';

class ReviewMyPage extends StatefulWidget {
  final String userEmail;

  ReviewMyPage({required this.userEmail});

  @override
  _ReviewMyPageState createState() => _ReviewMyPageState();
}

class _ReviewMyPageState extends State<ReviewMyPage> {
  Future<List<Map<String, dynamic>>>? _reviews;

  @override
  void initState() {
    super.initState();
    _reviews = loadReviews(widget.userEmail);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('My 리뷰'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _reviews,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No reviews found.'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final review = snapshot.data![index];
                  return Container(
                    margin: EdgeInsets.only(left: 20, top: 10, right: 20),
                    decoration: ShapeDecoration(
                      color: Color(0x4CE0E0E0),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 1, color: Color(0xFFE0E0E0)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(left: 17, top: 15, right: 17),
                          child: Text(
                            review['date'],
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(15),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey)),
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
                          margin: EdgeInsets.only(left: 17, right: 17, bottom: 10),
                          child: Text(
                            review['text'],
                            style: TextStyle(fontSize: 13, color: Colors.black54),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}