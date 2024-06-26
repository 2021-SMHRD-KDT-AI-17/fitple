import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitple/screens/chat_ai.dart';
import 'package:fitple/screens/chat_tr.dart';
import 'package:fitple/DB/chatDB.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAuth.instance.signInAnonymously();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white, // Set scaffold background to white
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white, // Set AppBar background to white
          elevation: 0.0, // Remove AppBar elevation
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),
      home: const ChatList(userName: '', userEmail: ''),
    ),
  );
}

class ChatList extends StatefulWidget {
  final String userName;
  final String userEmail;
  const ChatList({super.key, required this.userName, required this.userEmail});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  late Future<Map<String, Map<String, String>>> chatListFuture;

  @override
  void initState() {
    super.initState();
    chatListFuture = c_list(widget.userEmail);
  }

  Future<String?> _getImageUrlFromFirebase(String? imagePath) async {
    if (imagePath == null || imagePath.isEmpty) {
      return null;
    }
    try {
      final ref = firebase_storage.FirebaseStorage.instance.refFromURL(imagePath);
      return await ref.getDownloadURL();
    } catch (e) {
      print("Error getting image URL from Firebase: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(left: 30, top: 15),
                child: Text(
                  '채팅 목록',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 15),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatAI(
                        userName: widget.userName,
                        userEmail: widget.userEmail,
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white, // Ensure the container background is white
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blueAccent, width: 2),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CircleAvatar(
                            radius: 16,
                            backgroundImage: AssetImage('assets/fitple_bot.png'), // Local asset image
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: Container(
                          height: 50,
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'AI 트레이너',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '안녕하세요 AI 트레이너 입니다.',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              FutureBuilder<Map<String, Map<String, String>>>(
                future: chatListFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(); // 데이터를 가져올 때까지 로딩 표시
                  } else if (snapshot.hasError) {
                    return Text('에러 발생: ${snapshot.error}');
                  } else {
                    final chatList = snapshot.data;
                    if (chatList != null && chatList.isNotEmpty) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: chatList.length,
                        itemBuilder: (context, index) {
                          final sendNick = chatList.keys.elementAt(index);
                          final chatData = chatList.values.elementAt(index);
                          final chat = chatData['chat'] ?? '';
                          final receiveEmail = chatData['receiveEmail'] ?? '';
                          final sendEmail = chatData['sendEmail'] ?? '';
                          final chatTime = chatData['chatTime'] ?? '';
                          final trainerPicture = chatData['trainerPicture'] ?? '';

                          return GestureDetector(
                            onTap: () {
                              // 채팅 화면으로 이동하는 코드
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatTr(
                                    userName: widget.userName,
                                    sendNick: sendNick,
                                    userEmail: widget.userEmail,
                                    receiveEmail: sendEmail,
                                    sendEmail: receiveEmail,
                                    chatTime: chatTime,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white, // Ensure the container background is white
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.blueAccent, width: 2),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: FutureBuilder<String?>(
                                        future: _getImageUrlFromFirebase(trainerPicture),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return CircularProgressIndicator();
                                          } else if (snapshot.hasError || !snapshot.hasData) {
                                            return CircleAvatar(
                                              radius: 16,
                                              backgroundImage: AssetImage('assets/train1.png'),
                                            );
                                          } else {
                                            return CircleAvatar(
                                              radius: 16,
                                              backgroundImage: NetworkImage(snapshot.data!),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Expanded(
                                    child: Container(
                                      height: 50,
                                      alignment: Alignment.centerLeft,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            sendNick, // 트레이너 이메일 대신 사용자 이름을 보여줄 수도 있습니다.
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            chat,
                                            style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return Text('채팅 목록이 없습니다.');
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}