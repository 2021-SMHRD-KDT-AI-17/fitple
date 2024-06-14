import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fitple/DB/chatDB.dart';
import 'package:fitple/DB/trainerDB.dart';
import 'package:fitple/screens/chat_tr.dart';
import 'package:fitple/screens/pay.dart';
import 'package:fitple/DB/reviewDB.dart';

class Trainer extends StatefulWidget {
  final String trainerName;
  final String gymName;
  final String trainerEmail;
  final dynamic trainerPicture;
  final String userEmail;
  final String userName;


  const Trainer({
    Key? key,
    required this.trainerName,
    required this.gymName,
    required this.trainerEmail,
    this.trainerPicture,
    required this.userEmail,
    required this.userName,

  }) : super(key: key);

  @override
  _TrainerState createState() => _TrainerState();
}

class _TrainerState extends State<Trainer> {
  Map<String, dynamic>? _trainerInfo;
  List<Map<String, dynamic>> _trainerItems = [];
  int _reviewCount = 0;
  bool _isLoading = true;
  Uint8List? _imageBytes; // 추가: 이미지 바이트 데이터

  @override
  void initState() {
    super.initState();
    _loadTrainerInfo();
    _loadTrainerItems();
    _loadReviewCount();
    _getImageBytes(); // 이미지 바이트 데이터 로드
  }

  Future<void> _loadTrainerInfo() async {
    try {
      final trainerInfo = await trainerselect(widget.trainerEmail);
      setState(() {
        _trainerInfo = trainerInfo;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _loadTrainerItems() async {
    try {
      final trainerItems = await loadTrainerItems(widget.trainerEmail);
      setState(() {
        _trainerItems = trainerItems;
        _isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadReviewCount() async {
    try {
      final reviewCount = await getTrainerReviewCount(widget.trainerEmail);
      setState(() {
        _reviewCount = reviewCount;
      });
    } catch (e) {
      print(e);
    }
  }

  // 이미지 데이터 로드 메서드
  Future<void> _getImageBytes() async {
    if (widget.trainerPicture != null && widget.trainerPicture is String) {
      try {
        _imageBytes = base64Decode(widget.trainerPicture); // Base64 디코딩
        setState(() {});
      } catch (e) {
        print("Error decoding image: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(widget.trainerName),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(bottom: 80),
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        width: 470,
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: _imageBytes != null
                                        ? Image.memory(
                                      _imageBytes!, // 이미지 바이트 데이터 사용
                                      fit: BoxFit.cover,
                                    )
                                        : Image.asset(
                                      'assets/train3.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.trainerName,
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        widget.gymName,
                                        style: TextStyle(color: Colors.black, fontSize: 14),
                                      ),
                                      SizedBox(height: 5),
                                      Row(
                                        children: [
                                          TextButton(
                                            onPressed: () async {
                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => Review(trainerEmail: widget.trainerEmail),
                                                ),
                                              );
                                            },
                                            style: TextButton.styleFrom(
                                              minimumSize: Size.zero,
                                              padding: EdgeInsets.zero,
                                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  '리뷰 보기 ($_reviewCount)',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                SizedBox(width: 5),
                                                Icon(
                                                  size: 15,
                                                  Icons.navigate_next,
                                                  color: Colors.black,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 30),
                            Text(
                              _trainerInfo?['trainerInfo'] ?? '정보를 불러올 수 없습니다.',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Container(
                        width: 470,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: _trainerItems.map((item) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(item['pt_name']),
                                  Text('${item['pt_price']}원'),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      room_num(widget.userEmail, widget.trainerEmail);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatTr(
                            userName: widget.userName,
                            receiveEmail: widget.userEmail,
                            userEmail: widget.userEmail,
                            sendNick: widget.trainerName,
                            sendEmail: widget.trainerEmail,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blueAccent,
                      ),
                      child: Text(
                        '채팅하기',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (_trainerInfo != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Pay(
                              userName: widget.userName,
                              userEmail: widget.userEmail,
                              trainerEmail: widget.trainerEmail,
                              gymIdx: int.parse(_trainerInfo!['gymIdx'].toString()),
                            ),
                          ),
                        );
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blueAccent,
                      ),
                      child: Text(
                        '결제하기',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class Review extends StatefulWidget {
  final String trainerEmail;

  Review({required this.trainerEmail});

  @override
  _ReviewState createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  List<Map<String, dynamic>> _reviews = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    try {
      final reviews = await loadTrainerReviews(widget.trainerEmail);
      setState(() {
        _reviews = reviews;
        _isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('리뷰'),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: _reviews.map((review) {
            return Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review['trainer_review_text'] ?? '리뷰 내용 없음',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        review['trainer_review_date'] ?? '날짜 없음',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        review['user_nick'] ?? '사용자 없음',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}