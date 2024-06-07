import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:time_picker_spinner_pop_up/time_picker_spinner_pop_up.dart';

class TrainerGym extends StatefulWidget {
  const TrainerGym({Key? key}) : super(key: key);

  @override
  State<TrainerGym> createState() => _TrainerGymState();
}

class _TrainerGymState extends State<TrainerGym> {
  final gymAddCon = TextEditingController(); // 주소 컨트롤러
  final detailAddCon = TextEditingController(); // 주소 컨트롤러
  final telCon = TextEditingController(); // 전화번호 컨트롤러
  final productCon = TextEditingController(); // 상품이름 컨트롤러
  final priceCon = TextEditingController(); // 가격 컨트롤러

  List<Map<String, dynamic>> textfieldWidgets = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('헬스장 관리'),
        centerTitle: true,
        actions: [TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('완료',
            style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 16,
                fontWeight: FontWeight.bold
            ),),
        ),],
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
                  child: Text('헬스장 명',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),), // db 불어올 값
                ),

                Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 15, top: 20, right: 15),
                        width: double.infinity,
                        height: 300,
                        child: Container(
                          alignment: Alignment.center,
                          width: 140,
                          height: 138,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/gym1.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          '사진 변경',
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),


                // 헬스장 위치
                Container(
                  padding: EdgeInsets.only(left: 16, top: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('헬스장 위치',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.only( right: 16),
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
                            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          ),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top : 5, right: 16),
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
                            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
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
                  padding: EdgeInsets.only(left: 16, top: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text('영업시간',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            child: Row(
                              children: [
                                Text('시작',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),),
                                SizedBox(width: 10,),
                                Positioned(
                                    child: TimePickerSpinnerPopUp(
                                      mode: CupertinoDatePickerMode.time,
                                      initTime: DateTime.now(),
                                      onChange: (dateTime) {
                                        // Implement your logic with select dateTime
                                      },
                                    )
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 15,),
                          Container(
                            child: Row(
                              children: [
                                Text('종료',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),),
                                SizedBox(width: 10,),
                                Positioned(
                                    child: TimePickerSpinnerPopUp(
                                      mode: CupertinoDatePickerMode.time,
                                      initTime: DateTime.now(),
                                      onChange: (dateTime) {
                                        // Implement your logic with select dateTime
                                      },
                                    )
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
                  padding: EdgeInsets.only(left: 16, top: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('전화번호',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.only( right: 16),
                        child: TextFormField(
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
                            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
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
                  margin: EdgeInsets.only(left: 16, top: 32, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('상품',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),),
                      SizedBox(height: 10,),
                      Container(
                        padding: EdgeInsets.all(16),
                        width: double.infinity,
                        decoration:BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.black54)
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('상품이 등록되지 않았습니다.',
                              style: TextStyle(
                                color: Colors.black54,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('상품 DB에서 불러오기',
                                  style: TextStyle(
                                  color: Colors.black54,
                                ),
                                ),
                                GestureDetector(
                                  onTap: (){},
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black26,
                                      borderRadius: BorderRadius.circular(50)
                                    ),
                                      child: Icon(Icons.remove, size: 18,)),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16,),
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
                                    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
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
                                    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
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
                                  'productController': TextEditingController(text: productCon.text),
                                  'priceController': TextEditingController(text: priceCon.text),
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
                  contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
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
                  contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
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
