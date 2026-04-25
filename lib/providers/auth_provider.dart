import 'package:flutter/foundation.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  String _userName = '';
  String _userEmail = '';

  bool get isLoggedIn => _isLoggedIn;
  String get userName => _userName;
  String get userEmail => _userEmail;
  String get userInitials => _userName.isNotEmpty
      ? _userName.trim().split(' ').map((e) => e[0]).take(2).join().toUpperCase()
      : 'AU';

  Future<bool> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    if (email.isNotEmpty && password.length >= 6) {
      _isLoggedIn = true;
      _userEmail = email;
      _userName = 'Mr. Aakhan';
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> signUp(String name, String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    if (name.isNotEmpty && email.isNotEmpty && password.length >= 6) {
      _isLoggedIn = true;
      _userName = name;
      _userEmail = email;
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    _isLoggedIn = false;
    _userName = '';
    _userEmail = '';
    notifyListeners();
  }
}
