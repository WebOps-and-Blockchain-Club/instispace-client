import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoreMe extends ChangeNotifier{
  SharedPreferences? prefs;
  String? _roll;
  String? _name;
  String? _role;
  String? _mobile;
  List<String>? _interest;
  String? get roll => _roll;
  String? get name => _name;
  String? get role => _role;
  String? get mobile => _mobile;
  List<String>? get interest=>_interest;


  _initAuth() async{
    if(prefs== null)prefs=await SharedPreferences.getInstance();
  }

  loadUser() async{
    await _initAuth();
    _roll = prefs!.getString('roll')??null;
    _name = prefs!.getString('name')??null;
    _role = prefs!.getString('role')??null;
    _mobile = prefs!.getString('mobile')??null;
    _interest = prefs!.getStringList('interests')??null;
    // print('load token called, token:$_token');
    notifyListeners();
  }

  setUser(String roll, String name, String role, String mobile,List<String> interests) async{
    await _initAuth();
    prefs?.setString('roll', roll);
    prefs?.setString('name', name);
    prefs?.setString('role', role);
    prefs?.setString('mobile', mobile);
    prefs?.setStringList('interests', interests);
    // print('set token called');
    notifyListeners();
  }

  clearUser() async {
    await _initAuth();
    prefs!.remove('roll');
    prefs!.remove('name');
    prefs!.remove('role');
    prefs!.remove('mobile');
    prefs!.remove('interests');
    _interest=null;
    _role=null;
    _mobile=null;
    _name=null;
    _roll=null;
    // print('clear auth called');
    notifyListeners();
  }
}