import 'dart:io';
import 'dart:typed_data';
import 'package:fitple/screens/trainer.dart';
import 'package:flutter/material.dart';
import 'package:fitple/DB/GymDB.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';

class Info extends StatefulWidget {
  final String userEmail;
  final int gymIdx;

  const Info({Key? key, required this.userEmail, required this.gymIdx}) : super(key: key);

  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {
  Map<String, dynamic>? _gymDetails;
  List<Map<String, dynamic>> _trainers = [];
  List<Map<String, dynamic>> _items = [];
  List<Map<String, dynamic>> _reviews = [];
  bool _isLoading = true;
  File? _image;
  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();
    fetchGymDetails();
    fetchTrainers();
    fetchGymItems();
    fetchGymReviews();
  }

  Future<String> uploadImageToFirebase(File image) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      firebase_storage.Reference storageReference = firebase_storage.FirebaseStorage.instance.ref().child("gym_images/$fileName");

      firebase_storage.UploadTask uploadTask = storageReference.putFile(image);
      await uploadTask.whenComplete(() => null);

      String fileURL = await storageReference.getDownloadURL();
      return fileURL;
    } catch (e) {
      print("Error uploading image: $e");
      throw e;
    }
  }

  void fetchGymDetails() async {
    try {
      Map<String, dynamic> gymDetails = await getGymDetails(widget.gymIdx);
      setState(() {
        _gymDetails = gymDetails;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching gym details: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void fetchTrainers() async {
    try {
      List<Map<String, dynamic>> trainers = await loadTrainersByGym(widget.gymIdx);
      setState(() {
        _trainers = trainers;
      });
    } catch (e) {
      print('Error fetching trainers: $e');
    }
  }

  void fetchGymItems() async {
    try {
      List<Map<String, dynamic>> items = await loadGymItems(widget.gymIdx);
      setState(() {
        _items = items;
      });
    } catch (e) {
      print('Error fetching gym items: $e');
    }
  }

  void fetchGymReviews() async {
    try {
      List<Map<String, dynamic>> reviews = await loadGymReviews(widget.gymIdx);
      setState(() {
        _reviews = reviews;
      });
    } catch (e) {
      print('Error fetching gym reviews: $e');
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

  void _saveGymInfo() async {
    if (_gymDetails == null) {
      print('헬스장 정보가 초기화되지 않았습니다.');
      return;
    }

    String gymName = _gymDetails!['gym_name'] ?? '';
    String gymAddress = _gymDetails!['gym_address'] ?? '';
    String gymPhoneNumber = _gymDetails!['gym_phone_number'] ?? '';
    String gymTime = _gymDetails!['gym_time'] ?? '';

    if (gymName.isEmpty || gymAddress.isEmpty || gymPhoneNumber.isEmpty || gymTime.isEmpty) {
      print('모든 필드를 입력해야 합니다.');
      return;
    }

    String? imageUrl;
    if (_image != null) {
      try {
        imageUrl = await uploadImageToFirebase(_image!);
      } catch (e) {
        print("Error uploading image: $e");
        return;
      }
    }

    await updateGymInfo(gymName, gymAddress, gymPhoneNumber, gymTime, widget.gymIdx, imageUrl);

    _showCompletionDialog(context);
  }

  //수정완료 팝업
  void _showCompletionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("완료"),
          content: Text("수정이 완료되었습니다."),
          actions: <Widget>[
            TextButton(
              child: Text("확인"),
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(_gymDetails?['gym_name'] ?? '헬스장 명'),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 15),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 35),
                alignment: AlignmentDirectional.topStart,
                child: Row(
                  children: [
                    Text(
                      _gymDetails?['gym_name'] ?? '헬스장 이름',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        height: 1.5,
                        letterSpacing: -0.34,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ReviewScreen(reviews: _reviews)),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide.none,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '리뷰 ${_reviews.length}개',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          Icon(
                            size: 18,
                            Icons.navigate_next,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      width: double.infinity,
                      height: 320,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: _imageBytes != null
                              ? MemoryImage(_imageBytes!)
                              : (_gymDetails?['gym_picture'] != null
                              ? NetworkImage(_gymDetails!['gym_picture'])
                              : AssetImage('assets/gym4.jpg')) as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: 400,
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(20),
                      decoration: ShapeDecoration(
                        color: Color(0xFFF5F5F5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.black,
                              ),
                              SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  _gymDetails?['gym_address'] ?? '헬스장 주소',
                                  style: TextStyle(color: Colors.black),
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time_outlined,
                                color: Colors.black,
                              ),
                              SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  _gymDetails?['gym_time'] ?? '헬스장 운영시간',
                                  style: TextStyle(color: Colors.black),
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(
                                Icons.phone,
                                color: Colors.black,
                              ),
                              SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  _gymDetails?['gym_phone_number'] ?? '헬스장 번호',
                                  style: TextStyle(color: Colors.black),
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.attach_money,
                                color: Colors.black,
                              ),
                              SizedBox(width: 2),
                              Expanded(
                                child: Text(
                                  '헬스장 상품',
                                  style: TextStyle(color: Colors.black),
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: _items.map((item) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    item['gym_pt_name'] ?? '상품 이름',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  Text(
                                    '${item['gym_pt_price']} 원',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Column(
                      children: _trainers.map((trainer) {
                        return trainerCard(
                          context,
                          trainer['trainer_name'] ?? '트레이너 이름',
                          _gymDetails?['gym_name'] ?? '헬스장 이름',
                          trainer['trainer_intro'] ?? '트레이너 소개',
                          trainer['trainer_picture'] != null
                              ? NetworkImage(trainer['trainer_picture'])
                              : AssetImage('assets/train1.png') as ImageProvider,
                          trainer['trainer_email'] ?? '', // 트레이너 이메일 추가
                          trainer['trainer_picture'] ?? '', // 트레이너 사진 URL 추가
                        );
                      }).toList(),
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

  Widget trainerCard(BuildContext context, String name, String gym, String specialty, ImageProvider imageProvider, String trainerEmail, String trainerPictureUrl) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Trainer(
              trainerName: name,
              gymName: gym,
              trainerEmail: trainerEmail,
              userEmail: widget.userEmail,
              userName: "userName",
              trainerPictureUrl: trainerPictureUrl, // 수정: 트레이너 사진 URL 전달
            ),
          ),
        );
      },
      child: Container(
        width: 400,
        padding: EdgeInsets.all(20),
        decoration: ShapeDecoration(
          color: Color(0xFFF5F5F5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image(
                  image: imageProvider,
                  fit: BoxFit.cover,
                  width: 70,
                  height: 70,
                ),
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Container(
                height: 80,
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      gym,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      specialty,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReviewScreen extends StatelessWidget {
  final List<Map<String, dynamic>> reviews;
  final bool _isLoading = false;

  ReviewScreen({required this.reviews});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('리뷰'),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: reviews.map((review) {
            return Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review['gym_review_text'] ?? '리뷰 내용 없음',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        review['gym_review_date'] ?? '날짜 없음',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        review['user_nick'] ?? '사용자 없음',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}