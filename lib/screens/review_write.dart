import 'package:fitple/DB/reviewDB.dart';
import 'package:fitple/screens/myreser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fitple/Diary/diary_user.dart'; // diaryuser를 사용하기 위해 import

class ReviewWrite extends StatefulWidget {
  final String trainer_email;
  final String trainer_name;
  final String gym_name;
  final String pt_name;
  const ReviewWrite({
    super.key,
    required this.trainer_email,
    required this.trainer_name,
    required this.gym_name,
    required this.pt_name,
  });

  @override
  State<ReviewWrite> createState() => _ReviewWriteState();
}

class _ReviewWriteState extends State<ReviewWrite> {
  final reviewCon = TextEditingController();
  final review2Con = TextEditingController();
  double rating = 0;
  double rating2 = 0;
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
    review2Con.dispose();
    super.dispose();
  }

  void rewriteValue() {
    print('Second text field: ${reviewCon.text}');
  }

  Future<void> insertGymReview(
      String user_email,
      String gym_review_text,
      int gym_review_rate,
      int gym_idx) async {
    final conn = await dbConnector();

    try {
      var result = await conn.execute(
        "INSERT INTO fit_gym_review(gym_review_idx, user_email, gym_review_text, gym_review_rate, gym_review_date, gym_idx, is_processed) VALUES (NULL, :user_email, :gym_review_text, :gym_review_rate, NOW(), :gym_idx, false)",
        {
          'user_email': user_email,
          'gym_review_text': gym_review_text,
          'gym_review_rate': gym_review_rate,
          'gym_idx': gym_idx,
        },
      );

      if (result.affectedRows! > BigInt.from(0)) {
        print("Review inserted successfully!");
      } else {
        print("Failed to insert review.");
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      await conn.close();
    }
    print('DB 연결 성공!');
  }

  void submitReview() async {
    if (userEmail == null) {
      print('User email not available');
      return;
    }

    await insertTrainerReview(
      userEmail!,
      reviewCon.text,
      rating.toInt(),
      widget.trainer_email,
    );

    await insertGymReview(
      userEmail!,
      review2Con.text,
      rating2.toInt(),
      1, // gym_idx 값을 실제 값으로 변경해야 합니다.
    );

    print("Review submitted");
    // 리뷰 등록 후 MyReser 페이지로 이동
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyReser(userEmail: userEmail!)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
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
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
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
                            widget.trainer_name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black),
                          ),
                          Text(
                            widget.gym_name,
                            style: TextStyle(
                                fontSize: 13, color: Colors.black54),
                          ),
                          Text(
                            widget.pt_name,
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
                        '트레이너는 어떠셨나요?',
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
                        itemBuilder: (context, _) =>
                            Icon(Icons.star, color: Colors.blueAccent),
                        onRatingUpdate: (rating) =>
                            setState(() {
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
                        '트레이너 리뷰 작성',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: reviewCon,
                        // 컨트롤러 연결
                        onChanged: (text) {
                          setState(() {
                            //reviewCon = reviewCon(text, text);
                          });
                        },
                        maxLength: 1500,
                        // 최대 글자수
                        maxLines: 8,
                        // field 칸
                        textInputAction: TextInputAction.done,
                        // 키보드
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
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      Text(
                        '헬스장은 어떠셨나요?',
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
                        itemBuilder: (context, _) =>
                            Icon(Icons.star, color: Colors.blueAccent),
                        onRatingUpdate: (rating) =>
                            setState(() {
                              this.rating2 = rating;
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
                        '헬스장 리뷰 작성',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: review2Con,
                        // 컨트롤러 연결
                        onChanged: (text) {
                          setState(() {
                            //reviewCon = reviewCon(text, text);
                          });
                        },
                        maxLength: 1500,
                        // 최대 글자수
                        maxLines: 8,
                        // field 칸
                        textInputAction: TextInputAction.done,
                        // 키보드
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
