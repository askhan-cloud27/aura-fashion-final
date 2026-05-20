import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;
  String _userName = '';
  String _userPhone = '';
  String _userAddress = '';
  String _userCity = '';
  String _userState = '';
  String _userZipCode = '';
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _darkMode = false;
  bool _isLoading = false;

  AuthProvider() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      if (user != null) {
        _fetchUserData(user.uid);
      } else {
        _userName = '';
        _userPhone = '';
        _userAddress = '';
        _userCity = '';
        _userState = '';
        _userZipCode = '';
        _emailNotifications = true;
        _pushNotifications = true;
        _darkMode = false;
        notifyListeners();
      }
    });
  }

  bool get isLoggedIn => _user != null;
  String get userName => _userName;
  String get userPhone => _userPhone;
  String get userEmail => _user?.email ?? '';
  String get userAddress => _userAddress;
  String get userCity => _userCity;
  String get userState => _userState;
  String get userZipCode => _userZipCode;
  bool get emailNotifications => _emailNotifications;
  bool get pushNotifications => _pushNotifications;
  bool get darkMode => _darkMode;
  bool get isLoading => _isLoading;

  String get userInitials => _userName.isNotEmpty
      ? _userName.trim().split(' ').map((e) => e[0]).take(2).join().toUpperCase()
      : 'AU';

  Future<void> _fetchUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        _userName = data['name'] ?? 'User';
        _userPhone = data['phone'] ?? '';
        _userAddress = data['address'] ?? '';
        _userCity = data['city'] ?? '';
        _userState = data['state'] ?? '';
        _userZipCode = data['zipCode'] ?? '';
        _emailNotifications = data['emailNotifications'] ?? true;
        _pushNotifications = data['pushNotifications'] ?? true;
        _darkMode = data['darkMode'] ?? false;
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching user data: $e');
    }
  }

  Future<bool> updateSettings({bool? emailNotifications, bool? pushNotifications, bool? darkMode}) async {
    if (_user == null) return false;
    
    // Optimistic UI update
    final oldEmail = _emailNotifications;
    final oldPush = _pushNotifications;
    final oldDark = _darkMode;
    
    if (emailNotifications != null) _emailNotifications = emailNotifications;
    if (pushNotifications != null) _pushNotifications = pushNotifications;
    if (darkMode != null) _darkMode = darkMode;
    notifyListeners();
    
    try {
      Map<String, dynamic> data = {};
      if (emailNotifications != null) data['emailNotifications'] = emailNotifications;
      if (pushNotifications != null) data['pushNotifications'] = pushNotifications;
      if (darkMode != null) data['darkMode'] = darkMode;

      await _firestore.collection('users').doc(_user!.uid).update(data);
      return true;
    } catch (e) {
      // Revert on failure
      _emailNotifications = oldEmail;
      _pushNotifications = oldPush;
      _darkMode = oldDark;
      notifyListeners();
      debugPrint('Update settings error: $e');
      return false;
    }
  }

  Future<bool> updateProfile({
    String? name, 
    String? phone,
    String? address,
    String? city,
    String? state,
    String? zipCode,
  }) async {
    if (_user == null) return false;
    _isLoading = true;
    notifyListeners();
    try {
      Map<String, dynamic> data = {};
      if (name != null) data['name'] = name;
      if (phone != null) data['phone'] = phone;
      if (address != null) data['address'] = address;
      if (city != null) data['city'] = city;
      if (state != null) data['state'] = state;
      if (zipCode != null) data['zipCode'] = zipCode;

      await _firestore.collection('users').doc(_user!.uid).update(data);
      
      if (name != null) _userName = name;
      if (phone != null) _userPhone = phone;
      if (address != null) _userAddress = address;
      if (city != null) _userCity = city;
      if (state != null) _userState = state;
      if (zipCode != null) _userZipCode = zipCode;
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('Update profile error: $e');
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      _isLoading = false;
      return true;
    } catch (e) {
      _isLoading = false;
      debugPrint('Login error: $e');
      return false;
    }
  }

  Future<bool> signUp(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password
      );
      
      // Save user profile to Firestore
      await _firestore.collection('users').doc(credential.user!.uid).set({
        'uid': credential.user!.uid,
        'name': name,
        'email': email,
        'emailNotifications': true,
        'pushNotifications': true,
        'darkMode': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      _userName = name;
      _isLoading = false;
      return true;
    } catch (e) {
      _isLoading = false;
      debugPrint('Signup error: $e');
      return false;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
