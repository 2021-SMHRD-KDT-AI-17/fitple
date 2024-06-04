import 'package:fitple/DB/DB.dart';
import 'package:mysql_client/mysql_client.dart';

// 전체 회원 조회
Future<Map<String, String>?> selectMember() async {
  final conn = await dbConnector();
  IResultSet? result;
  try {
    result = await conn.execute(
        "SELECT * FROM fit_mem");
    if (result.isNotEmpty) {
      for (final row in result.rows) {
        print(row.assoc());
        return {
          "user_email": row.colAt(0) ?? '',
          "user_nick": row.colAt(1) ?? ''
        };
      }
    }

  } catch (e) {
    print('Error : $e');
  } finally {
    await conn.close();
  }
  print('DB연결!');
  return null;
}