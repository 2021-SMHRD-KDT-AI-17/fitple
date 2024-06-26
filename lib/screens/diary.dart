import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:fitple/screens/diary_2.dart';
import 'dart:convert';
import 'package:fitple/DB/LogDB.dart';
import 'package:fitple/Diary/diary_user.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:fitple/screens/login.dart'; // 로그인 화면 import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ko_KR', null); // 로케일 데이터를 초기화
  runApp(DiaryApp());
}

class DiaryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Diary(userName: '', userEmail: ''), // 여기에 테스트용 이메일을 넣으세요
    );
  }
}

class Diary extends StatefulWidget {
  final String userName;
  final String userEmail;
  const Diary({Key? key, required this.userName, required this.userEmail}) : super(key: key);

  @override
  State<Diary> createState() => _DiaryState();
}

class _DiaryState extends State<Diary> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();
  List<DateTime> _attendanceDays = [];
  List<Map<String, dynamic>> _logs = [];
  List<Map<String, dynamic>> _filteredLogs = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadData(); // 페이지가 다시 나타날 때 데이터를 새로 고침
  }

  Future<void> _loadData() async {
    await _loadAttendanceDays();
    await _loadLogs();
  }

  Future<void> _loadAttendanceDays() async {
    try {
      final attendanceDays = await loadAttendanceDays();
      setState(() {
        _attendanceDays = attendanceDays;
      });

      print('Attendance days: $_attendanceDays');
    } catch (e) {
      print('출석 체크 데이터 로드 실패: $e');
    }
  }

  Future<void> _loadLogs() async {
    try {
      final logs = await loadLogs();
      setState(() {
        _logs = logs;
        _filterLogsBySelectedDay(); // 초기화 시 필터링
      });
    } catch (e) {
      print('로그 데이터 로드 실패: $e');
    }
  }

  void _addAttendanceDay(DateTime day) {
    setState(() {
      if (!_attendanceDays.contains(day)) {
        _attendanceDays.add(day);
      }
      _filterLogsBySelectedDay();
    });
  }

  void _filterLogsBySelectedDay() {
    setState(() {
      if (_selectedDay != null) {
        _filteredLogs = _logs.where((log) {
          return isSameDay(log['log_date'], _selectedDay);
        }).toList();
      } else {
        _filteredLogs = [];
      }
    });
  }

  Future<void> _showEditDialog(BuildContext context, int logIdx, String initialText, String? initialImage) async {
    List<String> logTextList = initialText.split('\n');
    List<TextEditingController> controllers = logTextList.map((text) => TextEditingController(text: text)).toList();
    String? _newImageBase64 = initialImage;

    Future<void> _pickImage(StateSetter setState) async {
      try {
        final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          final bytes = await pickedFile.readAsBytes();
          setState(() {
            _newImageBase64 = base64Encode(bytes);
          });
        }
      } catch (e) {
        print('이미지를 선택할 수 없습니다: $e');
      }
    }

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('운동 기록 수정'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    ...controllers.map((controller) {
                      return TextField(
                        controller: controller,
                        decoration: InputDecoration(labelText: '운동 기록'),
                      );
                    }).toList(),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () => _pickImage(setState),
                      child: _newImageBase64 != null
                          ? Image.memory(base64Decode(_newImageBase64!), height: 100)
                          : Container(
                        height: 100,
                        color: Colors.grey[200],
                        child: Center(
                          child: Text('이미지를 선택하려면 여기를 누르세요'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('취소'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('저장'),
                  onPressed: () async {
                    String updatedLogText = controllers.map((controller) => controller.text).join('\n');
                    await updateLog(logIdx, updatedLogText, _newImageBase64);
                    Navigator.of(context).pop();
                    await _loadLogs(); // 수정 후 로그 데이터 새로 고침
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showLoginAlertDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('로그인이 필요합니다'),
          content: Text('이 기능을 사용하려면 로그인이 필요합니다'),
          actions: <Widget>[
            TextButton(
              child: Text('닫기'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('로그인'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  _filterLogsBySelectedDay();
                });
              },
              calendarStyle: CalendarStyle(
                outsideDaysVisible: false,
                todayTextStyle: TextStyle(color: Colors.black),
                todayDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.blueAccent, width: 1.5),
                ),
                selectedTextStyle: TextStyle(color: Colors.white),
                selectedDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blueAccent,
                ),
                markerDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
              ),
              locale: 'ko_KR',
              daysOfWeekHeight: 30,
              calendarFormat: CalendarFormat.month,
              availableCalendarFormats: const {
                CalendarFormat.month: '',
              },
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, date, _) {
                  return Center(
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                },
                markerBuilder: (context, date, events) {
                  final isAttendanceDay = _attendanceDays.any((attendanceDay) =>
                      isSameDay(attendanceDay, date));
                  if (isAttendanceDay) {
                    return Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                      width: 7.0,
                      height: 7.0,
                      margin: const EdgeInsets.symmetric(horizontal: 1.5),
                    );
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.only(left: 5),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedDay != null
                        ? DateFormat('MM월 dd일 (E)', 'ko_KR').format(_selectedDay!)
                        : '날짜를 선택해주세요',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                      letterSpacing: -0.34,
                    ),
                  ),

                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  if (widget.userName.isNotEmpty || widget.userEmail.isNotEmpty) {
                    if (_selectedDay != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Diary2(
                            selectedDay: _selectedDay!,
                            onAddAttendance: _addAttendanceDay,
                          ),
                        ),
                      ).then((_) => _loadData()); // Diary2에서 돌아온 후 데이터를 새로 고침
                    }
                  } else {
                    _showLoginAlertDialog(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12),
                  minimumSize: Size(400, 0),
                ),
                child: Text('오늘의 기록 추가하기',
                  style: TextStyle(fontWeight: FontWeight.w500),),
              ),
            ),
            SizedBox(height: 20),
            _buildLogsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildLogsList() {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _filteredLogs.length,
      itemBuilder: (context, index) {
        final log = _filteredLogs[index];
        final logIdx = log["log_idx"];
        final logDate = log["log_date"];
        final logText = log["log_text"];
        final logPicture = log["log_picture"] != null ? base64Decode(log["log_picture"]) : null;

        // 텍스트를 개행 문자로 나눔
        final logTextList = logText.split('\n');

        return Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('yyyy년 MM월 dd일').format(logDate),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          _showEditDialog(context, logIdx, logText, logPicture != null ? base64Encode(logPicture) : null);
                        },
                        icon: Icon(Icons.create),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                      ),
                      IconButton(
                        onPressed: () async {
                          await deleteLog(logIdx);
                          await _loadLogs(); // 삭제 후 로그 데이터 새로 고침
                        },
                        icon: Icon(Icons.delete),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
              Column(
                children: logTextList.map<Widget>((text) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: ShapeDecoration(
                      color: Color(0xCC285FEB),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      text,
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
              SizedBox(height: 10),
              if (logPicture != null) ...[
                Image.memory(logPicture),
              ],
            ],
          ),
        );
      },
    );
  }
}
