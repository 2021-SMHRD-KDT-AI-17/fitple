import 'package:flutter/material.dart';
import 'package:mysql_client/mysql_client.dart';

void main() {
  //dbConnector('selectAll');
  runApp(const MyApp());
}

Future<void> dbConnector(String queryState) async{
  print('Connecting to mysql server...');

  //Mysql 접속 설정
  final conn = await MySQLConnection.createConnection(
      host: 'project-db-campus.smhrd.com',
      port: 3307,
      userName: 'wldhz',
      password: '126',
      databaseName: 'wldhz');

  //연결 대기
  await conn.connect();

  print('Connected');



  // 쿼리 실행 결과를 저장할 변수
  //IResultSet? result;
  var result;

  if (queryState == 'selectAll') {
    result = await conn.execute('SELECT * FROM fit_mem');
  }

  //쿼리 실행 성공
  if (result != null && result.isNotEmpty) {
    for (final row in result.rows) {
      print(row.assoc());
    }
  }
  // 쿼리 실행 실패
  else {
    print('failed');
  }
  //종료 대기
  await conn.close();
}
///////////////////////////////////////////////////////

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body:  Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('name'),
              OutlinedButton(onPressed: (){dbConnector('selectAll');}, child: Text('outline button'),)
            ],
          ),
        ),
      ),
    );
  }
}






