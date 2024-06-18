import 'dart:convert';
import 'dart:typed_data';
import 'package:fitple/DB/trainerDB.dart';
import 'package:fitple/screens/home_1.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class MyInfoTrainer extends StatefulWidget {
  final String userEmail;
  const MyInfoTrainer({super.key, required this.userEmail});

  @override
  State<MyInfoTrainer> createState() => _MyInfoTrainerState();
}

class _MyInfoTrainerState extends State<MyInfoTrainer> {
  final TextEditingController introduceCon = TextEditingController();
  final TextEditingController emailCon = TextEditingController();
  final TextEditingController pwCon = TextEditingController();
  final TextEditingController repwCon = TextEditingController();
  final TextEditingController nameCon = TextEditingController();
  final TextEditingController genderCon = TextEditingController();
  final TextEditingController ageCon = TextEditingController();
  final TextEditingController gymCon = TextEditingController();
  final TextEditingController trainerInfoCon = TextEditingController();
  final TextEditingController introCon = TextEditingController(); // 한줄 소개 컨트롤러 추가

  Uint8List? _imageBytes;
  File? _image;

  @override
  void initState() {
    super.initState();
    _loadTrainerInfo();
  }

  Future<void> _loadTrainerInfo() async {
    var userResult = await trainerselect(widget.userEmail);
    if (userResult != null) {
      setState(() {
        emailCon.text = widget.userEmail;
        nameCon.text = userResult['trainer_name'] ?? '';
        genderCon.text = userResult['gender'] ?? '';
        ageCon.text = userResult['age'] ?? '';
        gymCon.text = userResult['gym_name'] ?? '';
        trainerInfoCon.text = userResult['trainer_info'] ?? '';
        introCon.text = userResult['trainer_intro'] ?? ''; // 한줄 소개 값을 설정
        if (userResult['trainer_picture'] != null) {
          _loadImageFromUrl(userResult['trainer_picture']);
        }
      });
    } else {
      print('null값임!!');
    }
  }

  Future<void> _loadImageFromUrl(String url) async {
    try {
      final response = await HttpClient().getUrl(Uri.parse(url));
      final responseBody = await response.close(); // 여기서 close() 호출로 HttpClientResponse를 가져옴
      final bytes = await consolidateHttpClientResponseBytes(responseBody);
      setState(() {
        _imageBytes = bytes;
      });
    } catch (e) {
      print('Error loading image: $e');
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _image = File(image.path);
        _imageBytes = bytes;
      });
    }
  }

  Future<String?> uploadImageToFirebase(Uint8List imageBytes, String fileName) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child('images/$fileName');
      final uploadTask = storageRef.putData(imageBytes);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> updateTrainerInfo(String trainerEmail, String trainerName, String gender, int? age, int? gymIdx, Uint8List? trainerPicture, String trainerInfo, String trainerIntro) async {
    final conn = await dbConnector();

    try {
      String? pictureUrl;
      if (trainerPicture != null) {
        pictureUrl = await uploadImageToFirebase(trainerPicture, 'trainer_${DateTime.now().millisecondsSinceEpoch}.jpg');
      }

      String query = "UPDATE fit_trainer SET trainer_name = :trainer_name, gender = :gender, trainer_intro = :trainer_intro";
      Map<String, dynamic> parameters = {
        "trainer_name": trainerName,
        "gender": gender,
        "trainer_intro": trainerIntro,
        "trainer_email": trainerEmail
      };

      if (age != null) {
        query += ", age = :age";
        parameters["age"] = age;
      }

      if (gymIdx != null) {
        query += ", gym_idx = :gym_idx";
        parameters["gym_idx"] = gymIdx;
      }

      if (pictureUrl != null) {
        query += ", trainer_picture = :trainer_picture";
        parameters["trainer_picture"] = pictureUrl;
      }

      query += " WHERE trainer_email = :trainer_email";

      await conn.execute(query, parameters);
      print('Trainer info updated successfully');
    } catch (e) {
      print('Error updating trainer info: $e');
    } finally {
      await conn.close();
    }
  }

  Future<void> _saveChanges() async {
    try {
      String trainerName = nameCon.text;
      String gender = genderCon.text;
      int? age = int.tryParse(ageCon.text);
      int? gymIdx = int.tryParse(gymCon.text);
      String trainerInfo = trainerInfoCon.text;
      String trainerIntro = introCon.text; // 한줄 소개 값 가져오기

      Uint8List? imageBytes;
      if (_image != null) {
        imageBytes = await _image!.readAsBytes();
      }

      await updateTrainerInfo(widget.userEmail, trainerName, gender, age, gymIdx, imageBytes, trainerInfo, trainerIntro); // 한줄 소개 추가
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('알림'),
            content: Text('회원정보가 수정되었습니다.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Home1(userName: trainerName, userEmail: widget.userEmail, Check: '1')));
                },
                child: Text('닫기'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('오류'),
            content: Text('입력 값이 올바르지 않습니다.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('닫기'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          '회원 정보 수정',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
        ),
        actions: [
          TextButton(
            onPressed: _saveChanges,
            child: Text(
              '완료',
              style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(1000),
                    ),
                  ),
                  child: _image != null
                      ? Image.file(_image!, fit: BoxFit.cover)
                      : (_imageBytes != null
                      ? Image.memory(_imageBytes!, fit: BoxFit.cover)
                      : Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/basicimage.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )),
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: _pickImage,
                    child: Text(
                      '사진 변경',
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: introCon,
                  decoration: InputDecoration(
                    labelText: '한줄 소개',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 1,
                ),
                SizedBox(height: 20),
                TextField(
                  controller: trainerInfoCon,
                  decoration: InputDecoration(
                    labelText: '소개',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: null,
                ),
                Container(
                  margin: EdgeInsets.only(top: 30),
                  height: 1,
                  color: Colors.grey[300],
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Text(
                            '이메일',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                            emailCon.text,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Text(
                            '비밀번호 변경',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          child: TextField(
                            controller: pwCon,
                            obscureText: true,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Colors.black12)),
                              contentPadding: EdgeInsets.only(left: 0.1),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Text(
                            '비밀번호 확인',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          child: TextField(
                            controller: repwCon,
                            obscureText: true,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Colors.black12)),
                              contentPadding: EdgeInsets.only(left: 0.1),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Text(
                            '이름',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                            nameCon.text,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Text(
                            '성별',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                            genderCon.text,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Text(
                            '나이',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                            ageCon.text,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Text(
                            '소속',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                            gymCon.text,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 40),
                  height: 1,
                  color: Colors.grey[300],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}