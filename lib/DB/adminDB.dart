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
