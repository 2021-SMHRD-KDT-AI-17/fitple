import 'package:fitple/DB/reviewDB.dart';
import 'package:fitple/screens/myreser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fitple/Diary/diary_user.dart'; // diaryuser를 사용하기 위해 import

class ReviewWrite extends StatefulWidget {
  const ReviewWrite({super.key});

  @override
  State<ReviewWrite> createState() => _ReviewWriteState();
}

class _ReviewWriteState extends State<ReviewWrite> {
  final reviewCon = TextEditingController();
  double rating = 0;
  String? userEmail;

  @override
  void initState() {
    super.initState();
    reviewCon.addListener(rewriteValue);
    userEmail = diaryuser().userEmail; // 현재 로그인한 사용자의 이메일을 가져옴
  }

  @override
  void dispose() {
    reviewCon.dispose();
    super.dispose();
  }

  void rewriteValue() {
    print('Second text field: ${reviewCon.text}');
  }

  void submitReview() async {
    if (userEmail == null) {
      print('User email not available');
      return;
    }

    await insertReview(
        userEmail!,
        reviewCon.text,
        rating.toInt(),
        'teacher' // 트레이너 이메일 값 넣어야함 수정하세요 - 상윤
    );
    print("Review submitted");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyReser()),
            );
          },
          icon: Icon(Icons.arrow_back_ios_new),
          iconSize: 20.0,
        ),
        title: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            '리뷰 작성',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '박성주 트레이너',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black),
                        ),
                        Text(
                          '육체미 첨단점',
                          style: TextStyle(
                              fontSize: 13, color: Colors.black54),
                        ),
                        Text(
                          '개인 PT (1시간) 10회 + 헬스',
                          style: TextStyle(
                              fontSize: 13, color: Colors.black54),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 5,
                color: Colors.grey[200],
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Column(
                  children: [
                    Text(
                      '별점',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    RatingBar.builder(
                      minRating: 1,
                      itemSize: 38,
                      itemPadding: EdgeInsets.symmetric(horizontal: 2),
                      itemBuilder: (context, _) => Icon(Icons.star, color: Colors.blueAccent),
                      onRatingUpdate: (rating) => setState(() {
                        this.rating = rating;
                      }),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15),
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '리뷰 작성',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: reviewCon, // 컨트롤러 연결
                      onChanged: (text) {
                        setState(() {
                          //reviewCon = reviewCon(text, text);
                        });
                      },
                      maxLength: 1500, // 최대 글자수
                      maxLines: 8, // field 칸
                      textInputAction: TextInputAction.done, // 키보드
                      onFieldSubmitted: (String value) {
                        print('value');
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(), // 사각형 모양 border
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                      style: TextStyle( // 입력되는 텍스트 style
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: submitReview,
        child: Container(
          alignment: Alignment.center,
          height: 50,
          color: Colors.blueAccent,
          child: Text(
            '리뷰 등록 하기',
            style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}