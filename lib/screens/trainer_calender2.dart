import 'package:flutter/material.dart';
import 'package:fitple/DB/TrainerLogDB.dart';
import 'package:intl/intl.dart';

class TrainerCalendar2 extends StatefulWidget {
  final DateTime selectedDay;

  const TrainerCalendar2({Key? key, required this.selectedDay}) : super(key: key);

  @override
  State<TrainerCalendar2> createState() => _TrainerCalendar2State();
}

class _TrainerCalendar2State extends State<TrainerCalendar2> {
  final List<String> _exerciseList = [];
  final TextEditingController _controller = TextEditingController();

  void _addExercise() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _exerciseList.add(_controller.text);
        _controller.clear();
      });
    }
  }

  Future<void> _sendDataToServer() async {
    try {
      await addTrainerLog(widget.selectedDay, _exerciseList);
    } catch (e) {
      print('일정 추가 실패: $e');
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
        title: Text('일정 등록'),
        actions: [
          TextButton(
            onPressed: () async {
              await _sendDataToServer();
              Navigator.pop(context);
            },
            child: Text(
              '완료',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.all(20),
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
                DateFormat('yyyy년 MM월 dd일 (E)', 'ko_KR').format(widget.selectedDay),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: '운동을 입력하세요',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: _addExercise,
                  ),
                ],
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                child: Column(
                  children: _exerciseList.map((exercise) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        exercise,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}