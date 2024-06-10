import 'dart:io';

import 'package:fitple/screens/map.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:time_picker_spinner_pop_up/time_picker_spinner_pop_up.dart';

class TrainerGym extends StatefulWidget {
  final String gymName;
  final String address;
  final ValueChanged<String> onAddressUpdated;

  const TrainerGym({
    Key? key,
    required this.gymName,
    required this.address,
    required this.onAddressUpdated,
  }) : super(key: key);

  @override
  State<TrainerGym> createState() => _TrainerGymState();
}

class _TrainerGymState extends State<TrainerGym> {
  late String _address;

  final gymAddCon = TextEditingController(); // 주소 컨트롤러
  final detailAddCon = TextEditingController(); // 주소 컨트롤러
  final telCon = TextEditingController(); // 전화번호 컨트롤러
  final productCon = TextEditingController(); // 상품이름 컨트롤러
  final priceCon = TextEditingController(); // 가격 컨트롤러

  File? _image;

  Future<void> _pickImage() async {
    try {
      final pickedFile =
      await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } catch (e) {
      print('이미지를 선택할 수 없습니다: $e');
    }
  }

  List<Map<String, dynamic>> textfieldWidgets = [];

  @override
  void initState() {
    super.initState();
    _address = widget.address;
    gymAddCon.text = _address; // 도로명 주소 설정
  }

  void _updateAddress(String newAddress, String newDetailAddress) {
    setState(() {
      _address = newAddress;
      widget.onAddressUpdated(newAddress);
      detailAddCon.text = newDetailAddress; // 상세주소 설정
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('헬스장 관리'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 16),
                  child: Text(
                    widget.gymName,
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ), // db 불어올 값
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      padding: EdgeInsets.only(left: 16),
                      height: _image != null ? 400 : 50, // 이미지 선택 여부에 따라 높이 조정
                      decoration: BoxDecoration(
                        image: _image != null
                            ? DecorationImage(
                          image: FileImage(_image!),
                          fit: BoxFit.fill,
                        )
                            : DecorationImage(
                          image: AssetImage('assets/placeholder.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: _image == null
                          ? Center(
                        child: Text(
                          '이미지를 선택하려면 여기를 누르세요',
                          style: TextStyle(color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      )
                          : null,
                    ),
                  ),
                ),

                // 헬스장 위치
                Container(
                  padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '헬스장 위치',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => NaverMapApp(
                                onAddressSelected: (newAddress, newDetailAddress) {
                                  _updateAddress(newAddress, newDetailAddress);
                                },
                              ),
                            ),
                          );
                        },
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: gymAddCon,
                            onChanged: (text) {
                              setState(() {});
                            },
                            maxLength: 150,
                            maxLines: 1,
                            textInputAction: TextInputAction.done,
                            decoration: const InputDecoration(
                              hintText: '도로명 주소 찾기',
                              counterText: '',
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blueAccent,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 12),
                            ),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: TextFormField(
                          controller: detailAddCon,
                          onChanged: (text) {
                            setState(() {});
                          },
                          maxLength: 150,
                          maxLines: 1,
                          textInputAction: TextInputAction.done,
                          decoration: const InputDecoration(
                            hintText: '상세주소 입력',
                            counterText: '',
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blueAccent,
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                          ),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 16, top: 32, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '전화번호',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: telCon,
                        keyboardType: TextInputType.number,
                        onChanged: (text) {
                          setState(() {});
                        },
                        maxLength: 150,
                        maxLines: 1,
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                          hintText: '전화번호',
                          counterText: '',
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blueAccent,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 8, horizontal: 12),
                        ),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: EdgeInsets.only(left: 16, top: 32, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          child: Text(
                            '영업시간',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            child: Row(
                              children: [
                                Text(
                                  '시작',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                TimePickerSpinnerPopUp(
                                  mode: CupertinoDatePickerMode.time,
                                  initTime: DateTime.now(),
                                  onChange: (dateTime) {
                                    // Implement your logic with select dateTime
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Container(
                            child: Row(
                              children: [
                                Text(
                                  '종료',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                TimePickerSpinnerPopUp(
                                  mode: CupertinoDatePickerMode.time,
                                  initTime: DateTime.now(),
                                  onChange: (dateTime) {
                                    // Implement your logic with select dateTime
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: EdgeInsets.only(left: 16, top: 32, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '전화번호',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: telCon,
                        keyboardType: TextInputType.number,
                        onChanged: (text) {
                          setState(() {});
                        },
                        maxLength: 150,
                        maxLines: 1,
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                          hintText: '전화번호',
                          counterText: '',
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blueAccent,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 8, horizontal: 12),
                        ),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(left: 16, top: 32, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '상품',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.all(16),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.black54)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '상품이 등록되지 않았습니다.',
                              style: TextStyle(
                                color: Colors.black54,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '상품 DB에서 불러오기',
                                  style: TextStyle(
                                    color: Colors.black54,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.black26,
                                          borderRadius:
                                          BorderRadius.circular(50)),
                                      child: Icon(
                                        Icons.remove,
                                        size: 18,
                                      )),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '상품 추가',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFormField(
                                  controller: productCon,
                                  onChanged: (text) {
                                    setState(() {});
                                  },
                                  maxLength: 150,
                                  maxLines: 1,
                                  textInputAction: TextInputAction.done,
                                  decoration: const InputDecoration(
                                    hintText: '상품명을 입력해주세요',
                                    counterText: '',
                                    border: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 12),
                                  ),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(height: 8),
                                TextFormField(
                                  controller: priceCon,
                                  onChanged: (text) {
                                    setState(() {});
                                  },
                                  maxLength: 150,
                                  maxLines: 1,
                                  textInputAction: TextInputAction.done,
                                  decoration: const InputDecoration(
                                    hintText: '가격을 입력해주세요',
                                    counterText: '',
                                    border: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 12),
                                  ),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                textfieldWidgets.add({
                                  'productController': TextEditingController(
                                      text: productCon.text),
                                  'priceController': TextEditingController(
                                      text: priceCon.text),
                                });
                                productCon.clear();
                                priceCon.clear();
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Icon(Icons.add, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Column(
                        children: textfieldWidgets.map((widgetData) {
                          return Column(
                            children: [
                              _buildProductRow(widgetData),
                              SizedBox(height: 16), // 위젯 간의 간격 조절
                            ],
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
      ),
    );
  }

  Widget _buildProductRow(Map<String, dynamic> widgetData) {
    final productController = widgetData['productController'];
    final priceController = widgetData['priceController'];

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: productController,
                maxLength: 150,
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: '상품명을 입력해주세요',
                  counterText: '',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blueAccent,
                    ),
                  ),
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                ),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: priceController,
                maxLength: 150,
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: '가격을 입력해주세요',
                  counterText: '',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blueAccent,
                    ),
                  ),
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                ),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 8),
        GestureDetector(
          onTap: () {
            setState(() {
              textfieldWidgets.remove(widgetData);
            });
          },
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(Icons.remove, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
