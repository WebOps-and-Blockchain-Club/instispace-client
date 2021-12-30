import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends ChangeNotifier{
  SharedPreferences? _prefs;
   String? _role;
  String? _token;
   String? get token => _token ;
  String? get role => _role ;

  AuthService(){
    notifyListeners();
    _token=null;
    _role=null;
    _loadToken();
    _loadRole();
    print('auth.token:$token');
    // notifyListeners();
  }
  _initAuth() async{
    if(_prefs== null)_prefs=await SharedPreferences.getInstance();
  }
  _loadToken() async{
    await _initAuth();
    _token = _prefs!.getString('token')??null;
    print('load token called, token:$_token');
    notifyListeners();
  }
  setToken(String token) async{
    await _initAuth();
    _prefs?.setString('token', token);
    _token=token;
    print('set token called');
    _loadToken();
    notifyListeners();
  }
  clearAuth() async {
    await _initAuth();
    _prefs!.remove('token');
    _prefs!.remove('role');
    _token = null;
    _role=null;
    print('clear auth called');
    notifyListeners();
  }
  _loadRole() async{
    await _initAuth();
    _role = (_prefs!.getString('role')??null);
    notifyListeners();
  }
  _setRole(String role) async{
    await _initAuth();
    _prefs!.setString('role', role);
    _role=role;
    notifyListeners();
  }

}