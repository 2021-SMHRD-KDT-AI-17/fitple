import 'package:mysql_client/mysql_client.dart';

// 데이터베이스 연결 함수
Future<MySQLConnection> dbConnector() async {
  print("Connecting to mysql server...");

  final conn = await MySQLConnection.createConnection(
    host: 'project-db-cgi.smhrd.com',
    port: 3307,
    userName: 'wldhz',
    password: '126',
    databaseName: 'wldhz',
  );

  await conn.connect();

  print("Connected");

  return conn;
}

// 트레이너 데이터 로드 함수
Future<List<Map<String, dynamic>>> loadTrainersWithGym() async {
  final conn = await dbConnector();

  final query = """
    SELECT t.trainer_email, t.trainer_name, t.trainer_picture, COALESCE(g.gym_name, '무소속') as gym_name
    FROM fit_trainer t
    LEFT JOIN fit_gym g ON t.gym_idx = g.gym_idx
    ORDER BY t.trainer_point DESC
  """;

  final results = await conn.execute(query);
  await conn.close();

  return results.rows.map((row) {
    return {
      "trainer_email": row.colByName('trainer_email'),
      "trainer_name": row.colByName('trainer_name'),
      "trainer_picture": row.colByName('trainer_picture'),
      "gym_name": row.colByName('gym_name'),
    };
  }).toList();
}