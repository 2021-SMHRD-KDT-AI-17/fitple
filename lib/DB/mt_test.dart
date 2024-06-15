import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:fitple/DB/LoginDB.dart';
import 'package:mysql_client/mysql_client.dart';
import 'dart:convert';








class DBService {
  static Future<MySQLConnection> dbConnector() async {
    final conn = await MySQLConnection.createConnection(
      host: 'project-db-cgi.smhrd.com',
      port: 3307,
      userName: 'wldhz',
      password: '126',
      databaseName: 'wldhz',
    );

    await conn.connect();
    return conn;
  }

  static Future<List<Map<String, dynamic>>> fetchTrainers({
    required String gender,
    required String ageQuery,
    String? searchKeyword,
    String? trainerIntro,
  }) async {
    final conn = await dbConnector();


    String query = '''
      SELECT 
          t.trainer_name, 
          t.trainer_picture, 
          t.trainer_intro, 
          t.trainer_info, 
          t.trainer_email,
          g.gym_name
      FROM 
          fit_trainer t
      JOIN 
          fit_gym g ON t.gym_idx = g.gym_idx
      WHERE 
          1=1
    ''';

    // 나이 그룹 조건 추가
    if (ageQuery.isNotEmpty) {
      query += " AND age IN ($ageQuery)";
    }

    // 성별 조건 추가
    if (gender.isNotEmpty) {
      query += " AND gender = '$gender'";
    }

    // 검색어 조건 추가
    if (searchKeyword != null && searchKeyword.isNotEmpty) {
      query += " AND (trainer_name LIKE '%$searchKeyword%' OR trainer_intro LIKE '%$searchKeyword%')";
    }


    query += " ORDER BY trainer_point DESC";

    final results = await conn.execute(query);
    await conn.close();

    return results.rows.map((row) {
      return {
        "trainer_name": row.colByName('trainer_name'),
        "trainer_picture": row.colByName('trainer_picture'),
        "trainer_intro": row.colByName('trainer_intro'),
        "trainer_info": row.colByName('trainer_info'),
        "trainer_email": row.colByName('trainer_email'),
        "gym_name": row.colByName('gym_name'),
      };
    }).toList();
  }


}