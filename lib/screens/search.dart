import 'package:flutter/material.dart';
import 'package:fitple/DB/DB.dart'; // DBService를 import합니다.
import 'package:fitple/DB/mt_test.dart';
import 'package:fitple/DB/GymDB.dart';
import 'dart:typed_data';
import 'dart:convert';

// Trainer 페이지를 import합니다.
import 'package:fitple/screens/trainer.dart';

class Search extends StatefulWidget {
  final String userEmail;
  final String userName;
  const Search({
    Key? key,
    required this.userEmail,
    required this.userName,
  }) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final searchCon = TextEditingController();
  String? selectedGender;
  String? selectedAgeGroup;
  List<Map<String, dynamic>> trainers = [];
  bool isLoading = false;

  final List<String> ageGroups = ['20대', '30대', '40대', '50대'];

  Future<void> fetchTrainers() async {
    setState(() {
      isLoading = true;
    });

    String? ageQuery;
    if (selectedAgeGroup != null) {
      if (selectedAgeGroup == '20대') {
        ageQuery = "'20', '21', '22', '23', '24', '25', '26', '27', '28', '29'";
      } else if (selectedAgeGroup == '30대') {
        ageQuery = "'30', '31', '32', '33', '34', '35', '36', '37', '38', '39'";
      } else if (selectedAgeGroup == '40대') {
        ageQuery = "'40', '41', '42', '43', '44', '45', '46', '47', '48', '49'";
      } else if (selectedAgeGroup == '50대') {
        ageQuery = "'50', '51', '52', '53', '54', '55', '56', '57', '58', '59'";
      }
    }

    trainers = await DBService.fetchTrainers(
      gender: selectedGender ?? '',
      ageQuery: ageQuery ?? '',
      searchKeyword: searchCon.text,
    );

    setState(() {
      isLoading = false;
    });
  }

  void onGenderSelected(String gender) {
    setState(() {
      selectedGender = gender;
      fetchTrainers();
    });
  }

  void onAgeGroupSelected(String ageGroup) {
    setState(() {
      selectedAgeGroup = ageGroup;
      fetchTrainers();
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
                      fetchTrainers();
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
                        onPressed: fetchTrainers,
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
                    '나는 이런 트레이너를 원해요 !',
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
                          onGenderSelected('남자');
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 100,
                          height: 35,
                          decoration: BoxDecoration(
                            color: selectedGender == '남자'
                                ? Colors.blueAccent
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '남자',
                            style: TextStyle(
                              color: selectedGender == '남자'
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
                          onGenderSelected('여자');
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 100,
                          height: 35,
                          decoration: BoxDecoration(
                            color: selectedGender == '여자'
                                ? Colors.blueAccent
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '여자',
                            style: TextStyle(
                              color: selectedGender == '여자'
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
                  margin: EdgeInsets.only(left: 16, top: 20, right: 16),
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: ageGroups.map((ageGroup) {
                      return GestureDetector(
                        onTap: () {
                          onAgeGroupSelected(ageGroup);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          width: 60,
                          height: 35,
                          decoration: BoxDecoration(
                            color: selectedAgeGroup == ageGroup
                                ? Colors.blueAccent
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            ageGroup,
                            style: TextStyle(
                              color: selectedAgeGroup == ageGroup
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                if (trainers != null && trainers.isNotEmpty)
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: trainers.length,
                    itemBuilder: (context, index) {
                      final trainer = trainers[index];
                      if (trainer != null) {
                        final imageBytes = _getImageBytes(trainer['trainer_picture']);
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Trainer(
                                  trainerName: trainer['trainer_name'] ?? '',
                                  gymName: trainer['gym_name'] ?? '무소속',
                                  trainerEmail: trainer['trainer_email'] ?? '',
                                  trainerPicture: imageBytes, // Uint8List 형식으로 전달
                                  userEmail: widget.userEmail,
                                  userName: widget.userName,
                                ),
                              ),
                            );
                          },
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
                                  width: 80,
                                  height: 80,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: imageBytes != null
                                        ? Image.memory(
                                      imageBytes,
                                      fit: BoxFit.cover,
                                      width: 70,
                                      height: 70,
                                    )
                                        : Image.asset(
                                      'assets/train1.png',
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
                                          trainer['trainer_name'] ?? '',
                                          style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 3),
                                        Text(
                                          trainer['gym_name'] ?? '무소속',
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(height: 3),
                                        Expanded( // Ensure the Text widget expands within the available space
                                          child: Text(
                                            trainer['trainer_intro'] ?? '바디프로필, 다이어트, 대회준비 전문',
                                            style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 13,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
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
                      } else {
                        return SizedBox();
                      }
                    },
                  )
                else
                  Text('해당 조건의 트레이너가 없습니다.'),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
