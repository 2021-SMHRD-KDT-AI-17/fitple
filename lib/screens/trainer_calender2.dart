import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:fitple/DB/LogDB.dart'; // LogDB.dart 파일을 import
import 'package:intl/intl.dart';

class TrainerCalender2 extends StatefulWidget {
  final DateTime selectedDay;
  final Function(DateTime) onAddAttendance;

  const TrainerCalender2(
      {Key? key, required this.selectedDay, required this.onAddAttendance})
      : super(key: key);

  @override
  State<TrainerCalender2> createState() => _TrainerCalender2State();
}

class _TrainerCalender2State extends State<TrainerCalender2> {
  File? _image;
  final List<String> _exerciseList = [];
  final TextEditingController _controller = TextEditingController();
  TimeOfDay? _selectedTime;
  String? _selectedPeriod = '오전';

  Future<void> _pickImage() async {
    try {
      final pickedFile =
      await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } catch (e) {
      print('이미지를 선택할 수 없습니다: $e');
    }
  }

  Future<void> _pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showDialog<TimeOfDay>(
      context: context,
      builder: (BuildContext context) {
        int selectedHour = TimeOfDay.now().hour % 12;
        int selectedMinute = TimeOfDay.now().minute;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                '시간 선택',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
              ),
              content: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        DropdownButton<String>(
                          value: _selectedPeriod,
                          underline: Container(),
                          items: <String>['오전', '오후'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value, style: TextStyle(fontSize: 20, color: Colors.black)),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedPeriod = value!;
                            });
                          },
                        ),
                        SizedBox(width: 10,),
                        DropdownButton<int>(
                          value: selectedHour + 1,
                          underline: Container(),
                          items: List.generate(12, (index) {
                            return DropdownMenuItem(
                              value: index + 1,
                              child: Text((index + 1).toString().padLeft(2, '0'), style: TextStyle(fontSize: 20, color: Colors.black)),
                            );
                          }),
                          onChanged: (value) {
                            setState(() {
                              selectedHour = value! - 1;
                            });
                          },
                        ),
                        Text(':', style: TextStyle(fontSize: 24, color: Colors.black)),
                        SizedBox(width: 10,),
                        DropdownButton<int>(
                          value: selectedMinute,
                          underline: Container(),
                          items: List.generate(60, (index) {
                            return DropdownMenuItem(
                              value: index,
                              child: Text(index.toString().padLeft(2, '0'), style: TextStyle(fontSize: 20, color: Colors.black)),
                            );
                          }),
                          onChanged: (value) {
                            setState(() {
                              selectedMinute = value!;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(TimeOfDay(
                          hour: _selectedPeriod == '오전'
                              ? selectedHour
                              : (selectedHour + 12) % 24 ,
                          minute: selectedMinute,
                        ));
                      },
                      child: Text('확인', style: TextStyle(fontSize: 15, color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _addExercise() {
    if (_controller.text.isNotEmpty && _selectedTime != null) {
      setState(() {
        final formattedTime = _selectedTime!.format(context);
        _exerciseList.add('${_controller.text} - $formattedTime');
        _controller.clear();
        _selectedTime = null;
      });
    }
  }

  Future<void> _sendDataToServer() async {
    try {
      await addLog(widget.selectedDay, _exerciseList, _image);
      widget.onAddAttendance(widget.selectedDay);
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
          width: 400,
          alignment: Alignment.center,
          margin: EdgeInsets.only(left: 30, top: 20),
          padding: EdgeInsets.only(bottom: 20),
          decoration: ShapeDecoration(
            color: Color(0xFFF5F5F5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 45),
              Container(
                margin: EdgeInsets.only(left: 20),
                child: Text(
                  DateFormat('yyyy년 MM월 dd일 (E)', 'ko_KR')
                      .format(widget.selectedDay),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 0.08,
                    letterSpacing: -0.34,
                  ),
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: '일정을 추가하세요',
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueAccent),
                        ),
                      ),
                    ),
                    ),
                    IconButton(
                      icon: Icon(Icons.access_time),
                      onPressed: () => _pickTime(context),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: _addExercise,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: 322,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _exerciseList.map((exercise) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: ShapeDecoration(
                        color: Color(0xCC285FEB),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        exercise,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
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
