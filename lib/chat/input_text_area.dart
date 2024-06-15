import 'dart:io';
import 'dart:convert'; // JSON 디코딩을 위해 추가
import 'package:flutter/material.dart';
import 'package:fitple/chat/socket.dart';
import 'package:fitple/DB/chatDB.dart';

class InputTextArea extends StatefulWidget {
  final String userEmail;
  final List messageList;
  final Function updateMessage;
  final String receiveEmail;
  final String userName;

  const InputTextArea({
    super.key,
    required this.userEmail,
    required this.messageList,
    required this.updateMessage,
    required this.receiveEmail,
    required this.userName,
  });

  @override
  State<InputTextArea> createState() => _InputTextAreaState();
}

class _InputTextAreaState extends State<InputTextArea> {
  final TextEditingController _controller = TextEditingController();

  // 웹소켓 할당을 위한 변수
  final FlutterWebSocket flutterWebSocket = FlutterWebSocket();
  WebSocket? socket;

  @override
  void initState() {
    super.initState();
    createSocket(); // 웹소켓 서버 연결하기
  }

  // 서버 연결
  void createSocket() async {
    try {
      socket = await flutterWebSocket.getSocket();

      // 클라이언트 초기 설정 (서버측 클라이언트 정보 알림용 메시지 전송)
      flutterWebSocket.addMessage(socket, widget.userEmail, "", "init", widget.receiveEmail, widget.userName, "");

      socket?.listen((data) {
        print("[input_text_area.dart] (createSocket) 서버로부터 받은 값 : $data");

        // 받은 데이터를 JSON으로 파싱
        var decodedData = jsonDecode(data);

        // Map<String, dynamic>을 Map<String, String>으로 변환
        Map<String, String> stringData = {};
        decodedData.forEach((key, value) {
          stringData[key] = value.toString();
        });

        if (mounted) {
          setState(() {
            widget.updateMessage(stringData);  // 업데이트 메시지 호출
          });
        }
      });
    } catch (e) {
      print("[input_text_area.dart] (createSocket) 소켓 서버 접속 오류: $e");
    }
  }

  @override
  void dispose() {
    socket?.close();  // 웹소켓 연결 종료
    _controller.dispose();
    super.dispose();
  }

  // 메시지 보내기
  Future<void> sendMessage() async {
    if (_controller.text.trim().isNotEmpty) {
      String message = _controller.text; // 메시지 내용
      String messageType = ""; // 메시지 타입

      // 귓속말 명령어 확인
      // 예) /w 사용자 내용
      if (_controller.text.split(" ")[0] == "/w") {
        messageType = "whisper|${_controller.text.split(" ")[1]}";
        String excludeString = "${_controller.text.split(" ")[0]} ${_controller.text.split(" ")[1]}";

        message = "(귓속말)${_controller.text.replaceFirst(excludeString, "")}";
      } else {
        // 귓속말 명령어가 없으면 모두에게 메시지 보내기
        messageType = "whisper|${widget.receiveEmail}";
        message = _controller.text;
      }

      // 채팅방 번호 조회
      String? roomNum = await roomNumDB(widget.userEmail, widget.receiveEmail);

      // 채팅방 번호가 null이 아니면
      if (roomNum != null) {
        // 웹소켓 서버에 메시지 내용 전송
        flutterWebSocket.addMessage(socket, widget.userEmail, message, messageType, widget.receiveEmail, widget.userName, roomNum);
        chatting(widget.userEmail, widget.receiveEmail, message, roomNum);
        _controller.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          // 메시지 입력란
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: '메시지를 입력하세요.',
                border: InputBorder.none,
              ),
            ),
          ),
          // 전송버튼
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blueAccent),
            onPressed: () => sendMessage(), // 메시지 보내기
          ),
        ],
      ),
    );
  }
}
