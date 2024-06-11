import 'package:mysql_client/mysql_client.dart';
import 'package:fitple/Diary/diary_user.dart';
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

// 트레이너 로그 로드 함수
Future<List<Map<String, dynamic>>> loadTrainerLogs() async {
  final trainerEmail = diaryuser().userEmail;

  if (trainerEmail == null) {
    print('Trainer email not available');
    return [];
  }

  final conn = await dbConnector();

  final query = """
    SELECT trainer_log_idx, trainer_log_date, trainer_log_text FROM fit_trainer_log WHERE trainer_email = :trainer_email
  """;

  final results = await conn.execute(query, {'trainer_email': trainerEmail});
  await conn.close();

  return results.rows.map((row) {
    final dateStr = row.colAt(1) as String?;
    final logDate = dateStr != null ? DateTime.parse(dateStr) : DateTime.now(); // null 값을 처리

    return {
      "trainer_log_idx": int.parse(row.colAt(0).toString()),  // trainer_log_idx를 정수형으로 변환
      "trainer_log_date": logDate,  // 불러온 날짜 문자열을 DateTime으로 변환
      "trainer_log_text": row.colAt(2),
    };
  }).toList();
}

// 트레이너 로그 추가 함수
Future<void> addTrainerLog(DateTime selectedDay, List<String> exerciseList) async {
  final trainerEmail = diaryuser().userEmail;

  if (trainerEmail == null) {
    print('Trainer email not available');
    return;
  }

  final conn = await dbConnector();

  final query = """
    INSERT INTO fit_trainer_log (trainer_email, trainer_log_text, trainer_log_date) 
    VALUES (:trainer_email, :trainer_log_text, :trainer_log_date)
  """;

  final logText = exerciseList.join('\n');  // 리스트 항목을 개행 문자로 합침
  final logDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(selectedDay);  // DateTime을 문자열로 변환

  await conn.execute(query, {
    'trainer_email': trainerEmail,
    'trainer_log_text': logText,
    'trainer_log_date': logDate,
  });

  await conn.close();

  print('트레이너 로그 추가 성공');
}

// 트레이너 로그 수정 함수
Future<void> updateTrainerLog(int logIdx, String newLogText) async {
  final trainerEmail = diaryuser().userEmail;

  if (trainerEmail == null) {
    print('Trainer email not available');
    return;
  }

  final conn = await dbConnector();

  final query = """
    UPDATE fit_trainer_log 
    SET trainer_log_text = :trainer_log_text 
    WHERE trainer_log_idx = :trainer_log_idx AND trainer_email = :trainer_email
  """;

  await conn.execute(query, {
    'trainer_email': trainerEmail,
    'trainer_log_text': newLogText.replaceAll(', ', '\n'),
    'trainer_log_idx': logIdx,
  });

  await conn.close();

  print('트레이너 로그 수정 성공');
}

// 트레이너 로그 삭제 함수
Future<void> deleteTrainerLog(int logIdx) async {
  final trainerEmail = diaryuser().userEmail;

  if (trainerEmail == null) {
    print('Trainer email not available');
    return;
  }

  final conn = await dbConnector();

  final query = """
    DELETE FROM fit_trainer_log WHERE trainer_log_idx = :trainer_log_idx AND trainer_email = :trainer_email
  """;

  await conn.execute(query, {
    'trainer_email': trainerEmail,
    'trainer_log_idx': logIdx,
  });

  await conn.close();

  print('트레이너 로그 삭제 성공');
}