import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:fitple/DB/LoginDB.dart';
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
// 트레이너 정보 업데이트 함수
Future<void> updateTrainerInfo(String trainerEmail, String trainerName, String gender, int? age, int? gymIdx, String? trainerPictureBase64, String trainerInfo, String trainerIntro) async {
  final conn = await dbConnector();

  try {
    String query = "UPDATE fit_trainer SET trainer_name = :trainer_name, gender = :gender, trainer_intro = :trainer_intro";
    Map<String, dynamic> parameters = {
      "trainer_name": trainerName,
      "gender": gender,
      "trainer_intro": trainerIntro,
      "trainer_email": trainerEmail
    };

    if (age != null) {
      query += ", age = :age";
      parameters["age"] = age;
    }

    if (gymIdx != null) {
      query += ", gym_idx = :gym_idx";
      parameters["gym_idx"] = gymIdx;
    }

    if (trainerPictureBase64 != null) {
      query += ", trainer_picture = :trainer_picture";
      parameters["trainer_picture"] = trainerPictureBase64;
    }

    if (trainerInfo != null) {
      query += ", trainer_info = :trainer_info";
      parameters["trainer_info"] = trainerInfo;
    }

    query += " WHERE trainer_email = :trainer_email";

    await conn.execute(query, parameters);
    print('Trainer info updated successfully');
  } catch (e) {
    print('Error updating trainer info: $e');
  } finally {
    await conn.close();
  }
}
// 트레이너 정보 및 gym_name 가져오기
Future<Map<String, dynamic>?> trainerselect(String trainerEmail) async {
  final conn = await dbConnector();
  IResultSet? userResult;

  try {
    userResult = await conn.execute(
        "SELECT t.trainer_name, t.gender, t.age, g.gym_name, t.trainer_picture, t.trainer_info, t.trainer_intro, t.gym_idx FROM fit_trainer t LEFT JOIN fit_gym g ON t.gym_idx = g.gym_idx WHERE t.trainer_email = :trainer_email",
        {"trainer_email": trainerEmail});

    Map<String, dynamic> resultMap = {};

    if (userResult.isNotEmpty) {
      for (final row in userResult.rows) {
        final trainerName = row.colAt(0)?.toString() ?? '';
        final gender = row.colAt(1)?.toString() ?? '';
        final age = row.colAt(2)?.toString() ?? '';
        final gymName = row.colAt(3)?.toString() ?? '';
        Uint8List? picture;
        final trainerInfo = row.colAt(5)?.toString() ?? '';
        final trainerIntro = row.colAt(6)?.toString() ?? '';
        final gymIdx = row.colAt(7);

        final pictureData = row.colAt(4);
        if (pictureData != null && pictureData is String) {
          picture = base64Decode(pictureData);
        }

        resultMap = {
          'trainerName': trainerName,
          'gender': gender,
          'age': age,
          'gymName': gymName,
          'trainerPicture': picture,
          'trainerInfo': trainerInfo,
          'trainerIntro': trainerIntro,
          'gymIdx': gymIdx,
        };
      }

      return resultMap;
    } else {
      return null; // 사용자 정보가 없을 경우
    }
  } catch (e) {
    print('Error : $e');
    return null;
  } finally {
    await conn.close();
  }
}




// 트레이너 이메일에 해당하는 fit_item 데이터를 가져오는 함수
Future<int> getTrainerReviewCount(String trainerEmail) async {
  final conn = await dbConnector();

  final query = """
    SELECT COUNT(*) as review_count
    FROM fit_trainer_review
    WHERE trainer_email = :trainer_email
  """;

  final results = await conn.execute(query, {"trainer_email": trainerEmail});
  await conn.close();

  if (results.rows.isNotEmpty) {
    final countStr = results.rows.first.colByName('review_count');
    if (countStr != null) {
      final count = int.tryParse(countStr);
      if (count != null) {
        return count;
      }
    }
  }

  return 0;
}

// 트레이너의 아이템 정보를 가져오는 함수
Future<List<Map<String, dynamic>>> loadTrainerItems(String trainerEmail) async {
  final conn = await dbConnector();

  final query = """
    SELECT pt_name, pt_price
    FROM fit_item
    WHERE trainer_email = :trainer_email
    ORDER BY pt_price ASC
  """;

  final results = await conn.execute(query, {"trainer_email": trainerEmail});
  await conn.close();

  return results.rows.map((row) {
    return {
      "pt_name": row.colByName('pt_name'),
      "pt_price": row.colByName('pt_price'),
    };
  }).toList();
}

//대표강사 여부 확인
Future<Map<String,String>?> oneTop(String trainer_email) async {
  final conn = await dbConnector(); // 데이터베이스 연결 객체를 가져옵니다.
  IResultSet? one_top_check;
  try {
    one_top_check= await conn.execute(
        "SELECT  trainer_idx FROM fit_trainer WHERE trainer_email = :trainer_email",{
      "trainer_email":trainer_email
    });
    for (final row in one_top_check.rows) {
      return {
        "oneTopCheck": row.colAt(0) ?? '',
      };
    }

  } finally {
    await conn.close(); // 연결 닫기
  }
  return null;
}