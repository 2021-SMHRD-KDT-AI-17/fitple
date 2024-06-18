import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:flutter/foundation.dart';

import 'DB.dart';

Future<String> uploadImageToFirebase(File image) async {
  try {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    firebase_storage.Reference storageReference = firebase_storage.FirebaseStorage.instance.ref().child("gym_images/$fileName");

    firebase_storage.UploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.whenComplete(() => null);

    String fileURL = await storageReference.getDownloadURL();
    return fileURL;
  } catch (e) {
    print("Error uploading image: $e");
    throw e;
  }
}

// 헬스장 정보 리스트로 불러오기
Future<List<Map<String, dynamic>>> loadGym() async {
  final conn = await dbConnector();

  final query = """
    SELECT gym_idx, gym_name, gym_address, gym_phone_number, gym_picture, gym_time
    FROM fit_gym
    ORDER BY gym_point DESC
  """;

  final results = await conn.execute(query);
  await conn.close();

  return results.rows.map((row) {
    return {
      "gym_idx": row.colByName('gym_idx'),
      "gym_name": row.colByName('gym_name'),
      "gym_address": row.colByName('gym_address'),
      "gym_phone_number": row.colByName('gym_phone_number'),
      "gym_picture": row.colByName('gym_picture'),
      "gym_time": row.colByName('gym_time'),
    };
  }).toList();
}

// 헬스장 등록
Future<void> insertGym(String gymName, String gymAddress, String gymPhoneNumber, File? gymPicture, String gymStartTime, String gymEndTime) async {
  final conn = await dbConnector();

  try {
    String? pictureUrl;
    if (gymPicture != null) {
      pictureUrl = await uploadImageToFirebase(gymPicture);
    }

    await conn.execute(
      "INSERT INTO fit_gym(gym_name, gym_address, gym_phone_number, gym_picture, gym_time) VALUES (:gym_name, :gym_address, :gym_phone_number, :gym_picture, :gym_time)",
      {
        "gym_name": gymName,
        "gym_address": gymAddress,
        "gym_phone_number": gymPhoneNumber,
        "gym_picture": pictureUrl,
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

// 헬스장 필터 구문
class Gym_DBService {
  static Future<List<Map<String, dynamic>>> fetchGyms({
    required int shower,
    required int parking,
    String? searchKeyword,
  }) async {
    final conn = await dbConnector();

    String query = """
    SELECT gym_idx, gym_name, gym_address, gym_picture, gym_phone_number
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
        "gym_idx": row.colByName('gym_idx'),
        "gym_name": row.colByName('gym_name'),
        "gym_address": row.colByName('gym_address'),
        "gym_picture": row.colByName('gym_picture'),
        "gym_phone_number": row.colByName('gym_phone_number'),
      };
    }).toList();
  }
}

// 헬스장 상세 정보 로드
Future<Map<String, dynamic>> loadGymInfo(int gymIdx) async {
  final conn = await dbConnector();

  final query = """
    SELECT gym_name, gym_address, gym_phone_number, gym_picture, gym_time
    FROM fit_gym
    WHERE gym_idx = :gym_idx
  """;

  final results = await conn.execute(query, {'gym_idx': gymIdx});
  await conn.close();

  final row = results.rows.first;

  String? gymPictureUrl = row.colByName('gym_picture');

  return {
    "gym_name": row.colByName('gym_name'),
    "gym_address": row.colByName('gym_address'),
    "gym_phone_number": row.colByName('gym_phone_number'),
    "gym_picture": gymPictureUrl,
    "gym_time": row.colByName('gym_time'),
  };
}

// 헬스장 리뷰 로드
Future<List<Map<String, dynamic>>> loadGymReviews(int gymIdx) async {
  final conn = await dbConnector();

  final query = """
    SELECT r.user_email, r.gym_review_text, r.gym_review_rate, r.gym_review_date, m.user_nick
    FROM fit_gym_review r
    JOIN fit_mem m ON r.user_email = m.user_email
    WHERE r.gym_idx = :gym_idx
  """;

  final results = await conn.execute(query, {'gym_idx': gymIdx});
  await conn.close();

  return results.rows.map((row) {
    return {
      "user_email": row.colByName('user_email'),
      "gym_review_text": row.colByName('gym_review_text'),
      "gym_review_rate": row.colByName('gym_review_rate'),
      "gym_review_date": row.colByName('gym_review_date'),
      "user_nick": row.colByName('user_nick'),
    };
  }).toList();
}

// 헬스장 상품 로드
Future<List<Map<String, dynamic>>> loadGymItems(int gymIdx) async {
  final conn = await dbConnector();

  final query = """
    SELECT gym_pt_name, gym_pt_price
    FROM fit_gym_item
    WHERE gym_idx = :gym_idx
  """;

  final results = await conn.execute(query, {'gym_idx': gymIdx});
  await conn.close();

  return results.rows.map((row) {
    return {
      "gym_pt_name": row.colByName('gym_pt_name'),
      "gym_pt_price": row.colByName('gym_pt_price'),
    };
  }).toList();
}

// 헬스장 트레이너 로드
Future<List<Map<String, dynamic>>> loadTrainersByGym(int gymIdx) async {
  final conn = await dbConnector();

  final query = """
    SELECT t.trainer_name, g.gym_name, t.trainer_intro, t.trainer_picture, t.trainer_email
    FROM fit_trainer t
    JOIN fit_gym g ON t.gym_idx = g.gym_idx
    WHERE t.gym_idx = :gym_idx
  """;

  final results = await conn.execute(query, {'gym_idx': gymIdx});
  await conn.close();

  return results.rows.map((row) {
    return {
      "trainer_name": row.colByName('trainer_name'),
      "gym_name": row.colByName('gym_name'),
      "trainer_intro": row.colByName('trainer_intro'),
      "trainer_picture": row.colByName('trainer_picture'), // URL 그대로 사용
      "trainer_email": row.colByName('trainer_email'),
    };
  }).toList();
}
Future<Map<String, dynamic>> getGymDetails(int gymIdx) async {
  final conn = await dbConnector();

  final query = """
    SELECT gym_name, gym_address, gym_phone_number, gym_picture, gym_time
    FROM fit_gym
    WHERE gym_idx = :gym_idx
  """;

  final result = await conn.execute(query, {'gym_idx': gymIdx});
  await conn.close();

  if (result.rows.isNotEmpty) {
    final row = result.rows.first;

    return {
      "gym_name": row.colByName('gym_name'),
      "gym_address": row.colByName('gym_address'),
      "gym_phone_number": row.colByName('gym_phone_number'),
      "gym_picture": row.colByName('gym_picture'),
      "gym_time": row.colByName('gym_time'),
    };
  } else {
    throw Exception('No gym found for the provided gymIdx');
  }
}
// (헬스장 정보 수정용)
// 헬스장 정보 조회
Future<Map<String, dynamic>?> gymSelect(String trainerEmail) async {
  final conn = await dbConnector();

  final query = """
    SELECT g.gym_name, g.gym_address, g.gym_phone_number, g.gym_time, g.gym_idx, g.gym_picture
    FROM fit_gym g
    JOIN fit_trainer t ON g.gym_idx = t.gym_idx
    WHERE t.trainer_email = :trainer_email
  """;

  final results = await conn.execute(query, {'trainer_email': trainerEmail});
  await conn.close();

  if (results.rows.isEmpty) {
    return null;
  }

  final row = results.rows.first;

  return {
    'gym_name': row.colByName('gym_name'),
    'gym_address': row.colByName('gym_address'),
    'gym_phone_number': row.colByName('gym_phone_number'),
    'gym_time': row.colByName('gym_time'),
    'gym_idx': row.colByName('gym_idx'),
    'gym_picture': row.colByName('gym_picture'), // URL 그대로 사용
  };
}
// 헬스장 정보 수정
Future<void> updateGymInfo(String gymName, String gymAddress, String gymPhoneNumber, String gymTime, int gymIdx, String? imageUrl) async {
  final conn = await dbConnector();

  try {
    String query = "UPDATE fit_gym SET gym_name = :gym_name, gym_address = :gym_address, gym_phone_number = :gym_phone_number, gym_time = :gym_time";
    Map<String, dynamic> parameters = {
      "gym_name": gymName,
      "gym_address": gymAddress,
      "gym_phone_number": gymPhoneNumber,
      "gym_time": gymTime,
      "gym_idx": gymIdx
    };

    if (imageUrl != null) {
      query += ", gym_picture = :gym_picture";
      parameters["gym_picture"] = imageUrl;
    }

    query += " WHERE gym_idx = :gym_idx";

    await conn.execute(query, parameters);
    print('Gym info updated successfully');
  } catch (e) {
    print('Error updating Gym info: $e');
  } finally {
    await conn.close();
  }
}