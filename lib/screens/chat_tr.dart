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
}

class ChatTr extends StatefulWidget {
  final WebSocket socket;

  const ChatTr({super.key, required this.socket});

  @override
  State<ChatTr> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatTr> {
  List messageList = [];

  void setStateMessage(message) {
    setState(() => messageList.add(message));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ChatArea(
            messageList: messageList,
          ),
        ),
        InputTextArea(
          updateMessag: setStateMessage,
          socket: widget.socket,
        ),
      ],
    );
  }
}

class ChatArea extends StatefulWidget {
  final List messageList;

  const ChatArea({super.key, required this.messageList});

  @override
  State<ChatArea> createState() => _ChatAreaState();
}

class _ChatAreaState extends State<ChatArea> {
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500), curve: Curves.ease);
    });

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        controller: scrollController,
        itemCount: widget.messageList.length,
        itemBuilder: (BuildContext context, int index) {
          return Align(
            alignment: Alignment.topRight,
            child: Card(
              color: Colors.blue,
              margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Text(widget.messageList[index]),
              ),
            ),
          );
        },
      ),
    );
  }
}

class InputTextArea extends StatefulWidget {
  final Function updateMessag;
  final WebSocket socket;

  const InputTextArea({super.key, required this.updateMessag, required this.socket});

  @override
  State<InputTextArea> createState() => _InputTextAreaState();
}

class _InputTextAreaState extends State<InputTextArea> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Enter your message'),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () async {
              if (_controller.text.isNotEmpty) {
                String m_data = _controller.text;
                widget.updateMessag(m_data);
                await socket_add(widget.socket, m_data);
                _controller.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}

Future<void> socket_add(WebSocket socket, String message) async {
  socket.add(message);
}
