import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:fitple/DB/GymDB.dart';
import 'dart:typed_data';


class Search2 extends StatefulWidget {
  const Search2({super.key});

  @override
  State<Search2> createState() => _SearchState();
}

class _SearchState extends State<Search2> {
  final searchCon = TextEditingController(); // 검색창 컨트롤러
  String? selectedAnswer1;
  String? selectedAnswer2;
  List<Map<String, dynamic>> gyms = [];
  bool isLoading = false;

  Future<void> fetchGyms() async {
    setState(() {
      isLoading = true;
    });

    int shower = (selectedAnswer1 == '예') ? 1 : 0;
    int parking = (selectedAnswer2 == '예') ? 1 : 0;

    gyms = await Gym_DBService.fetchGyms(
      shower: shower,
      parking: parking,
      searchKeyword: searchCon.text,
    );

    setState(() {
      isLoading = false;
    });
  }

  Uint8List? _getImageBytes(String? base64String) {
    if (base64String == null || base64String.isEmpty) {
      return null;
    }
    try {
      return base64Decode(base64String);
    } catch (e) {
      print("Base64 decoding error: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('검색'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 10, right: 16),
                  child: TextFormField(
                    controller: searchCon,
                    onChanged: (text) {
                      setState(() {});
                    },
                    maxLines: 1,
                    textInputAction: TextInputAction.search,
                    onFieldSubmitted: (String) {
                      fetchGyms();
                    },
                    decoration: InputDecoration(
                      hintText: '검색어를 입력하세요',
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blueAccent,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      suffixIcon: IconButton(
                        onPressed: fetchGyms,
                        icon: Icon(
                          Icons.search,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(left: 16, top: 35, right: 16),
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    ' 샤워실 유무',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 16, top: 20, right: 16),
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedAnswer1 = '예';
                          });
                          fetchGyms();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 100,
                          height: 35,
                          decoration: BoxDecoration(
                            color: selectedAnswer1 == '예'
                                ? Colors.blueAccent
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '예',
                            style: TextStyle(
                              color: selectedAnswer1 == '예'
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedAnswer1 = '아니오';
                          });
                          fetchGyms();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 100,
                          height: 35,
                          decoration: BoxDecoration(
                            color: selectedAnswer1 == '아니오'
                                ? Colors.blueAccent
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '아니오',
                            style: TextStyle(
                              color: selectedAnswer1 == '아니오'
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(left: 16, top: 35, right: 16),
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    ' 주차장 유무',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 16, top: 20, right: 16),
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedAnswer2 = '예';
                          });
                          fetchGyms();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 100,
                          height: 35,
                          decoration: BoxDecoration(
                            color: selectedAnswer2 == '예'
                                ? Colors.blueAccent
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '예',
                            style: TextStyle(
                              color: selectedAnswer2 == '예'
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedAnswer2 = '아니오';
                          });
                          fetchGyms();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 100,
                          height: 35,
                          decoration: BoxDecoration(
                            color: selectedAnswer2 == '아니오'
                                ? Colors.blueAccent
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '아니오',
                            style: TextStyle(
                              color: selectedAnswer2 == '아니오'
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (isLoading)
                  CircularProgressIndicator()
                else if (gyms.isNotEmpty)
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: gyms.length,
                    itemBuilder: (context, index) {
                      final gym = gyms[index];
                      final imageBytes = _getImageBytes(gym['gym_picture']);

                      return ListTile(
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        leading: Container(
                          width: 80,
                          height: 80,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: imageBytes != null
                                ? Image.memory(
                              imageBytes,
                              fit: BoxFit.cover,
                            )
                                : Image.asset(
                              'assets/gym_placeholder.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        title: Text(
                          gym['gym_name'] ?? '',
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 5),
                            Text(
                              gym['gym_address'] ?? '',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              gym['gym_phone_number'] ?? '',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                else
                  Text('해당 조건의 헬스장이 없습니다.'),
                SizedBox(height: 20), // Add some bottom spacing
              ],
            ),
          ),
        ),
      ),
    );
  }
}