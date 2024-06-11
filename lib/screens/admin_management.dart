import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fitple/DB/adminDB.dart';
import 'package:fitple/DB/LoginDB.dart';

class AdminManagement extends StatefulWidget {
  final List<Map<String, dynamic>> initialMembers;

  AdminManagement({required this.initialMembers});

  @override
  State<AdminManagement> createState() => _AdminManagementState();
}

class _AdminManagementState extends State<AdminManagement> {
  List<Map<String, dynamic>> members = [];

  @override
  void initState() {
    super.initState();
    members = widget.initialMembers;
    fetchMembers(); // 초기 데이터 로드
  }

  Future<void> fetchMembers() async {
    try {
      List<Map<String, dynamic>> fetchedMembers = await selectMember();
      setState(() {
        members = fetchedMembers;
      });
    } catch (e) {
      // 오류 처리
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching members: $e')),
      );
    }
  }

  Future<void> removeMember(String userEmail) async {
    await logout(userEmail);
    setState(() {
      members.removeWhere((member) => member['user_email'] == userEmail);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원관리'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Color(0x4CE0E0E0),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Color(0xFFE0E0E0)),
          ),
          child: Column(
            children: [
              TextButton(
                onPressed: fetchMembers,
                child: Text('회원 업데이트'),
              ),
              for (var member in members)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            member['user_email'],
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                          Text(member['user_nick']),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('알림'),
                                content: Text('회원을 탈퇴 시키겠습니까?'),
                                actions: [
                                  TextButton(
                                    child: Text('네'),
                                    onPressed: () async {
                                      Navigator.of(context).pop(); // 다이얼로그 닫기
                                      await removeMember(member['user_email']);
                                    },
                                  ),
                                  TextButton(
                                    child: Text('아니오'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Container(
                          width: 50,
                          height: 30,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Text(
                            '탈퇴',
                            style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
