import 'package:mysql_client/mysql_client.dart';
import 'package:fitple/Diary/diary_user.dart';
import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';

// 데이터베이스 연결 함수
Future<MySQLConnection> dbConnector() async {
  print("Connecting to mysql server...");

  final conn = await MySQLConnection.createConnection(
    host: 'project-db-cgi.smhrd.com',
    port: 3307,
    userName: 'wldhz',
    password: '126',
    databaseName: 'wldhz',
  );

  await conn.connect();

  print("Connected");

  return conn;
}

// 출석 체크 날짜 로드 함수
Future<List<DateTime>> loadAttendanceDays() async {
  final userEmail = diaryuser().userEmail;

  if (userEmail == null) {
    print('User email not available');
    return [];
  }

  final conn = await dbConnector();

  final query = """
    SELECT log_date FROM fit_log WHERE user_email = :user_email
  """;

  final results = await conn.execute(query, {'user_email': userEmail});
  await conn.close();

  return results.rows.map((row) => DateTime.parse(row.colAt(0) as String)).toList();
}

// 운동 기록 로드 함수
Future<List<Map<String, dynamic>>> loadLogs() async {
  final userEmail = diaryuser().userEmail;

  if (userEmail == null) {
    print('User email not available');
    return [];
  }

  final conn = await dbConnector();

  final query = """
    SELECT log_date, log_text, log_picture FROM fit_log WHERE user_email = :user_email
  """;

  final results = await conn.execute(query, {'user_email': userEmail});
  await conn.close();

  return results.rows.map((row) {
    return {
      "log_date": DateTime.parse(row.colAt(0) as String),
      "log_text": row.colAt(1),
      "log_picture": row.colAt(2),
    };
  }).toList();
}

// 운동 기록 추가 함수
Future<void> addLog(DateTime selectedDay, List<String> exerciseList, File? image) async {
  final userEmail = diaryuser().userEmail;

  if (userEmail == null) {
    print('User email not available');
    return;
  }

  final conn = await dbConnector();

  final query = """
    INSERT INTO fit_log (user_email, log_text, log_date, log_picture) 
    VALUES (:user_email, :log_text, :log_date, :log_picture)
  """;

  final logText = jsonEncode(exerciseList);
  final logDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(selectedDay); // 형식 변환
  final logPicture = image != null ? base64Encode(image.readAsBytesSync()) : null;

  await conn.execute(query, {
    'user_email': userEmail,
    'log_text': logText,
    'log_date': logDate,
    'log_picture': logPicture
  });

  await conn.close();

  print('운동 기록 추가 성공');
}

// 운동 기록 수정
Future<void> updateUserPicture(String log_text, File? log_picture, String user_email) async {

  final conn = await dbConnector();

  IResultSet? diarySelect;
  IResultSet? diaryUpdate;

  try {
    // 다이어리 값 불러오기
    diarySelect = await conn.execute("SELECT * from fit_log WHERE user_email=:user_email",
    {"user_email":user_email});

    // 다이어리 수정
    diaryUpdate = await conn.execute(
        "UPDATE fit_log SET log_text = :log_text, log_picture =:log_picture WHERE user_email = :user_email",
        {"log_text": log_text, "log_picture": log_picture}
    );
    print('User picture updated successfully');
  } catch (e) {
    print('Error updating user picture: $e');
  } finally {
    await conn.close();
  }
}