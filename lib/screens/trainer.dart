import 'package:flutter/material.dart';
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
    required this.userName
  }) : super(key: key);

  @override
  _TrainerState createState() => _TrainerState();
}

class _TrainerState extends State<Trainer> {
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
      body: Column(
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
                                    child: widget.trainerPicture != null
                                        ? Image.memory(
                                      widget.trainerPicture,
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
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14),
                                      ),
                                      SizedBox(height: 5),
                                      Row(
                                        children: [
                                          TextButton(
                                            onPressed: () async {
                                              List<Map<String, dynamic>> reviews = await loadReviews();
                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => Review(reviews: reviews)),
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
                                                  '리뷰 보기',
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
                              '전) 팀라온 휘트니스 트레이너\n'
                                  '전) 대한보디빌딩 협회 소속 선수\n'
                                  '현) 육체미 첨단점 수석트레이너\n\n'
                                  '생활체육지도자 보디빌딩 2급\n'
                                  'NSCA-CPT (국제공인 퍼스널 트레이너)\n'
                                  '의료관리자 자격증\n'
                                  '응급처치 및 심폐소생술 CPR 교육수료\n\n'
                                  '2023 NPCA 전남 보디빌딩 퍼스트 2위\n'
                                  '2023 NPCA 세종 클래식피지크 입상\n'
                                  '2023 NPCA 세종 보디빌딩 -65kg 입상\n\n'
                                  '바디프로필, 다이어트, 대회준비 전문',
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
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('개인PT (1시간) 10회 + 헬스 :'),
                                Text('400,000원'),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('개인PT (1시간) 20회 + 헬스 :'),
                                Text('700,000원'),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('개인PT (1시간) 30회 + 헬스 :'),
                                Text('1,000,000원'),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('그룹PT - 상담 후 결정 :'),
                                Text('무료'),
                              ],
                            ),
                          ],
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Pay(
                            userName: '', // 필요한 경우 수정
                            userEmail: '', // 필요한 경우 수정
                            trainerEmail: widget.trainerEmail, // 추가된 부분
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
  final List<Map<String, dynamic>> reviews;

  Review({required this.reviews});

  @override
  _ReviewState createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('리뷰'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            for (var review in widget.reviews) ...[
              Center(
                child: Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  width: 470,
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(20),
                  decoration: ShapeDecoration(
                    color: Color(0xFFF5F5F5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review['text'],
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Container(),
                          ),
                          Text(
                            '${review['date']}    ${review['email']}',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 3),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
          ],
        ),
      ),
    );
  }
}