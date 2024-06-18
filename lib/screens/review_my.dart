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
        backgroundColor: Colors.white, // Set AppBar background to white
        title: Text(
          'My 리뷰',
          style: TextStyle(color: Colors.black), // Set AppBar title color to black
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black), // Set AppBar icon color to black
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
              return Center(child: Text('작성 된 리뷰가 없습니다.'));
            } else {
              // Sort reviews by date in descending order
              List<Map<String, dynamic>> sortedReviews = snapshot.data!;
              sortedReviews.sort((a, b) {
                DateTime dateA = DateTime.parse(a['date']);
                DateTime dateB = DateTime.parse(b['date']);
                return dateB.compareTo(dateA);
              });

              return ListView.builder(
                itemCount: sortedReviews.length,
                itemBuilder: (context, index) {
                  final review = sortedReviews[index];
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
                                child: Image.network(
                                  review['trainerPicture'],
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
                                      review['trainerName'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.black),
                                    ),
                                    Text(
                                      review['gymName'],
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
