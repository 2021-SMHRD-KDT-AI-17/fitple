import 'package:fitple/screens/chat_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

void main() {
  runApp(const ChatAI(userName: '',userEmail: '',));
}

class ChatAI extends StatelessWidget {
  final String userName;
  final String userEmail;
  const ChatAI({super.key, required this.userName,required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1.0,
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: true,
          leading: IconButton(onPressed: (){
            Navigator.pop(context, MaterialPageRoute(builder: (context) => ChatList(userName: '',userEmail: '',)));},
            icon: Icon(Icons.chevron_left,size: 28,)),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: AssetImage('assets/fitple_bot.png'), // Local asset image
              ),
              SizedBox(width: 5),
              Text(
                'AI 트레이너',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(child: MyHomePage()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Map<String, String>> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final String _apiUrl = 'http://121.147.52.191:5000/api/chatbot';
  String _loadingMessage = '답변 작성 중';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Introduce the AI Trainer at the start
    _introduceTrainer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _introduceTrainer() {
    setState(() {
      _messages.add({
        'sender': 'bot',
        'message': '안녕하세요, 저는 AI 헬스 트레이너 FITPLE입니다. 당신에게 알맞는 운동 일정을 추천해드리겠습니다.',
        'timestamp': DateTime.now().toString()
      });
    });
  }

  void _startLoadingAnimation() {
    _stopLoadingAnimation();
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        if (_loadingMessage.endsWith('...')) {
          _loadingMessage = '답변 작성 중';
        } else {
          _loadingMessage += '.';
        }
        // 마지막 메시지를 업데이트하여 로딩 애니메이션 반영
        if (_messages.isNotEmpty && _messages.last['sender'] == 'bot') {
          _messages.last['message'] = _loadingMessage;
        }
      });
    });
  }

  void _stopLoadingAnimation() {
    _timer?.cancel();
    _loadingMessage = '답변 작성 중';
  }

  Future<void> _postRequest(String question) async {
    setState(() {
      _messages.add({'sender': 'bot', 'message': _loadingMessage, 'timestamp': DateTime.now().toString()});
    });
    _startLoadingAnimation();

    try {
      final response = await http
          .post(
        Uri.parse(_apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'question': question}),
      )
          .timeout(const Duration(seconds: 300));  // 타임아웃을 300초로 설정

      _stopLoadingAnimation();

      if (response.statusCode == 200) {
        final responseMessage = json.decode(response.body)['response'];
        setState(() {
          _messages.removeLast();
          _messages.add({'sender': 'bot', 'message': responseMessage, 'timestamp': DateTime.now().toString()});
        });
      } else {
        setState(() {
          _messages.removeLast();
          _messages.add({'sender': 'bot', 'message': 'Failed to get recommendation: ${response.statusCode}', 'timestamp': DateTime.now().toString()});
        });
      }
    } catch (e) {
      _stopLoadingAnimation();
      setState(() {
        _messages.removeLast();
        _messages.add({'sender': 'bot', 'message': 'Error: $e', 'timestamp': DateTime.now().toString()});
      });
    }
  }

  void _sendMessage() {
    final question = _controller.text.trim();
    if (question.isNotEmpty) {
      setState(() {
        _messages.add({'sender': 'user', 'message': question, 'timestamp': DateTime.now().toString()});
        _controller.clear();
      });
      _postRequest(question);
    }
  }

  String _formatTimestamp(String? timestamp) {
    if (timestamp == null) return '';
    final DateTime dateTime = DateTime.parse(timestamp);
    return '${dateTime.year}년 ${dateTime.month}월 ${dateTime.day}일, ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildMessageItem(Map<String, String> messageData, bool isUser) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isUser)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage('assets/fitple_bot.png'), // Local asset image
            ),
          ),
        Flexible(
          child: Align(
            alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: isUser ? Colors.blue : Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    messageData['message'] ?? '',
                    style: TextStyle(
                      fontSize: 14,
                      color: isUser ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    _formatTimestamp(messageData['timestamp']),
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (isUser)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage('https://via.placeholder.com/150'), // Replace with actual user image URL
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final message = _messages[index];
              final isUser = message['sender'] == 'user';
              return _buildMessageItem(message, isUser);
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8.0),
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'Message...',
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send, color: Colors.blue),
                onPressed: _sendMessage,
              ),
            ],
          ),
        ),
      ],
    );
  }
}