import 'package:mysql_client/mysql_client.dart';
import 'package:fitple/DB/DB.dart';
import 'package:intl/intl.dart';

Future<String?> dailyCheck(String user_email, String log_text) async{
  final conn = await dbConnector();

  //datetime format 변경
  var now = new DateTime.now();
  String formatDate = DateFormat('yyyy-MM-dd').format(now); //format변경
  String date1 = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

  // 쿼리 수행 결과 저장 변수
  IResultSet? result;

  // ID 중복 확인
  try {
    // 아이디가 중복이면 1 값 반환, 중복이 아니면 0 값 반환
    result = await conn.execute(
        "SELECT IFNULL((SELECT user_email FROM fit_log WHERE user_email=:user_email && log_date = :log_date), 0)",
        {"user_email": user_email,
          "log_date":formatDate});

    if (result.isNotEmpty) {
      await conn.execute(
          "INSERT INTO fit_log(user_email, log_text, log_date) VALUES (:user_email, :log_text, :log_date)",
          {"user_email": user_email, "log_text": log_text, "log_date": date1});
    }
  } catch (e) {
    print('Error! : $e');
  } finally {
    await conn.close();
  }
  // 예외처리용 에러코드 '-1' 반환
  return '-1';
}