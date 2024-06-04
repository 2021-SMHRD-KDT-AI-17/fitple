import 'package:fitple/screens/chat_list.dart';
import 'package:flutter/material.dart';
import 'package:fitple/chat/chat_area.dart';
import 'package:fitple/chat/input_text_area.dart';

void main() {
  runApp(const ChatTr(userName:'',receiveEmail: '',userEmail: '',));
}


class ChatTr extends StatefulWidget {
  final String userName;
  final String receiveEmail;
  final String userEmail;
  const ChatTr({Key? key, required this.userName, required this.receiveEmail,required this.userEmail}) : super(key: key);

  @override
  _ChatTrState createState() => _ChatTrState();
}

class _ChatTrState extends State<ChatTr> {

  // 메시지 내용을 저장하는 변수
  List messageList = [];

  // 메시지 내용을 setState 함수를 통해 상태를 업데이트하는 함수
  void setStateMessage(data) {
    print("[chat_main.dart] (setStateMessage) 업데이트 할 값 : $data");
    setState(() => messageList.add(data));
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
            Navigator.pop(context, MaterialPageRoute(builder: (context) =>ChatList(userName:widget.userName, userEmail: widget.userEmail,)));
          },
          icon: const Icon(Icons.chevron_left, size: 28),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.receiveEmail,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          // 메시지 내용 표시 영역
          ChatArea(
            messageList: messageList,
            userName: widget.userName,
          ),
          // 메시지 입력 영역
          InputTextArea(userEmail: widget.userEmail,
            messageList: messageList,
            updateMessage: setStateMessage,
            receiveEmail: widget.receiveEmail,
            userName: widget.userName,
          )
        ],
      ),//body: SafeArea(),
    );
  }
}