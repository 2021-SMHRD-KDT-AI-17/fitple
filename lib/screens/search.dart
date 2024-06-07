import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final searchCon = TextEditingController(); // 검색창 컨트롤러

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('검색'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16,top: 10, right: 16),
                child: Expanded(
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
                      suffixIcon: IconButton(onPressed: (){}, icon: Icon(Icons.search, color: Colors.blueAccent,),
                    ),
                  ),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                ),
                // SizedBox(width: 8), // Add some space between the TextFormField and the Icon
                // Container(
                //   padding: EdgeInsets.all(8.0), // Add padding around the Icon
                //   decoration: BoxDecoration(
                //     color: Colors.blueAccent,
                //     borderRadius: BorderRadius.circular(4),
                //   ),
                //   child: Icon(
                //     Icons.search,
                //     color: Colors.white,
                //   ),
                // ),
              ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
