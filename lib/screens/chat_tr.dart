import 'package:fitple/screens/chat_list.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:fitple/DB/chattest.dart';
import 'package:fitple/screens/chat_list.dart';

void main() async {
  String userName = 'example@example.com';  // 실제 사용자 이메일로 바꾸세요
  WebSocket socket = await WebSocket.connect('ws://172.30.1.8:8089');
  runApp(GestureDetector(
    onTap: () {
      FocusManager.instance.primaryFocus?.unfocus();
    },
    child: MaterialApp(
      home: ChatScreen(userName: userName, socket: socket),
    ),
  ));
}

class ChatScreen extends StatelessWidget {
  final String userName;
  final WebSocket socket;

  const ChatScreen({super.key, required this.userName, required this.socket});
class ChatTr extends StatefulWidget {
  const ChatTr({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User: $userName'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context,MaterialPageRoute(builder: (context) => ChatList()),); // 뒤로가기 버튼 눌렀을 때 이전 화면으로 이동
          },
        ),
      ),
      body: ChatTr(socket: socket),
    );
  }
  _ChatTrState createState() => _ChatTrState();
}

class _ChatTrState extends State<ChatTr> {
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
            Navigator.pop(context, MaterialPageRoute(builder: (context) => const ChatList()));
          },
          icon: const Icon(Icons.chevron_left, size: 28),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '박성주 트레이너',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      //body: SafeArea(),
    );
  }
}