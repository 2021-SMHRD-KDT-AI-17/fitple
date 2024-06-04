import 'dart:convert';
import 'dart:io';

class FlutterWebSocket {
  List messageList = [];
  String SERVER = "ws://172.30.1.34:8089";

  // 웹 소켓 서버 연결
  Future<WebSocket> getSocket() async {
    WebSocket socket = await WebSocket.connect(SERVER);
    return socket;
  }

  // 소켓 서버에 데이터 송신
  addMessage(socket, sendEmail, message, type, receiveEmail, userName) {
    Map<String, dynamic> data = {
      'sendEmail': sendEmail,
      'message': message,
      'type': type,
      'receiveEmail':receiveEmail,
      'userName':userName,
      // [type]
      //    - init    :   클라이언트 접속 정보 초기화
      //    - all     :   모든 클라이언트에게 메시지 전송
      //    - whisper|sendEmail :   특정 클라이언트에게 메시지 전송
    };
    print("[socket.dart] 메시지 전송 : $sendEmail : $message");
    socket?.add(jsonEncode(data));
  }
}
