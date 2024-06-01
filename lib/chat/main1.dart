import 'package:flutter/material.dart';
import 'package:fitple/chat/chat_main.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Test1Page(), // Test1Page를 MaterialApp의 home으로 설정
    );
  }
}

class Test1Page extends StatelessWidget {
  const Test1Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 텍스트필드 컨트롤러
    TextEditingController textEditingController = TextEditingController();

    return Scaffold(
      body: Center(
        child: Container(
          width: 250,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.grey,
              width: 2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // 유저 이름 입력
              SizedBox(
                width: 200,
                child: TextField(
                  controller: textEditingController,
                  decoration: const InputDecoration(
                    label: Center(child: Text("사용자 이름 입력")),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  String txtValue = textEditingController.text;
                  txtValue = txtValue.trim();
                  if (txtValue != "") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return ChatMainPage(
                          userName: txtValue,
                        );
                      }),
                    );
                  }
                },
                child: const Text("확인"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
