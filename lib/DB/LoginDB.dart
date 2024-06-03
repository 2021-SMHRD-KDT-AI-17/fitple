import 'package:fitple/DB/DB.dart';
import 'package:mysql_client/mysql_client.dart';

// 계정 생성
Future<void> insertMember(String user_email, String user_password, String user_nick, String user_name, String gender, int age) async {
  // MySQL 접속 설정
  final conn = await dbConnector();

  // 비밀번호 암호화
  // final hash = hashPassword(password);

  // DB에 유저 정보 추가
  try {
    await conn.execute(
        "INSERT INTO fit_mem(user_email, user_password, user_nick, user_name, gender, age) VALUES (:user_email, :user_password, :user_nick, :user_name, :gender, :age)",
        {"user_email": user_email, "user_password": user_password, "user_nick": user_nick, "user_name":user_name, "gender":gender, "age":age});
    // print(hash);
  } catch (e) {
    print('Error : $e');
  } finally {
    await conn.close();
  }
  print('DB연결');
}

// 로그인
Future<Map<String, String>?> login(String user_email, String user_password) async {
  // MySQL 접속 설정
  final conn = await dbConnector();

  // 쿼리 수행 결과 저장 변수
  IResultSet? result;

  // DB에 해당 유저의 아이디와 비밀번호를 확인하여 users 테이블에 있는지 확인
  try {
    result = await conn.execute(
        "SELECT user_email, user_nick FROM fit_mem WHERE user_email = :user_email and user_password = :user_password",
        {"user_email": user_email, "user_password": user_password});

    if (result.isNotEmpty) {
      for (final row in result.rows) {
        print(row.assoc());
        // 유저 정보가 존재하면 유저의 email과 nick 값을 반환
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
  // 예외처리용 에러코드 '-1' 반환
  return null;
}


// 유저ID 중복확인
Future<String?> confirmIdCheck(String user_email) async {
  // MySQL 접속 설정
  final conn = await dbConnector();

  // 쿼리 수행 결과 저장 변수
  IResultSet? result;

  // ID 중복 확인
  try {
    // 아이디가 중복이면 1 값 반환, 중복이 아니면 0 값 반환
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
  // 예외처리용 에러코드 '-1' 반환
  return '-1';
}

// 회원탈퇴
Future<bool> logout(String user_email) async {
  // MySQL 접속 설정
  final conn = await dbConnector();

  try {
    final result = await conn.execute(
      "DELETE FROM fit_mem WHERE user_email = :user_email",
      {"user_email": user_email},
    );

    if (result.affectedRows.toInt() > 0) {
      print('삭제 성공');
      return true; // 삭제 성공
    } else {
      print('삭제 실패: 해당 이메일이 존재하지 않음');
      return false; // 삭제 실패
    }
  } catch (e) {
    print('Error: $e');
    return false; // 삭제 실패
  } finally {
    await conn.close();
  }
}

// 유저 정보 업데이트
Future<bool> updateMember(String user_email, String user_password, String user_nick, String user_name, String gender, int age) async {
  // MySQL 접속 설정
  final conn = await dbConnector();

  // DB에 유저 정보 업데이트
  try {
    await conn.execute(
      "UPDATE fit_mem SET user_password = :user_password, user_nick = :user_nick, user_name = :user_name, gender = :gender, age = :age WHERE user_email = :user_email",
      {
        "user_email": user_email,
        "user_password": user_password,
        "user_nick": user_nick,
        "user_name": user_name,
        "gender": gender,
        "age": age
      },
    );
    print('업데이트 성공');
    return true; // 업데이트 성공
  } catch (e) {
    print('Error: $e');
    return false; // 업데이트 실패
  } finally {
    await conn.close();
  }
}

Future<Map<String, String>> getUserInfo(String userEmail) async {
  final conn = await dbConnector();
  IResultSet result;
  Map<String, String> userInfo = {};

  try {
    result = await conn.execute(
      "SELECT user_email, user_name, user_nick, gender, age FROM fit_mem WHERE user_email = :user_email",
      {"user_email": userEmail},
    );

    if (result.isNotEmpty) {
      final row = result.rows.first;
      userInfo = {
        "email": row.colAt(0) ?? '',
        "name": row.colAt(1) ?? '',
        "nick": row.colAt(2) ?? '',
        "gender": row.colAt(3) ?? '',
        "age": row.colAt(4) ?? '0',
      };
    }
  } catch (e) {
    print('Error : $e');
  } finally {
    await conn.close();
  }

  return userInfo;
}

Future<String> getCurrentUserEmail() async {
  // 현재 로그인된 사용자의 이메일을 반환하도록 구현
  // 예시로 하드코딩된 이메일 대신 실제 로그인 정보를 반환하도록 수정합니다.

  // 실제 앱에서는 로그인 상태를 관리하는 방법에 따라 이메일을 가져옵니다.
  // 예를 들어, SharedPreferences를 사용해서 로그인 정보를 저장하고 불러올 수 있습니다.
  // final prefs = await SharedPreferences.getInstance();
  // return prefs.getString('user_email') ?? 'default_email@example.com';

  // 임시로 하드코딩된 이메일
  return 'user_email'; // 실제 사용자 이메일로 변경
}