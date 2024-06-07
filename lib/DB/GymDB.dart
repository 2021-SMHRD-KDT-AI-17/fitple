import 'package:fitple/DB/DB.dart';

// 헬스장 정보 리스트로 불러오기
Future<List<Map<String, dynamic>>> loadGym() async {
  final conn = await dbConnector();

  final query = """
    SELECT gym_name, gym_address, gym_phone_number, gym_picture, gym_time FROM fit_gym order by gym_point desc
  """;

  final results = await conn.execute(query);
  await conn.close();

  return results.rows.map((row) {
    return {
      "gym_name": row.colByName('gym_name'),
      "gym_address": row.colByName('gym_address'),
      "gym_phone_number": row.colByName('gym_phone_number'),
      "gym_picture": row.colByName('gym_picture'),
      "gym_time": row.colByName('gym_time'),
    };
  }).toList();
}