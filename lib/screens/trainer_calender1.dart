import 'package:fitple/screens/trainer_calender2.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:fitple/DB/TrainerLogDB.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ko_KR', null);
  runApp(MaterialApp(
    home: TrainerCalendar(trainer_email: ''),
  ));
}

class TrainerCalendar extends StatefulWidget {
  final String trainer_email;
  const TrainerCalendar({Key? key, required this.trainer_email}) : super(key: key);

  @override
  State<TrainerCalendar> createState() => _TrainerCalendarState();
}

class _TrainerCalendarState extends State<TrainerCalendar> {
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

  Future<void> _loadData() async {
    await _loadAttendanceDays();
    await _loadLogs();
  }

  Future<void> _loadAttendanceDays() async {
    try {
      final logs = await loadTrainerLogs();
      setState(() {
        _attendanceDays = logs.map((log) => log['trainer_log_date'] as DateTime).toList();
      });
    } catch (e) {
      print('출석 체크 데이터 로드 실패: $e');
    }
  }

  Future<void> _loadLogs() async {
    try {
      final logs = await loadTrainerLogs();
      setState(() {
        _logs = logs;
        _filterLogsBySelectedDay();
      });
    } catch (e) {
      print('로그 데이터 로드 실패: $e');
    }
  }

  void _filterLogsBySelectedDay() {
    setState(() {
      if (_selectedDay != null) {
        _filteredLogs = _logs.where((log) {
          return isSameDay(log['trainer_log_date'], _selectedDay);
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
      appBar: AppBar(
        title: Text('트레이너 일정 관리'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2050, 3, 14),
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
                  if (_selectedDay != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TrainerCalendar2(
                          selectedDay: _selectedDay!,
                        ),
                      ),
                    ).then((_) => _loadData());
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
                child: Text('오늘의 일정 추가하기'),
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
        final logDate = log['trainer_log_date'] as DateTime;
        final logText = log['trainer_log_text'];
        final logIdx = log['trainer_log_idx'];

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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      _showEditDialog(context, logIdx, logText);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      await deleteTrainerLog(logIdx);
                      await _loadLogs(); // 로그 삭제 후 데이터 새로 고침
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showEditDialog(BuildContext context, int logIdx, String initialText) async {
    TextEditingController _controller = TextEditingController(text: initialText);

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('일정 수정'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(labelText: '일정'),
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
                await updateTrainerLog(logIdx, _controller.text);
                Navigator.of(context).pop();
                await _loadLogs(); // 수정 후 데이터 새로 고침
              },
            ),
          ],
        );
      },
    );
  }
}