import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fitple/DB/chatDB.dart';

class ChatArea extends StatefulWidget {
  final List<Map<String, dynamic>> messageList;
  final String userName;
  final String userEmail;
  final String receiveEmail;

  const ChatArea({
    Key? key,
    required this.messageList,
    required this.userName,
    required this.userEmail,
    required this.receiveEmail,
  }) : super(key: key);

  @override
  State<ChatArea> createState() => _ChatAreaState();
}

class _ChatAreaState extends State<ChatArea> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // 위젯 초기화 시 대화 내역을 불러옵니다.
    loadChatHistory();
    // print('zzzz');
    // print(widget.messageList);
  }
  //시간날짜 변환
  String _formatTimestamp(String? timestamp) {
    if (timestamp == null) return '';
    final DateTime dateTime = DateTime.parse(timestamp);
    return '${dateTime.month}월 ${dateTime.day}일, ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void loadChatHistory() async {
    try {
      // 대화 방 번호를 가져오는 함수 호출
      String? roomNum = await roomNumDB(widget.userEmail, widget.receiveEmail);

      if (roomNum != null) {
        // 대화 방 번호를 기반으로 대화 내역을 가져오는 함수 호출
        List<Map<String, String>> fetchedMessages = await chatListDB(roomNum,widget.userEmail);

        setState(() {
          widget.messageList.clear(); // 기존 메시지 삭제
          widget.messageList.addAll(fetchedMessages);
        });

        // 스크롤을 가장 아래로 이동
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease,
        );
      } else {
        // 대화 방 번호를 찾을 수 없는 경우 처리
        print('대화 방 번호를 찾을 수 없습니다.');
      }
    } catch (e) {
      print('대화 내역을 불러오는 중 오류 발생: $e');
    }
  }

  // 새로운 메시지를 받았을 때 호출되는 메소드
  void addNewMessage(Map<String, dynamic> newMessage) {
    setState(() {

      widget.messageList.add(newMessage);
    });



    // 스크롤을 가장 아래로 이동
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    // 리스트뷰에 메시지가 추가되면 스크롤을 가장 아래로 이동
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    });
    return Expanded(
      child: ListView.builder(
        controller: scrollController,
        itemCount: widget.messageList.length,
        itemBuilder: (BuildContext context, int index) {



          // 추가된 메시지 내용
           print(
              "[chat_area.dart] (build) 추가된 메시지 내용 : ${widget.messageList[index]}");

           Map<String, dynamic> data = widget.messageList[index];
          //새로 추가되는메세지에서 데이터 뽑아오기
           //data['userName'];
           //data['message'];

          if (data['userName'] == widget.userName) {
            return Align(
              alignment: Alignment.topRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
               children: [
                 Text("${data['userName']}",style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),),
                 Container(
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color:Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${data['message']}',
                      style: TextStyle(
                        fontSize: 14,
                        color:Colors.white,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      _formatTimestamp(data['chatTime']),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                      ),
                    ),

                  ],
                ),
              ),
          ],
              )
            );
          } else {
            return Align(
              alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text("${data['userName']}",style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),),
                    ),
                    Container(
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        color:Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${data['message']}',
                            style: TextStyle(
                              fontSize: 14,
                              color:Colors.black,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            _formatTimestamp(data['chatTime']),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
            );
          }
          ////////////////////////////////

//////////////////////////////////////
        },
      ),
    );
  }
}
