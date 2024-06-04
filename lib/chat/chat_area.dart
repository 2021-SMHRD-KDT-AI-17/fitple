import 'dart:convert';
import 'package:flutter/material.dart';

class ChatArea extends StatefulWidget {
  final List messageList;
  final String userName;
  const ChatArea({super.key, required this.messageList, required this.userName});

  @override
  State<ChatArea> createState() => _ChatAreaState();
}

class _ChatAreaState extends State<ChatArea> {
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    // 리스트뷰에 메시지가 추가되면 스크롤을 가장 아래로 이동
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500), curve: Curves.ease);
    });

    return Expanded(
      child: ListView.builder(
        controller: scrollController,
        itemCount: widget.messageList.length,
        itemBuilder: (BuildContext context, int index) {
          // 추가된 메시지 내용
          // print(
          //     "[chat_area.dart] (build) 추가된 메시지 내용 : ${widget.messageList[index]}");

          // JSON 문자열을 맵으로 변환
          Map<String, dynamic> data = jsonDecode(widget.messageList[index]);

          if(data['userName'] == widget.userName) {
            return Stack(
              children: [
                Align(
                  alignment: Alignment.topRight,
                child:Text("${data['userName']}"),
                ),
                Align(
                  alignment: Alignment.topRight,
                child:Card(
                  color: Colors.blue,
                  margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: Text(data['message']),
                  ),
                ),
                ),
              ],
            );
          }else {
            return Stack(
              children: [
                Text("${data['userName']}"),
                Card(
                  margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: Text(data['message']),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
