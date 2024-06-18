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

// 리뷰 삽입 함수
Future<void> insertReview(String user_email, String trainer_review_text, int trainer_review_rate, String trainer_email) async {
  final conn = await dbConnector();

  try {
    var result = await conn.execute(
      "INSERT INTO fit_trainer_review(trainer_review_idx, user_email, trainer_review_text, trainer_review_rate, trainer_review_date, trainer_email, is_processed) VALUES (NULL, :user_email, :trainer_review_text, :trainer_review_rate, NOW(), :trainer_email, false)",
      {
        'user_email': user_email,
        'trainer_review_text': trainer_review_text,
        'trainer_review_rate': trainer_review_rate,
        'trainer_email': trainer_email,
      },
    );

    if (result.affectedRows! > BigInt.from(0)) {
      print("Review inserted successfully!");
    } else {
      print("Failed to insert review.");
    }
  } catch (e) {
    print('Error: $e');
  } finally {
    await conn.close();
  }
  print('DB 연결 성공!');
}


// 리뷰 데이터 로드 함수
Future<List<Map<String, dynamic>>> loadReviews(String userEmail) async {
  final conn = await dbConnector();

  final query = """
    SELECT r.trainer_review_text, r.trainer_review_date, r.user_email, g.gym_name, t.trainer_name, t.trainer_picture FROM fit_trainer_review r LEFT JOIN fit_trainer t ON r.trainer_email = t.trainer_email LEFT JOIN fit_gym g ON t.gym_idx = g.gym_idx WHERE r.user_email = :user_email;
  """;

  final results = await conn.execute(query, {'user_email': userEmail});
  await conn.close();

  return results.rows.map((row) {
    return {
      "text": row.colAt(0),
      "date": row.colAt(1),
      "email": row.colAt(2),
      "gymName": row.colAt(3),
      "trainerName": row.colAt(4),
      "trainerPicture": row.colAt(5)
    };
  }).toList();
}

Future<List<Map<String, dynamic>>> loadTrainerReviews(String trainerEmail) async {
  final conn = await dbConnector();

  final query = """
    SELECT r.trainer_review_text, r.trainer_review_date, u.user_nick
    FROM fit_trainer_review r
    JOIN fit_mem u ON r.user_email = u.user_email
    WHERE r.trainer_email = :trainer_email
  """;

  final results = await conn.execute(query, {'trainer_email': trainerEmail});
  await conn.close();

  return results.rows.map((row) {
    return {
      "trainer_review_text": row.colByName('trainer_review_text'),
      "trainer_review_date": row.colByName('trainer_review_date'),
      "user_nick": row.colByName('user_nick'),
    };
  }).toList();
}