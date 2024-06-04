import 'package:fitple/DB/DB.dart';
import 'package:mysql_client/mysql_client.dart';




Future<Map<String, String>?> c_list(String user_nick) async {
  final conn = await dbConnector();
  IResultSet? result;
  try {
    result = await conn.execute(
        "SELECT * FROM fit_chat WHERE user_nick = :user_nick", {
      "user_nick": user_nick
    });

    Map<String, String> resultMap = {};

    if (result.isNotEmpty) {
      for (final row in result.rows) {
        final receiveEmail = row.colAt(1) ?? '';
        final chat = row.colAt(2) ?? '';

        // 중복된 trainer_email을 허용하지 않고, result에 값 추가
        if (!resultMap.containsKey(receiveEmail)) {
          resultMap[receiveEmail] = chat;
          print("receive Email: $receiveEmail, Chat: $chat");
        }
      }
    }

    return resultMap;
  } catch (e) {
    print('Error: $e');
  } finally {
    await conn.close();
  }

  return null; // 함수가 항상 값을 반환하도록 보장합니다.
}

Future<Map<String, String>?> chatting(String user_email, String receive_email, String chat, String chat_date, String user_nick) async {
  final conn = await dbConnector();


  try{
    await conn.execute(
        "INSERT INTO fit_chat (send_email, receive_email, chat, chat_date, user_nick) VALUES (:send_email, :receive_email, :chat, :chat_date, :user_nick)"
        , {
      "user_nick": user_nick,
      "send_email": user_email,
      "receive_email":receive_email,
      "chat":chat,
      "chat_date":chat_date,

    });
  } catch (e) {
    print('Error: $e');
  } finally {
    await conn.close();
  }
  return null;
  }

