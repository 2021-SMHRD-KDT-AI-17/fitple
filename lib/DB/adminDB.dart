import 'package:fitple/DB/DB.dart';
import 'package:mysql_client/mysql_client.dart';
import 'dart:io';
import 'dart:convert';

// 전체 회원 조회
Future<List<Map<String, dynamic>>> selectMember() async {
  final conn = await dbConnector();
  try {
    final result = await conn.execute("SELECT user_email, user_nick FROM fit_mem");
    return result.rows.map((row) {
      return {
        "user_email": row.colAt(0),
        "user_nick": row.colAt(1)
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

//트레이너 체크테이블 전체조회
Future<List<Map<String, dynamic>>> selectTrainerCheck() async {
  final conn = await dbConnector();
  try{
    final result = await conn.execute("SELECT * FROM fit_trainer_check");
    return result.rows.map((row) {
      return {
        "trainer_email": row.colAt(0),
        "trainer_password": row.colAt(1),
        "trainer_name": row.colAt(2),
        "gender": row.colAt(3),
        "age": row.colAt(4),
        "trainer_picture": row.colAt(5),
        "trainer_check_picture": row.colAt(6)
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


//트레이너 승인(인서트 후 딜리트)
Future<void> insertDelete(String trainer_email, String trainer_password, String trainer_name, String gender, String age, File? trainer_picture) async {
  final conn = await dbConnector();
  try {
    // Prepare picture data if the file is not null
    final pictureData = trainer_picture != null ? base64Encode(trainer_picture.readAsBytesSync()) : null;

    // Execute the insert query
    await conn.execute(
      "INSERT INTO fit_trainer_check(trainer_email, trainer_password, trainer_name, gender, age, trainer_picture) VALUES(:trainer_email, :trainer_password, :trainer_name, :gender, :age, :trainer_picture)",
      {
        'trainer_email': trainer_email,
        'trainer_password': trainer_password,
        'trainer_name': trainer_name,
        'gender': gender,
        'age': age,
        'trainer_picture': pictureData,
      },
    );

    // Delete from the check table
    await conn.execute(
      "DELETE FROM fit_trainer_check WHERE trainer_email = :trainer_email",
      {
        'trainer_email': trainer_email,
      },
    );

    await conn.execute(
      "INSERT INTO fit_trainer(trainer_email, trainer_password, trainer_name, gender, age, trainer_picture, trainer_check) VALUES(:trainer_email, :trainer_password, :trainer_name, :gender, :age, :trainer_picture, :trainer_check)",
      {
        'trainer_email': trainer_email,
        'trainer_password': trainer_password,
        'trainer_name': trainer_name,
        'gender': gender,
        'age': age,
        'trainer_picture': pictureData,
        'trainer_check': 'y',
      },
    );

    print('Trainer record inserted & deleted successfully');
  } catch (e) {
    // Error handling
    print("Error: $e");
  } finally {
    await conn.close();
  }
}

