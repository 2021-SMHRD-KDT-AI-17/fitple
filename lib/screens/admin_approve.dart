import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fitple/DB/adminDB.dart';

class AdminApprove extends StatefulWidget {
  final List<Map<String, dynamic>> trainerCheck;
  AdminApprove({required this.trainerCheck});

  @override
  State<AdminApprove> createState() => _AdminApproveState();
}

class _AdminApproveState extends State<AdminApprove> {
  List<Map<String, dynamic>> trainers = [];
  bool isLoading = true; // 데이터를 로딩 중인지 여부를 나타내는 변수

  @override
  void initState() {
    super.initState();
    trainers = widget.trainerCheck;
    fetchTrainers(); // 초기 데이터 로드
  }

  Future<void> fetchTrainers() async {
    try {
      List<Map<String, dynamic>> fetchedTrainers = await selectTrainerCheck();
      setState(() {
        trainers = fetchedTrainers;
        isLoading = false; // 데이터 로드 완료
      });
    } catch (e) {
      // 오류 처리
      setState(() {
        isLoading = false; // 오류 발생 시에도 로딩 상태 종료
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('트레이너 데이터를 가져오는 중 오류가 발생했습니다: $e')),
      );
    }
  }

  Future<void> approveTrainer(Map<String, dynamic> trainer) async {
    try {
      String? picturePath = trainer['trainer_picture'];
      File? pictureFile;

      if (picturePath != null && picturePath.isNotEmpty) {
        pictureFile = File(picturePath);
      } else {
        pictureFile = null;
      }

      await insertDelete(
        trainer['trainer_email'] ?? '', // 기본값 설정
        trainer['trainer_password'] ?? '', // 기본값 설정
        trainer['trainer_name'] ?? '', // 기본값 설정
        trainer['gender'] ?? '', // 기본값 설정
        trainer['age'] ?? '0', // 기본값 설정
        pictureFile, // 수정된 부분
        // trainer['trainer_check_picture'] ?? '', // 기본값 설정
      );

      setState(() {
        trainers.removeWhere((t) => t['trainer_email'] == trainer['trainer_email']);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${trainer['trainer_name']} 트레이너가 승인되었습니다.')),
      );
    } catch (e) {
      // 오류 처리
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('트레이너 승인 중 오류가 발생했습니다: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('승인 관리'),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : trainers.isEmpty
          ? Center(child: Text('승인 대기 중인 트레이너가 없습니다.'))
          : SingleChildScrollView(
        child: Column(
          children: trainers.map((trainer) {
            return Container(
              width: double.infinity,
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(0x4CE0E0E0),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Color(0xFFE0E0E0)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(trainer['trainer_email'], style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                        Text('${trainer['trainer_name']}'),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => approveTrainer(trainer), // 승인 기능 여기서 호출
                    child: Container(
                      width: 50,
                      height: 30,
                      margin: EdgeInsets.only(right: 15),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Text(
                        '승인',
                        style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                    ),
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
