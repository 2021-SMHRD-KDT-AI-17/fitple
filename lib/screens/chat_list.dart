import 'package:fitple/screens/chat_ai.dart';
import 'package:fitple/screens/chat_tr.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(
    MaterialApp(
      home: const ChatList(),
    ),
  );
}

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: 30,top: 15),
                  //color: Colors.grey,
                  child: Text('채팅',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),),
                ),
                SizedBox(height: 15,),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blueAccent, width: 2),
                  ),
                  child: Row(
                    children: [
                      Container(
                        //color: Colors.grey,
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
                          //color: Colors.grey,
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
                              //SizedBox(height: 3),
                              Text(
                                '안녕하세요 AI 트레이너 입니다.',
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 12
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                  ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(), // ListView 스크롤 비활성화
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatTr(userName: 'testttt')));},
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.blueAccent, width: 2),
                        ),
                        child: Row(
                          children: [
                            Container(
                              //color: Colors.grey,
                              width: 50,
                              height: 50,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CircleAvatar(
                                  radius: 16,
                                  backgroundImage: AssetImage('assets/train1.png'), // Local asset image
                                ),
                              ),
                            ),
                            SizedBox(width: 15),
                            Expanded(
                              child: Container(
                                //color: Colors.grey,
                                height: 50,
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '박성주 트레이너',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    //SizedBox(height: 3),
                                    Text(
                                      '안녕하세요 박성주 트레이너 입니다.',
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 12
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
                ),
              ],
            ),
          ),
        ),
    );
  }
}
