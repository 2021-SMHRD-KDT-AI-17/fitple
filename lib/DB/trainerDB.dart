import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:mysql_client/mysql_client.dart';

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

// 트레이너 회원가입
Future<void> insertTrainer(String trainer_email, String trainer_password, String trainer_name, String gender, int age, int trainer_idx, File? trainer_check_picture) async {
  final conn = await dbConnector();

  try {
    await conn.execute(
      "INSERT INTO fit_trainer_check(trainer_email, trainer_password, trainer_name, gender, age, trainer_idx, trainer_check_picture) VALUES (:trainer_email, :trainer_password, :trainer_name, :gender, :age, :trainer_idx, :trainer_check_picture)",
      {
        "trainer_email": trainer_email,
        "trainer_password": trainer_password,
        "trainer_name": trainer_name,
        "gender": gender,
        "age": age,
        "trainer_idx": trainer_idx,
        "trainer_check_picture": trainer_check_picture != null ? trainer_check_picture.readAsBytesSync() : null,
      },
    );
  } catch (e) {
    print('Error : $e');
  } finally {
    await conn.close();
  }
  print('DB연결!');
}

// 트레이너 이메일 중복확인
Future<String?> confirmIdCheck(String trainer_email) async {
  final conn = await dbConnector();

  IResultSet? result;

  try {
    result = await conn.execute(
        "SELECT IFNULL((SELECT trainer_email FROM fit_trainer WHERE trainer_email=:trainer_email), 0) as idCheck",
        {"trainer_email": trainer_email});

    if (result.isNotEmpty) {
      for (final row in result.rows) {
        return row.colAt(0);
      }
    }
  } catch (e) {
    print('Error : $e');
  } finally {
    await conn.close();
  }
  return '-1';
}




// 트레이너 데이터 로드 함수

Future<List<Map<String, dynamic>>> loadTrainersWithGym() async {
  final conn = await dbConnector();

  final query = """
    SELECT t.trainer_email, t.trainer_name, t.trainer_picture, t.trainer_intro, COALESCE(g.gym_name, '무소속') as gym_name
    FROM fit_trainer t
    LEFT JOIN fit_gym g ON t.gym_idx = g.gym_idx
    ORDER BY t.trainer_point DESC
  """;

  final results = await conn.execute(query);
  await conn.close();

  return results.rows.map((row) {
    final pictureData = row.colByName('trainer_picture');
    Uint8List? pictureBytes;

    // trainer_picture가 Base64로 인코딩된 문자열인 경우 디코딩
    if (pictureData != null) {
      try {
        pictureBytes = base64Decode(pictureData);
      } catch (e) {
        print('Error decoding picture data: $e');
      }
    }

    return {
      "trainer_email": row.colByName('trainer_email'),
      "trainer_name": row.colByName('trainer_name'),
      "trainer_picture": pictureBytes,
      "trainer_intro": row.colByName('trainer_intro'),
      "gym_name": row.colByName('gym_name'),
    };
  }).toList();
}

Future<List<Map<String, dynamic>>> purchaseList(String trainer_email) async {
  final conn = await dbConnector();
  try{
    final results = await conn.execute("SELECT fit_purchase_list.*, fit_gym.gym_name FROM fit_purchase_list INNER JOIN fit_gym ON fit_purchase_list.gym_idx = fit_gym.gym_idx WHERE fit_purchase_list.trainer_email = :trainer_email;",{
      "trainer_email":trainer_email
    });
    return results.rows.map((row) {
      return {
        "purchase_date": row.colAt(1),
        "pt_price": row.colAt(2),
        "trainer_email": row.colAt(3),
        "gym_idx": row.colAt(4),
        "pt_name": row.colAt(5),
        "user_email":row.colAt(6),
        "gym_name":row.colAt(7)

      };
    }).toList();
  } catch (e) {
// 에러 처리
    print("Error: $e");
    return [];
  } finally {
    await conn.close();
  }
}