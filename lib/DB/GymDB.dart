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
    SELECT gym_idx, gym_name, gym_address, gym_phone_number, gym_picture, gym_time
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
      "gym_idx": row.colByName('gym_idx'),
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
    SELECT t.trainer_name, g.gym_name, t.trainer_intro, t.trainer_picture
    FROM fit_trainer t
    JOIN fit_gym g ON t.gym_idx = g.gym_idx
    WHERE t.gym_idx = :gym_idx
  """;

  final results = await conn.execute(query, {'gym_idx': gymIdx});
  await conn.close();

  return results.rows.map((row) {
    final pictureData = row.colByName('trainer_picture');
    Uint8List? pictureBytes;

    if (pictureData != null && pictureData is String) {
      try {
        pictureBytes = base64Decode(pictureData);
      } catch (e) {
        print('Error decoding picture data: $e');
      }
    }

    return {
      "trainer_name": row.colByName('trainer_name'),
      "gym_name": row.colByName('gym_name'),
      "trainer_intro": row.colByName('trainer_intro'),
      "trainer_picture": pictureBytes,
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
  } else {
    throw Exception('No gym found for the provided gymIdx');
  }
}

//(헬스장 정보 수정용)
// 헬스장 정보 조회
Future<Map<String, dynamic>> gymSelect(String trainer_email) async{
  final conn = await dbConnector();

    final query = """
    SELECT fg.*, fgi.gym_pt_name, fgi.gym_pt_price
FROM fit_gym fg
JOIN fit_trainer ft ON fg.gym_idx = ft.gym_idx
JOIN fit_gym_item fgi ON fg.gym_idx = fgi.gym_idx
WHERE ft.trainer_email = :trainer_email;

   """;

    final gymResult = await conn.execute(query, {'trainer_email':trainer_email });
    await conn.close();

    if (gymResult.rows.isNotEmpty) {
      final row = gymResult.rows.first;
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
        "gym_pt_name":row.colByName('gym_pt_name'),
        "gym_pt_price":row.colByName('gym_pt_price'),
        "gym_idx":row.colByName('gym_idx')
      };

    }else {
      throw Exception('No gym found for the provided gymIdx');
    }
}

//헬스장 정보 수정
Future<void> updateGymInfo(String gym_name, String gym_address, String gym_phone_number, String gym_time, int gym_idx, String? gymPictureBase64) async {
  final conn = await dbConnector();

  try {
    // 동적으로 쿼리와 매개변수 구성
    String query = "UPDATE fit_gym SET gym_name = :gym_name, gym_address = :gym_address, gym_phone_number = :gym_phone_number, gym_time = :gym_time";
    Map<String, dynamic> parameters = {
      "gym_name": gym_name,
      "gym_address": gym_address,
      "gym_phone_number": gym_phone_number,
      "gym_time": gym_time,
      "gym_idx":gym_idx
    };

    if (gymPictureBase64 != null) {
      query += ", gym_picture = :gym_picture";
      parameters["gym_picture"] = gymPictureBase64;
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