import 'package:client/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends ChangeNotifier {
  SharedPreferences? prefs;
  String? _token;
  UserModel? _user;
  String? get token => _token;
  UserModel? get user => _user;

  AuthService() {
    notifyListeners();
    _token = null;
    _user = null;
    loadToken();
  }

  _initAuth() async {
    prefs ??= await SharedPreferences.getInstance();
  }

  loadToken() async {
    await _initAuth();
    _token = prefs!.getString('token');
    notifyListeners();
  }

  login(String token, String role, bool isNewUser) async {
    await _setToken(token);
    _setUser({"role": role, "isNewUser": isNewUser});
    notifyListeners();
  }

  updateUser(Map<String, dynamic> data) async {
    _setUser(data);
    await Future.delayed(const Duration(milliseconds: 1));
    notifyListeners();
  }

  logout() async {
    await _clearToken();
    _clearUser();
    notifyListeners();
  }

  clearUser() {
    _clearUser();
    notifyListeners();
  }

  _setToken(String token) async {
    await _initAuth();
    prefs?.setString('token', token);
    _token = token;
  }

  _clearToken() async {
    await _initAuth();
    prefs!.remove('token');
    _token = null;
  }

  _setUser(Map<String, dynamic> data) {
    _user = UserModel.fromJson(data);
  }

  _clearUser() {
    _user = null;
  }
}
