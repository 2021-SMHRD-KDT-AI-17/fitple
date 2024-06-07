import 'package:flutter/material.dart';
import 'package:fitple/DB/GymDB.dart';

class RecommendGym extends StatefulWidget {
  const RecommendGym({super.key});

  @override
  State<RecommendGym> createState() => _RecommendGymState();
}

class _RecommendGymState extends State<RecommendGym> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('님을 위한 추천 헬스장',
        style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold
        ),),
      centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [Container(
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.all(20),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 5,
                  childAspectRatio: 0.8,
                ),
                itemCount: displayGymCount,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  var gym = _gyms[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Info()),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 150,
                          margin: EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: gym['gym_picture'] != null
                                ? Image.memory(
                              gym['gym_picture'],
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            )
                                : Image.asset(
                              'assets/gym3.jpg',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                        ),
                        Text(
                          gym['gym_name'] ?? '',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          gym['gym_address'] ?? '',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),],
          ),
        ),
      ),
    );
  }
}
