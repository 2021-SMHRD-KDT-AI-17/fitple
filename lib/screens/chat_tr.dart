import 'package:flutter/material.dart';
import 'package:fitple/screens/chat_list.dart';
import 'package:fitple/chat/chat_area.dart';
import 'package:fitple/chat/input_text_area.dart';

void main() async {
  runApp(const ChatTr(
    userName: '',
    sendNick: '',
    userEmail: '',
    receiveEmail: '',
    sendEmail: '',
  ));
}

class ChatTr extends StatefulWidget {
  final String userName;
  final String sendNick;
  final String userEmail;
  final String receiveEmail;
  final String sendEmail;

  const ChatTr({
    Key? key,
    required this.userName,
    required this.sendNick,
    required this.userEmail,
    required this.receiveEmail,
    required this.sendEmail,
  }) : super(key: key);

  @override
  _ChatTrState createState() => _ChatTrState();
}

class _ChatTrState extends State<ChatTr> {
  // 메시지 내용을 저장하는 변수
  List<Map<String, String>> messageList = [];

  @override
  void dispose() {
    // dispose 시 필요한 리소스 정리
    super.dispose();
  }

  // 메시지 내용을 setState 함수를 통해 상태를 업데이트하는 함수
  void setStateMessage(Map<String, String> data) {
    print("[chat_main.dart] (setStateMessage) 업데이트 할 값 : $data");
    if (mounted) {
      setState(() {
        messageList.add(data);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1.0,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context,
                MaterialPageRoute(builder: (context) => ChatList(userName: widget.userName, userEmail: widget.userEmail)));
          },
          icon: const Icon(Icons.chevron_left, size: 28),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  widget.sendNick,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  ' 트레이너',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          children: <Widget>[
            // 메시지 내용 표시 영역
            ChatArea(
              messageList: messageList,
              userName: widget.userName,
              userEmail: widget.receiveEmail,
              receiveEmail: widget.sendEmail,
            ),
            // 메시지 입력 영역
            InputTextArea(
              userEmail: widget.receiveEmail,
              messageList: messageList,
              updateMessage: setStateMessage,
              receiveEmail: widget.sendEmail,
              userName: widget.userName,
            )
          ],
        ),
      ),
    );
  }
}
