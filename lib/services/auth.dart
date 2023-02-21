import 'package:client/models/user.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends ChangeNotifier {
  SharedPreferences? prefs;
  String? _token;
  bool? _newUserOnApp;
  UserModel? _user;

  String? get token => _token;
  bool? get newUserOnApp => _newUserOnApp;
  // UserModel? get user => _user;

  AuthService() {
    notifyListeners();
    _token = null;
    _newUserOnApp = null;
    _user = null;
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
    if (_token == "") FirebaseMessaging.instance.deleteToken();
    notifyListeners();
  }

  login(String token) async {
    await _setToken(token);
    notifyListeners();
  }

  // updateUser(UserModel user) async {
  //   print("\n\n\n\nupdate user called");
  //   _user = user;
  //   notifyListeners();
  // }

  logout() async {
    HiveStore().reset();
    FirebaseMessaging.instance.deleteToken();
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
