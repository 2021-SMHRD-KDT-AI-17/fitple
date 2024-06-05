import 'package:fitple/DB/DB.dart';
import 'package:mysql_client/mysql_client.dart';

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
