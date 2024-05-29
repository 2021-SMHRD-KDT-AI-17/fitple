class Member{
  String? email;
  String? password;
  String? nick;
  String? name;
  String? gender;
  int? age;

  Member({
   required this.email,
   required this.password,
   required this.nick,
   required this.age,
   required this.name,
   required this.gender,
});

  Member.join({
    required this.email,
    required this.password,
    required this.nick,
    required this.name,
    required this.gender,
    required this.age
});

  factory Member.fromJson(Map<String, dynamic> json)=> Member(
      email: json['email'],
      password: json['password'],
      nick: json['nick'],
      name: json['name'],
      gender: json['gender'],
      age: json['age']
  );
  Map<String, dynamic> toJson()=>{
    'email':email,
    'password':password,
    'nick':nick,
    'name':name,
    'gender':gender,
    'age':age
  };

  Member.login({
    required this.email,
    required this.password,
});

  Member.update({
    required this.email,
    required this.password,
    required this.nick,
    required this.name,
    required this.gender
});
}