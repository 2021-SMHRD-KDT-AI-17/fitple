import 'package:flutter/material.dart';
import 'package:fitple/DB/DB.dart'; // DBService를 import합니다.
import 'package:fitple/DB/mt_test.dart';
import 'dart:typed_data';
import 'dart:convert';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final searchCon = TextEditingController(); // 검색창 컨트롤러
  String? selectedGender;
  String? selectedAgeGroup;
  List<Map<String, dynamic>> trainers = [];  // 트레이너 리스트
  bool isLoading = false; // 로딩 상태

  final List<String> ageGroups = ['20대', '30대', '40대', '50대'];

  void toggleSelection(String item, List<String> list) {
    setState(() {
      if (list.contains(item)) {
        list.remove(item);
      } else {
        list.add(item);
      }
    });
  }

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

    String? intro = searchCon.text.isNotEmpty ? searchCon.text : null;

    trainers = await DBService.fetchTrainers(
      gender: selectedGender ?? '',  // 성별 선택 상태를 넘깁니다.
      ageQuery: ageQuery ?? '',      // 나이 그룹 조건을 넘깁니다.
      searchKeyword: searchCon.text, // 검색어를 넘깁니다.
      trainerIntro: intro ?? '',     // 트레이너 소개를 넘깁니다.
    );

    setState(() {
      isLoading = false;
    });
  }

  void onGenderSelected(String gender) {
    setState(() {
      selectedGender = gender;
      fetchTrainers(); // 성별 선택 시 트레이너 목록을 다시 가져옵니다.
    });
  }

  void onAgeGroupSelected(String ageGroup) {
    setState(() {
      selectedAgeGroup = ageGroup;
      fetchTrainers(); // 나이 그룹 선택 시 트레이너 목록을 다시 가져옵니다.
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
                          margin: EdgeInsets.symmetric(horizontal: 5), // 수평 간격 조정
                          width: 60, // 각 버튼의 너비 조정
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

                // Fetch trainers button
                if (trainers != null && trainers.isNotEmpty)
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: trainers.length,
                    itemBuilder: (context, index) {
                      final trainer = trainers[index];
                      if (trainer != null) { // 요소가 null이 아닌 경우에만 렌더링
                        final imageBytes = _getImageBytes(trainer['trainer_picture']);
                        return ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // 내용 패딩 조정
                          leading: Container(
                            width: 80,
                            height: 80,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: imageBytes != null
                                  ? Image.memory(
                                imageBytes, // Uint8List 데이터 사용
                                fit: BoxFit.cover,
                              )
                                  : Image.asset(
                                'assets/train1.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          title: Text(
                            trainer['trainer_name'] ?? '', // 강사 이름
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
                                trainer['gym_name'] ?? '무소속', // 소속 헬스장
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                trainer['trainer_intro'] ?? '바디프로필, 다이어트, 대회준비 전문', // 강사 소개
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 13,
                                ),
                                maxLines: 2, // 최대 2줄까지 표시
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        );
                      } else {
                        return SizedBox(); // trainer가 null인 경우 빈 컨테이너 반환
                      }
                    },
                  )
                else
                  Text('해당 조건의 트레이너가 없습니다.'),

                SizedBox(height: 20), // Add some bottom spacing
              ],
            ),
          ),
        ),
      ),
    );
  }
}
