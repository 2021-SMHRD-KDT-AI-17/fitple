import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final searchCon = TextEditingController(); // 검색창 컨트롤러
  final minCon = TextEditingController(); // 금액최소 컨트롤러
  final maxCon = TextEditingController(); // 금액최대 컨트롤러
  String? selectedGender;
  List<String> selectedAges = [];
  List<String> selectedPurposes = [];

  void toggleSelection(String item, List<String> list) {
    setState(() {
      if (list.contains(item)) {
        list.remove(item);
      } else {
        list.add(item);
      }
    });
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
                      print('검색창 기능입니다.');
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
                        onPressed: () {},
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
                          setState(() {
                            selectedGender = '남자';
                          });
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
                          setState(() {
                            selectedGender = '여자';
                          });
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
                    children: [
                      GestureDetector(
                        onTap: () {
                          toggleSelection('20대', selectedAges);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 80,
                          height: 35,
                          decoration: BoxDecoration(
                            color: selectedAges.contains('20대')
                                ? Colors.blueAccent
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '20대',
                            style: TextStyle(
                              color: selectedAges.contains('20대')
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
                          toggleSelection('30대', selectedAges);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 80,
                          height: 35,
                          decoration: BoxDecoration(
                            color: selectedAges.contains('30대')
                                ? Colors.blueAccent
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '30대',
                            style: TextStyle(
                              color: selectedAges.contains('30대')
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
                          toggleSelection('40대', selectedAges);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 80,
                          height: 35,
                          decoration: BoxDecoration(
                            color: selectedAges.contains('40대')
                                ? Colors.blueAccent
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '40대',
                            style: TextStyle(
                              color: selectedAges.contains('40대')
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
                          toggleSelection('50대', selectedAges);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 80,
                          height: 35,
                          decoration: BoxDecoration(
                            color: selectedAges.contains('50대')
                                ? Colors.blueAccent
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '50대',
                            style: TextStyle(
                              color: selectedAges.contains('50대')
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
                    '가격',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: minCon,
                          onChanged: (text) {
                            setState(() {});
                          },
                          maxLines: 1,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (String) {
                            print('최소 금액 입니다.');
                          },
                          decoration: InputDecoration(
                            hintText: '최소 금액',
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
                          ),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: Text('~'),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: maxCon,
                          onChanged: (text) {
                            setState(() {});
                          },
                          maxLines: 1,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (String) {
                            print('최대 금액 입니다.');
                          },
                          decoration: InputDecoration(
                            hintText: '최대 금액',
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
                          ),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      GestureDetector(
                        onTap: () {
                          print('가격 범위 적용');
                        },
                        child: Container(
                          width: 40,
                          height: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '적용',
                            style: TextStyle(
                              color: Colors.white,
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
                  margin: EdgeInsets.only(left: 16, top: 16, right: 16),
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '운동목적',
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
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              toggleSelection('다이어트', selectedPurposes);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: 175,
                              height: 35,
                              decoration: BoxDecoration(
                                color: selectedPurposes.contains('다이어트')
                                    ? Colors.blueAccent
                                    : Colors.grey,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '다이어트',
                                style: TextStyle(
                                  color: selectedPurposes.contains('다이어트')
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
                              toggleSelection('바디 프로필', selectedPurposes);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: 175,
                              height: 35,
                              decoration: BoxDecoration(
                                color: selectedPurposes.contains('바디 프로필')
                                    ? Colors.blueAccent
                                    : Colors.grey,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '바디 프로필',
                                style: TextStyle(
                                  color: selectedPurposes.contains('바디 프로필')
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
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              toggleSelection('대회 참가', selectedPurposes);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: 175,
                              height: 35,
                              decoration: BoxDecoration(
                                color: selectedPurposes.contains('대회 참가')
                                    ? Colors.blueAccent
                                    : Colors.grey,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '대회 참가',
                                style: TextStyle(
                                  color: selectedPurposes.contains('대회 참가')
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
                              toggleSelection('체력 증진', selectedPurposes);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: 175,
                              height: 35,
                              decoration: BoxDecoration(
                                color: selectedPurposes.contains('체력 증진')
                                    ? Colors.blueAccent
                                    : Colors.grey,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '체력 증진',
                                style: TextStyle(
                                  color: selectedPurposes.contains('체력 증진')
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
                    ],
                  ),
                ),
                SizedBox(height: 20), // Add some bottom spacing
              ],
            ),
          ),
        ),
      ),
    );
  }
}
