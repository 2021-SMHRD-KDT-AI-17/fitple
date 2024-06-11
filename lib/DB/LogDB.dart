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
    SELECT log_idx, log_date, log_text, log_picture FROM fit_log WHERE user_email = :user_email
  """;

  final results = await conn.execute(query, {'user_email': userEmail});
  await conn.close();

  return results.rows.map((row) {
    return {
      "log_idx": int.parse(row.colAt(0).toString()),  // log_idx를 정수형으로 변환
      "log_date": DateTime.parse(row.colAt(1) as String),
      "log_text": row.colAt(2),
      "log_picture": row.colAt(3),
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

  final logText = exerciseList.join('\n'); // 리스트 항목을 개행 문자로 합침
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

// 운동 기록 수정 함수
Future<void> updateLog(int logIdx, String newLogText, String? newImageBase64) async {
  final userEmail = diaryuser().userEmail;

  if (userEmail == null) {
    print('User email not available');
    return;
  }

  final conn = await dbConnector();

  String query;
  Map<String, dynamic> params;

  if (newImageBase64 != null) {
    query = """
      UPDATE fit_log 
      SET log_text = :log_text, log_picture = :log_picture 
      WHERE log_idx = :log_idx AND user_email = :user_email
    """;
    params = {
      'user_email': userEmail,
      'log_text': newLogText.replaceAll(', ', '\n'),
      'log_idx': logIdx,
      'log_picture': newImageBase64,
    };
  } else {
    query = """
      UPDATE fit_log 
      SET log_text = :log_text 
      WHERE log_idx = :log_idx AND user_email = :user_email
    """;
    params = {
      'user_email': userEmail,
      'log_text': newLogText.replaceAll(', ', '\n'),
      'log_idx': logIdx,
    };
  }

  await conn.execute(query, params);

  await conn.close();

  print('운동 기록 수정 성공');
}

// 운동 기록 삭제 함수
Future<void> deleteLog(int logIdx) async {
  final userEmail = diaryuser().userEmail;

  if (userEmail == null) {
    print('User email not available');
    return;
  }

  final conn = await dbConnector();

  final query = """
    DELETE FROM fit_log WHERE log_idx = :log_idx AND user_email = :user_email
  """;

  await conn.execute(query, {
    'user_email': userEmail,
    'log_idx': logIdx,
  });

  await conn.close();

  print('운동 기록 삭제 성공');
}