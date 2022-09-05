import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends ChangeNotifier {
  SharedPreferences? prefs;
  String? _token;
  String? get token => _token;

  AuthService() {
    notifyListeners();
    _token = null;
    loadToken();
  }

  _initAuth() async {
    prefs ??= await SharedPreferences.getInstance();
  }

  loadToken() async {
    await _initAuth();
    _token = prefs!.getString('token') ?? "";
    notifyListeners();
  }

  login(String token, String role, bool isNewUser) async {
    await _setToken(token);
    notifyListeners();
  }

  updateUser(Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 1));
    notifyListeners();
  }

  logout() async {
    HiveStore().reset();
    await _clearToken();
    notifyListeners();
  }

  _setToken(String token) async {
    await _initAuth();
    prefs?.setString('token', token);
    _token = token;
  }

  _clearToken() async {
    await _initAuth();
    prefs!.clear();
    _token = "";
  }
}
