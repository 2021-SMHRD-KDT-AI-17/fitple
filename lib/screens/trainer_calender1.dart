import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:fitple/screens/diary_2.dart';
import 'dart:convert';
import 'package:fitple/DB/LogDB.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ko_KR', null);
  runApp(const TrainerCalender());
}


class TrainerCalender extends StatefulWidget {
  const TrainerCalender({Key? key}) : super(key: key);

  @override
  State<TrainerCalender> createState() => _TrainerCalenderState();
}

class _TrainerCalenderState extends State<TrainerCalender> {
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
                  Container(
                    width: 100,
                    height: 48,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(70),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(onPressed: () {}, icon: Icon(Icons.calendar_month)),
                        IconButton(onPressed: () {}, icon: Icon(Icons.list))
                      ],
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
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.grey[100],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12),
                  minimumSize: Size(400, 0),
                ),
                child: Text('오늘의 기록 추가하기'),
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
        final logDate = log["log_date"];
        final logText = log["log_text"];
        final logPicture = log["log_picture"];

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('yyyy년 MM월 dd일').format(logDate),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(logText),
              SizedBox(height: 10),
              if (logPicture != null) ...[
                Image.memory(base64Decode(logPicture)),
              ],
            ],
          ),
        );
      },
    );
  }
}