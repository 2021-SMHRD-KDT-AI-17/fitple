import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:fitple/DB/DB.dart';
import 'package:mysql_client/mysql_client.dart';

import 'package:flutter/material.dart';

// 헬스장 정보 리스트로 불러오기
Future<List<Map<String, dynamic>>> loadGym() async {
  final conn = await dbConnector();

  final query = """
    SELECT gym_name, gym_address, gym_phone_number, gym_picture, gym_time
    FROM fit_gym
    ORDER BY gym_point DESC
  """;

  final results = await conn.execute(query);
  await conn.close();

  return results.rows.map((row) {
    final pictureData = row.colByName('gym_picture');
    Uint8List? pictureBytes;

    if (pictureData != null && pictureData is String) {
      try {
        pictureBytes = base64Decode(pictureData);
      } catch (e) {
        print('Error decoding picture data: $e');
      }
    }

    return {
      "gym_name": row.colByName('gym_name'),
      "gym_address": row.colByName('gym_address'),
      "gym_phone_number": row.colByName('gym_phone_number'),
      "gym_picture": pictureBytes,
      "gym_time": row.colByName('gym_time'),
    };
  }).toList();
}
// 헬스장 등록
Future<void> insertGym(String gymName, String gymAddress, String gymPhoneNumber, File? gymPicture, String gymStartTime, String gymEndTime) async {
  final conn = await dbConnector();

  try {
    String? pictureBase64;
    if (gymPicture != null) {
      Uint8List pictureBytes = await gymPicture.readAsBytes();
      pictureBase64 = base64Encode(pictureBytes);
    }

    await conn.execute(
      "INSERT INTO fit_gym(gym_name, gym_address, gym_phone_number, gym_picture, gym_time) VALUES (:gym_name, :gym_address, :gym_phone_number, :gym_picture, :gym_time)",
      {
        "gym_name": gymName,
        "gym_address": gymAddress,
        "gym_phone_number": gymPhoneNumber,
        "gym_picture": pictureBase64,
        "gym_time": "$gymStartTime~$gymEndTime"
      },
    );
  } catch (e) {
    print('Error : $e');
  } finally {
    await conn.close();
  }
  print('DB연결!');
}

//------------헬스장 필터 구문

class Gym_DBService {
  static Future<List<Map<String, dynamic>>> fetchGyms({
    required int shower,
    required int parking,
    String? searchKeyword,
  }) async {
    final conn = await dbConnector();

    String query = """
    SELECT gym_name, gym_address, gym_picture, gym_phone_number
    FROM fit_gym
    WHERE 1=1
  """;

    if (shower == 1 || shower == 0) {
      query += " AND shower = $shower";
    }
    if (parking == 1 || parking == 0) {
      query += " AND parking = $parking";
    }

    if (searchKeyword != null && searchKeyword.isNotEmpty) {
      query += " AND (gym_name LIKE '%$searchKeyword%' OR gym_address LIKE '%$searchKeyword%')";
    }

    query += " ORDER BY gym_point DESC";

    final results = await conn.execute(query);
    await conn.close();

    return results.rows.map((row) {
      return {
        "gym_name": row.colByName('gym_name'),
        "gym_address": row.colByName('gym_address'),
        "gym_picture": row.colByName('gym_picture'),
        "gym_phone_number": row.colByName('gym_phone_number'),
      };
    }).toList();
  }


}