import 'package:fitple/DB/DB.dart';
import 'package:mysql_client/mysql_client.dart';

// 계정 생성
Future<void> insertMember(String user_email, String user_password, String user_nick, String user_name, String gender, int age) async {
  final conn = await dbConnector();

  try {
    await conn.execute(
        "INSERT INTO fit_mem(user_email, user_password, user_nick, user_name, gender, age) VALUES (:user_email, :user_password, :user_nick, :user_name, :gender, :age)",
        {"user_email": user_email, "user_password": user_password, "user_nick": user_nick, "user_name":user_name, "gender":gender, "age":age});
  } catch (e) {
    print('Error : $e');
  } finally {
    await conn.close();
  }
  print('DB연결');
}

// 로그인
Future<Map<String, String>?> login(String user_email, String user_password) async {
  final conn = await dbConnector();
  IResultSet? result;

  try {
    result = await conn.execute(
        "SELECT user_email, user_nick FROM fit_mem WHERE user_email = :user_email and user_password = :user_password",
        {"user_email": user_email, "user_password": user_password});

    if (result.isNotEmpty) {
      for (final row in result.rows) {
        print(row.assoc());
        // 유저 정보가 존재하면 유저의 email과 nick 값을 반환
        String email = row.colAt(0) ?? '';
        String nick = row.colAt(1) ?? '';
        UserSession().setUserEmail(email);
        return {
          "user_email": email,
          "user_nick": nick
        };
      }
    }
  } catch (e) {
    print('Error : $e');
  } finally {
    await conn.close();
  }
  return null;
}

// 유저ID 중복확인
Future<String?> confirmIdCheck(String user_email) async {
  final conn = await dbConnector();
  IResultSet? result;

  try {
    result = await conn.execute(
        "SELECT IFNULL((SELECT user_email FROM fit_mem WHERE user_email=:user_email), 0) as idCheck",
        {"user_email": user_email});

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

// 회원탈퇴
Future<Map<String, String>?> logout(String user_email, String user_password) async {
  final conn = await dbConnector();
  IResultSet? result;

  try {
    result = await conn.execute(
        "delete from fit_mem where user_email=:user_email",
        {"user_email": user_email});

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
  return null;
}

class UserSession {
  static final UserSession _instance = UserSession._internal();
  String? _userEmail;

  factory UserSession() {
    return _instance;
  }

  UserSession._internal();

  String? get userEmail => _userEmail;

  void setUserEmail(String email) {
    _userEmail = email;
  }
}