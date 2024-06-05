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

// 특정 트레이너의 상품 데이터 로드 함수
Future<List<Map<String, dynamic>>> loadItem(String trainerEmail) async {
  final conn = await dbConnector();

  final query = """
    SELECT trainer_email, pt_name, pt_price
    FROM fit_item
    WHERE trainer_email = :trainer_email
  """;

  final results = await conn.execute(query, {'trainer_email': trainerEmail});
  await conn.close();

  return results.rows.map((row) {
    return {
      "trainer_email": row.colAt(0),
      "pt_name": row.colAt(1),
      "pt_price": row.colAt(2),
    };
  }).toList();
}