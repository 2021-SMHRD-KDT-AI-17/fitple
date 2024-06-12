import 'package:fitple/DB/DB.dart';
import 'package:mysql_client/mysql_client.dart';

class PayDB {
  // 데이터베이스 연결 함수
  static Future<MySQLConnection> dbConnector() async {
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

  // 특정 트레이너의 상품 데이터 로드 함수
  static Future<List<Map<String, dynamic>>> loadItem(String trainerEmail) async {
    final conn = await dbConnector();

    final query = """
      SELECT trainer_email, pt_name, pt_price
      FROM fit_item
      WHERE trainer_email = :trainer_email
    """;

    final results = await conn.execute(query, {'trainer_email': trainerEmail});
    await conn.close();

    return results.rows.map((row) {
      return {
        "trainer_email": row.colAt(0),
        "pt_name": row.colAt(1),
        "pt_price": row.colAt(2),
      };
    }).toList();
  }

  // 결제 정보를 데이터베이스에 저장하는 함수
  static Future<void> savePaymentInfo(String userEmail, String ptName, String trainerEmail, int count, int ptPrice, int gymIdx) async {
    final conn = await dbConnector();

    // fit_member_item 테이블에 기존 데이터 존재 여부 확인
    final checkQuery = """
      SELECT COUNT(*) AS cnt FROM fit_member_item
      WHERE user_email = :user_email AND pt_name = :pt_name AND trainer_email = :trainer_email
    """;

    final checkResult = await conn.execute(checkQuery, {
      'user_email': userEmail,
      'pt_name': ptName,
      'trainer_email': trainerEmail,
    });

    final countResult = checkResult.rows.first.colByName('cnt');

    if (countResult == 0) {
      // fit_member_item 테이블에 결제 정보 삽입
      final queryMemberItem = """
        INSERT INTO fit_member_item (user_email, pt_name, trainer_email, count)
        VALUES (:user_email, :pt_name, :trainer_email, :count)
      """;

      await conn.execute(queryMemberItem, {
        'user_email': userEmail,
        'pt_name': ptName,
        'trainer_email': trainerEmail,
        'count': count,
      });

      print("fit_member_item 테이블에 결제 정보 저장 완료.");
    } else {
      print("fit_member_item 테이블에 이미 데이터가 존재합니다.");
    }

    // fit_purchase_list 테이블에 결제 정보 삽입
    final queryPurchaseList = """
      INSERT INTO fit_purchase_list (purchase_date, pt_price, trainer_email, pt_name, user_email, gym_idx)
      VALUES (NOW(), :pt_price, :trainer_email, :pt_name, :user_email, :gym_idx)
    """;

    await conn.execute(queryPurchaseList, {
      'pt_price': ptPrice,
      'trainer_email': trainerEmail,
      'pt_name': ptName,
      'user_email': userEmail,
      'gym_idx': gymIdx,
    });

    print("fit_purchase_list 테이블에 결제 정보 저장 완료.");

    await conn.close();
  }

  // 사용자 존재 여부 확인 및 사용자 추가 함수
  static Future<void> ensureUserExists(String userEmail, String userName) async {
    final conn = await dbConnector();

    final queryCheck = """
      SELECT COUNT(*) AS count FROM fit_mem WHERE user_email = :user_email
    """;

    final result = await conn.execute(queryCheck, {
      'user_email': userEmail,
    });

    final userCount = result.rows.first.colByName('count');

    if (userCount == 0) {
      final queryInsert = """
        INSERT INTO fit_mem (user_email, user_name) VALUES (:user_email, :user_name)
      """;

      await conn.execute(queryInsert, {
        'user_email': userEmail,
        'user_name': userName,
      });

      print("User added to fit_mem table.");
    }

    await conn.close();
  }
}

// 결제내역 가져오기
Future<List<Map<String, dynamic>>> payList(String trainerEmail) async {
  final conn = await dbConnector();
  try {
    final results = await conn.execute(
      "SELECT fit_purchase_list.*, fit_trainer.trainer_name, fit_trainer.trainer_picture, fit_gym.gym_name FROM fit_purchase_list JOIN fit_trainer ON fit_purchase_list.gym_idx = fit_trainer.gym_idx JOIN fit_gym ON fit_purchase_list.gym_idx = fit_gym.gym_idx WHERE fit_purchase_list.trainer_email = fit_trainer.trainer_email;",
      {
        "trainer_email": trainerEmail
      },
    );

    final data = results.rows.map((row) {
      return {
        "purchase_date": row.colAt(1),
        "pt_price": row.colAt(2),
        "trainer_email": row.colAt(3),
        "gym_idx": row.colAt(4),
        "pt_name": row.colAt(5),
        "user_email": row.colAt(6),
        "gym_name": row.colAt(7),
        "trainer_name": row.colAt(8),
        "trainer_picture": row.colAt(9)
      };
    }).toList();

    print(data); // Debugging statement to print fetched data

    return data;
  } catch (e) {
    print("Error: $e");
    return [];
  } finally {
    await conn.close();
  }
}


