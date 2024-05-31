import 'package:mysql_client/mysql_client.dart';

// MySQL 접속
Future<MySQLConnection> dbConnector() async {
  print("Connecting to mysql server...");

  // MySQL 접속 설정
  final conn = await MySQLConnection.createConnection(
    host: 'project-db-campus.cgi.com',
    port: 3307,
    userName: 'wldhz',
    password: '126',
    databaseName: 'wldhz', // optional
  );

  await conn.connect();

  print("Connected");

  return conn;
}