import 'dart:io';

void main() async {
  // 서버 설정
  HttpServer server = await HttpServer.bind('172.30.1.8', 8089);
  print("서버가 생성되었습니다.");

  // 클라이언트 요청 비동기 처리
  await for (var req in server) {
    // HTTP 요청을 웹 소켓 프로토콜로 업그레이드
    await WebSocketTransformer.upgrade(req).then((WebSocket websocket) {
      // 디버그용 클라이언트 식별 print
      print("클라이언트 접속 : ${req.connectionInfo!.remoteAddress.address}");

      // 클라이언트로 받은 데이터 수신 처리
      websocket.listen((data) {
        // 연결되어 있는 클라이언트에게 보낼 데이터 송신 처리
        websocket.add(data);
      });


    });
  }
}
