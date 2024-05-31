import 'package:fitple/screens/chat_list.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ChatTr());
}

class ChatTr extends StatefulWidget {
  const ChatTr({Key? key}) : super(key: key);

  @override
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
