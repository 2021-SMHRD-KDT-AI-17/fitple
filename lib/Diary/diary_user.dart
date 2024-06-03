class diaryuser {
  static final diaryuser _instance = diaryuser._internal();
  String? _userEmail;

  factory diaryuser() {
    return _instance;
  }

  diaryuser._internal();

  String? get userEmail => _userEmail;

  void setUserEmail(String email) {
    _userEmail = email;
  }
}
// ^^