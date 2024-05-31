import 'package:fitple/screens/mypage.dart';
import 'package:flutter/material.dart';

class MyInfo extends StatefulWidget {
  const MyInfo({super.key});

  @override
  State<MyInfo> createState() => _MyInfoState();
}

class _MyInfoState extends State<MyInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(onPressed: (){Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyPage()));},
          icon: Icon(Icons.arrow_back_ios_new), iconSize: 20.0,),
        title: Text('회원 정보 수정', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19 ),),
        actions: [
          TextButton(
            onPressed: () {Navigator.pop(
              context,
              MaterialPageRoute(builder: (context) => MyPage()),
            );},
            child: Text(
              '완료',
              style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 16,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Container(
                  width: 100,
                  height: 100,
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    //color: Color(0xFFF7F7F7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(1000),
                    ),
                  ),
                  child: Container(
                    width: 140,
                    height: 138,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/i1.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      '사진 변경',
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
               Container(margin: EdgeInsets.only(top: 30),height: 1, color: Colors.grey[300],),
               Container(
                 //color: Colors.grey,
                  width: 500,
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 25),
                        child: Text('이메일',style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                      ),
                      SizedBox(width: 32,),
                      Container(
                        //color: Colors.red,
                        child: Container(
                          width: 230,
                          child: TextField(
                            //controller: emailCon,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black12)),
                              //border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 0.1),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  //color: Colors.grey,
                  width: 500,
                  margin: EdgeInsets.only(top: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only( top: 25),
                        child: Text('비밀번호 변경',style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                      ),
                      //SizedBox(width: 0,),
                      Container(
                        //color: Colors.red,
                        child: Container(
                          width: 230,
                          child: TextField(
                            //controller: emailCon,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black12)),
                              //border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 0.1),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  //color: Colors.grey,
                  width: 500,
                  margin: EdgeInsets.only(top: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only( top: 25),
                        child: Text('비밀번호 확인',style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                      ),
                      //SizedBox(width: 0,),
                      Container(
                        //color: Colors.red,
                        child: Container(
                          width: 230,
                          child: TextField(
                            //controller: emailCon,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black12)),
                              //border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 0.1),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  //color: Colors.grey,
                  width: 500,
                  margin: EdgeInsets.only(top: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 25),
                        child: Text('이름',style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                      ),
                      SizedBox(width: 38,),
                      Container(
                        //color: Colors.red,
                        child: Container(
                          width: 230,
                          child: TextField(
                            //controller: emailCon,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black12)),
                              //border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 0.1),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                 // color: Colors.grey,
                  width: 500,
                  margin: EdgeInsets.only(top: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 25),
                        child: Text('닉네임',style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                      ),
                      SizedBox(width: 32,),
                      Container(
                        //color: Colors.red,
                        child: Container(
                          width: 230,
                          child: TextField(
                            //controller: emailCon,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black12)),
                              //border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 0.1),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  //color: Colors.grey,
                  width: 500,
                  margin: EdgeInsets.only(top: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 25),
                        child: Text('성별',style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                      ),
                      SizedBox(width: 38,),
                      Container(
                        //color: Colors.red,
                        child: Container(
                          width: 230,
                          child: TextField(
                            //controller: emailCon,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black12)),
                              //border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 0.1),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  //color: Colors.grey,
                  width: 500,
                  margin: EdgeInsets.only(top: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 25),
                        child: Text('나이',style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                      ),
                      SizedBox(width: 38,),
                      Container(
                        //color: Colors.red,
                        child: Container(
                          width: 230,
                          child: TextField(
                            //controller: emailCon,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black12)),
                              //border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 0.1),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(margin: EdgeInsets.only(top: 40),height: 1, color: Colors.grey[300],),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
