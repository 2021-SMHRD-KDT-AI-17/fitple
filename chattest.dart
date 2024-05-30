import 'dart:io';
import 'package:fitple/DB/DB.dart';
import 'package:intl/intl.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:fitple/model/Member.dart';

void main() async {
  //DB연결 함수
  //final conn = await dbConnector();

  // 웹 소켓 서버 연결
  WebSocket socket = await WebSocket.connect('ws://172.30.1.8:8089');

  //datetime format 변경
  var now = new DateTime.now(); //원래 데이트타임
  String formatDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now); //format변경

  // 소켓 서버에 데이터 송신
  socket.add("Hello?");


  socket.listen((data) {
    print("서버로부터 받은 값 : $data");
    print(formatDate);
  });
}
