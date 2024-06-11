import 'package:fitple/DB/DB.dart';
import 'package:mysql_client/mysql_client.dart';

//채팅방번호 조회
Future<String?> roomNumDB(String user_email, String receive_email) async {
final conn = await dbConnector();
IResultSet? result;
IResultSet? elseResult;
try{
  result= await conn.execute("SELECT room_num FROM fit_chat_room WHERE user_email=:user_email and trainer_email =:trainer_email",
  {
    "user_email":user_email,
    "trainer_email":receive_email
  });
  elseResult = await conn.execute("SELECT room_num FROM fit_chat_room WHERE user_email=:user_email and trainer_email =:trainer_email",
      {
        "user_email":receive_email,
        "trainer_email":user_email
      });
  if(result.isNotEmpty){
    return result.rows.first.colByName('room_num') ?? '';
  };
  if(elseResult.isNotEmpty){
    return elseResult.rows.first.colByName('room_num') ?? '';
  };
}catch (e) {
  print('Error : $e');

} finally {
  await conn.close();
}
}

//채팅리스트 맨마지막꺼 출력
Future<Map<String, Map<String, String>>> c_list(String user_email) async {
  final conn = await dbConnector();
  IResultSet? result;
  try {
    result = await conn.execute(
        "SELECT fit_chat.*, fit_mem.user_nick,fit_trainer.trainer_name FROM fit_chat LEFT JOIN fit_mem ON fit_chat.send_email = fit_mem.user_email LEFT JOIN fit_trainer ON fit_chat.send_email = fit_trainer.trainer_email WHERE fit_chat.receive_email = :user_email ORDER BY fit_chat.chat_idx DESC", {
      "user_email": user_email
    });

    Map<String, Map<String, String>> resultMap = {};

    if (result.isNotEmpty) {
      for (final row in result.rows) {
        final sendEmail = row.colAt(0) ?? '';
        final sendNick = row.colAt(6) ?? row.colAt(7) ?? '';
        final receiveEmail = row.colAt(1) ?? '';
        final chat = row.colAt(2) ?? '';


        // 중복된 trainer_email을 허용하지 않고, result에 값 추가
        if (!resultMap.containsKey(sendNick)) {
          resultMap[sendNick] = {
            'chat': chat,
            'receiveEmail': receiveEmail,
            'sendEmail': sendEmail
          };
          print("sendNick: $sendNick , Chat: $chat");
        }
      }
    }

    return resultMap;
  } catch (e) {
    print('Error: $e');
    return {}; // 에러 발생 시 빈 맵 반환
  } finally {
    await conn.close();
  }
}

//채팅방번호 조회 후 없으면 생성
Future<Map<String, String>?> room_num(String user_email, String trainer_email) async {
  final conn = await dbConnector();
  IResultSet? result;
  try {
    result = await conn.execute(
        "SELECT * FROM fit_chat_room WHERE user_email = :user_email AND trainer_email = :trainer_email", {
      "user_email": user_email,
      "trainer_email": trainer_email
    });

    if (result == null || result.rows.isEmpty) {
      await conn.execute(
          "INSERT INTO fit_chat_room(user_email, trainer_email) VALUES(:user_email, :trainer_email)", {
        "user_email": user_email,
        "trainer_email": trainer_email
      });
      print('채팅넘버 부여 ${user_email}, ${trainer_email}');
    }


  } catch (e) {
    print('Error: $e');
  } finally {
    await conn.close();
  }
  return null; // 함수가 항상 값을 반환하도록 보장합니다.
}

//채팅 DB에 저장
Future<Map<String, String>?> chatting(String user_email, String receive_email, String chat, String roomNum) async {
  final conn = await dbConnector();
  try{
    await conn.execute(
        "INSERT INTO fit_chat (send_email, receive_email, chat, chat_date, room_num) VALUES (:send_email, :receive_email, :chat, NOW(),:room_num)"
        , {
      "send_email": user_email,
      "receive_email":receive_email,
      "chat":chat,
      "room_num":roomNum
    });

  } catch (e) {
    print('Error: $e');
  } finally {
    await conn.close();
  }
  return null;
  }

  //모든 채팅내역 조회
Future<List<Map<String, String>>> chatListDB(String roomNum) async {
  final conn = await dbConnector();
  IResultSet? result;
  try {
    result = await conn.execute(
        "SELECT * FROM fit_chat WHERE room_num=:room_num ORDER BY chat_idx ASC ", {
      "room_num": roomNum
    });

    List<Map<String, String>> chatList = [];

    if (result.isNotEmpty) {
      for (final row in result.rows) {
        final sendEmail = row.colAt(0) ?? '';
        final sendNick = row.colAt(6) ?? row.colAt(7) ?? '';
        final receiveEmail = row.colAt(1) ?? '';
        final chat = row.colAt(2) ?? '';

        chatList.add({
          'sendNick': sendNick,
          'chat': chat,
          'receiveEmail': receiveEmail,
          'sendEmail': sendEmail
        });
        print("sendNick: $sendNick , Chat: $chat");
      }
    }

    return chatList;
  } catch (e) {
    print('Error: $e');
    return []; // 에러 발생 시 빈 리스트 반환
  } finally {
    await conn.close();
  }
}

