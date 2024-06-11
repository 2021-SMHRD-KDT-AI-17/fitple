import 'package:flutter/material.dart';
import 'package:fitple/screens/trainer.dart';
import 'package:fitple/DB/trainerDB.dart';

class RecommendTrainer extends StatefulWidget {
  final String userName;
  final String userEmail;
  const RecommendTrainer({super.key, required this.userName,required this.userEmail});

  @override
  State<RecommendTrainer> createState() => _RecommendTrainerState();
}

class _RecommendTrainerState extends State<RecommendTrainer> {
  List<Map<String, dynamic>> _trainers = []; // 트레이너 데이터를 저장할 리스트

  @override
  void initState() {
    super.initState();
    fetchTrainers(); // 트레이너 데이터를 가져오는 함수 호출
  }

  // 트레이너 데이터를 가져오는 함수
  void fetchTrainers() async {
    List<Map<String, dynamic>> trainers = await loadTrainersWithGym();
    setState(() {
      _trainers = trainers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.userName}님을 위한 추천 트레이너',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _trainers.length,
            itemBuilder: (context, index) {
              var trainer = _trainers[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Trainer(
                        userEmail: widget.userEmail,
                        trainerName: trainer['trainer_name'] ?? '',
                        gymName: trainer['gym_name'] ?? '무소속',
                        trainerPicture: trainer['trainer_picture'],
                        trainerEmail: trainer['trainer_email'] ?? '',
                        userName: widget.userName,
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blueAccent, width: 2),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: trainer['trainer_picture'] != null
                              ? Image.memory(
                            trainer['trainer_picture'],
                            fit: BoxFit.cover,
                            width: 70,
                            height: 70,
                          )
                              : Image.asset(
                            'assets/train1.png',
                            fit: BoxFit.cover,
                            width: 70,
                            height: 70,
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: Container(
                          height: 80,
                          alignment: Alignment.topLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                trainer['trainer_name'] ?? '',
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                trainer['gym_name'] ?? '무소속',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                '바디프로필, 다이어트, 대회준비 전문',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 13,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
