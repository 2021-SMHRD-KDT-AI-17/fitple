import 'package:fitple/Diary/diary_user.dart';
import 'package:fitple/DB/DB.dart';
import 'package:mysql_client/mysql_client.dart';

// 계정 생성
Future<void> insertMember(String user_email, String user_password, String user_nick, String user_name, String gender, int age) async {
  final conn = await dbConnector();

  try {
    await conn.execute(
        "INSERT INTO fit_mem(user_email, user_password, user_nick, user_name, gender, age) VALUES (:user_email, :user_password, :user_nick, :user_name, :gender, :age)",
        {"user_email": user_email, "user_password": user_password, "user_nick": user_nick, "user_name": user_name, "gender": gender, "age": age});
  } catch (e) {
    print('Error : $e');
  } finally {
    await conn.close();
  }
  print('DB연결!');
}

// 로그인
Future<Map<String, String>?> login(String user_email, String user_password) async {
  final conn = await dbConnector();


  IResultSet? userResult;
  IResultSet? trainerResult;

  try {
    // 첫 번째 쿼리: 사용자 테이블 조회
    userResult = await conn.execute(
        "SELECT user_email, user_nick FROM fit_mem WHERE user_email = :user_email and user_password = :user_password",
        {"user_email": user_email, "user_password": user_password});

    // 두 번째 쿼리: 트레이너 테이블 조회
    trainerResult = await conn.execute(
        "SELECT trainer_email, trainer_name FROM fit_trainer WHERE trainer_email = :trainer_email and trainer_password = :trainer_password",
        {"trainer_email": user_email, "trainer_password": user_password});

    // 사용자 결과 처리
    if (userResult.isNotEmpty) {
      for (final row in userResult.rows) {
        print(row.assoc());
        diaryuser().setUserEmail(row.colAt(0) ?? '');
        return {
          "user_email": row.colAt(0) ?? '',
          "user_nick": row.colAt(1) ?? ''
        };
      }
    }

    // 트레이너 결과 처리
    if (trainerResult.isNotEmpty) {
      for (final row in trainerResult.rows) {
        print(row.assoc());
        diaryuser().setUserEmail(row.colAt(0) ?? '');
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
Future<Map<String, String>?> logout(String user_email) async {
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