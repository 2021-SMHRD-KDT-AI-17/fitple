import 'dart:ffi';

class fit_mem{
  String? user_email;
  String? user_password;
  String? user_nick;
  String? user_name;
  String? gender;
  String? age;
  String? user_picture;

  //getter
  String? get getEmail => user_email;
  String? get getPw => user_password;
  String? get getNick => user_nick;
  String? get getName => user_name;
  String? get getGender => gender;
  String? get getAge => age;
  String? get getPicture => user_picture;

  //setter
  set setEmail(String? value){
    user_email = value;
  }
  set setPw(String? value){
    user_password = value;
  }
  set setNick(String? value){
    user_nick = value;
  }
  set setName(String? value){
    user_name = value;
  }
  set setGender(String? value){
    gender = value;
  }
  set setAge(String? value){
    age = value;
  }
  set setPicture(String? value){
    user_picture = value;
  }

}