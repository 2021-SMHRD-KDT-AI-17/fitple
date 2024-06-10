import 'dart:io';

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
Future<void> insertTrainer(String trainer_email, String trainer_password, String trainer_name, String gender, int age, String trainer_check, File? trainer_picture) async {
  final conn = await dbConnector();

  try {
    await conn.execute(
        "INSERT INTO fit_trainer(trainer_email, trainer_password, trainer_name, gender, age, trainer_check, trainer_picture) VALUES (:trainer_email, :trainer_password, :trainer_name, :gender, :age, :trainer_check, :trainer_picture)",
        {"trainer_email": trainer_email, "trainer_password": trainer_password, "trainer_name": trainer_name, "gender": gender, "age": age, "trainer_check": trainer_check, "trainer_picture":trainer_picture,});
  } catch (e) {
    print('Error : $e');
  } finally {
    await conn.close();
  }
  print('DB연결!');
}




// 트레이너 데이터 로드 함수
Future<List<Map<String, dynamic>>> loadTrainersWithGym() async {
  final conn = await dbConnector();

  final query = """
    SELECT t.trainer_email, t.trainer_name, t.trainer_picture, COALESCE(g.gym_name, '무소속') as gym_name
    FROM fit_trainer t
    LEFT JOIN fit_gym g ON t.gym_idx = g.gym_idx
    ORDER BY t.trainer_point DESC
  """;

  final results = await conn.execute(query);
  await conn.close();

  return results.rows.map((row) {
    return {
      "trainer_email": row.colByName('trainer_email'),
      "trainer_name": row.colByName('trainer_name'),
      "trainer_picture": row.colByName('trainer_picture'),
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