
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends ChangeNotifier{
  SharedPreferences? prefs;
   String? _role;
  String? _token;
  bool? _isNewUser;
   String? get token => _token;
  String? get role => _role;
  bool? get isNewUser => _isNewUser;

  AuthService(){
    notifyListeners();
    _token=null;
    _role=null;
    _isNewUser=false;
    loadToken();
    _loadRole();
    _loadisNewUser();
    // print('token auth : $token');
  }
  _initAuth() async{
    if(prefs== null)prefs=await SharedPreferences.getInstance();
  }
  loadToken() async{
    await _initAuth();
    _token = prefs!.getString('token')??null;
    // print('load token called, token:$_token');
    notifyListeners();
  }
  setToken(String token) async{
    await _initAuth();
    prefs?.setString('token', token);
    _token=token;
    // print('set token called');
    notifyListeners();
  }
  clearAuth() async {
    await _initAuth();
    prefs!.remove('token');
    prefs!.remove('role');
    _token = null;
    _role=null;
    // print('clear auth called');
    notifyListeners();
  }
  _loadRole() async{
    await _initAuth();
    _role = (prefs!.getString('role')??null);
    notifyListeners();
  }
  setRole(String role) async{
    await _initAuth();
    prefs!.setString('role', role);
    _role=role;
    notifyListeners();
  }
  setisNewUser(bool isNewUser) async{
    await _initAuth();
    prefs!.setBool('isNewUser', isNewUser);
    _isNewUser=isNewUser;
    notifyListeners();
  }
  _loadisNewUser() async{
    await _initAuth();
    _isNewUser = (prefs!.getBool('isNewUser')??false);
    notifyListeners();
  }

}