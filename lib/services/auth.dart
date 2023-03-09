import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends ChangeNotifier {
  SharedPreferences? prefs;
  String? _token;
  bool? _newUserOnApp;

  String? get token => _token;
  bool? get newUserOnApp => _newUserOnApp;

  // Create storage
  final storage = const FlutterSecureStorage();

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
    _token = await storage.read(key: 'token') ?? "";
    if (_token == "") FirebaseMessaging.instance.deleteToken();
    notifyListeners();
  }

  login(String token) async {
    await _setToken(token);
    notifyListeners();
  }

  logout() async {
    HiveStore().reset();
    FirebaseMessaging.instance.deleteToken();
    await _clearToken();
    notifyListeners();
  }

  _setToken(String token) async {
    await _initAuth();
    await storage.write(key: 'token', value: token);
    _token = token;
  }

  _clearToken() async {
    await _initAuth();
    await storage.deleteAll();
    setNewUserOnApp(false);
    _token = "";
  }
}
