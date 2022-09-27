import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends ChangeNotifier {
  SharedPreferences? prefs;
  String? _token;
  bool? _newUserOnApp;
  String? get token => _token;
  bool? get newUserOnApp => _newUserOnApp;

  AuthService() {
    notifyListeners();
    _token = null;
    _newUserOnApp = null;
    loadToken();
    getNewUserOnApp();
  }

  _initAuth() async {
    prefs ??= await SharedPreferences.getInstance();
  }

  getNewUserOnApp() async {
    await _initAuth();
    _newUserOnApp = prefs!.getBool("appOpenedBefore") ?? true;
  }

  setNewUserOnApp(bool val) async {
    await _initAuth();
    prefs!.setBool("appOpenedBefore", val);
    _newUserOnApp = val;
    notifyListeners();
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
    setNewUserOnApp(false);
    _token = "";
  }
}
