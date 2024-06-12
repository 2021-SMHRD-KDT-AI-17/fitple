import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fitple/DB/chatDB.dart';

class ChatArea extends StatefulWidget {
  final List<dynamic> messageList; // messageList 타입을 명시적으로 지정
  final String userName;
  final String userEmail;
  final String receiveEmail;
  const ChatArea({
    super.key,
    required this.messageList,
    required this.userName,
    required this.userEmail,
    required this.receiveEmail,
  });

  @override
  State<ChatArea> createState() => _ChatAreaState();
}

class _ChatAreaState extends State<ChatArea> {
  ScrollController scrollController = ScrollController();
  List<Map<String, dynamic>> chatList = [];

  @override
  void initState() {
    super.initState();
    fetchChatList();
  }

  Future<void> fetchChatList() async {
    String? roomNum = await roomNumDB(widget.userEmail, widget.receiveEmail);
    List<Map<String, dynamic>> fetchedList = await chatListDB(roomNum.toString());
    setState(() {
      chatList = fetchedList;
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    });

    // messageList의 각 요소는 JSON 문자열이므로 이를 맵으로 변환하여 사용
    List<Map<String, dynamic>> decodedMessageList = widget.messageList
        .map((message) => jsonDecode(message) as Map<String, dynamic>)
        .toList();

    // decodedMessageList와 chatList를 결합
    List<Map<String, dynamic>> combinedList = [
      ...decodedMessageList,
      ...chatList
    ];

    return Expanded(
      child: ListView.builder(
        controller: scrollController,
        itemCount: combinedList.length,
        itemBuilder: (BuildContext context, int index) {
          Map<String, dynamic> data = combinedList[index];

          if (data['sendNick'] == widget.userName) {
            return Align(
              alignment: Alignment.topRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("${data['sendNick']}"),
                  Card(
                    color: Colors.blue,
                    margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: Text(data['chat']),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Align(
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${data['sendNick']}"),
                  Card(
                    margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: Text('${data['chat']}'),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
