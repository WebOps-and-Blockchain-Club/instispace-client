import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  SharedPreferences? prefs;

  LocalStorageService() {
    _initLocalStorage();
  }

  _initLocalStorage() async {
    prefs ??= await SharedPreferences.getInstance();
  }

  setData(String id, Map<String, dynamic> data) async {
    if (prefs == null) await _initLocalStorage();
    return prefs?.setString(id, jsonEncode(data));
  }

  getData(String id) async {
    if (prefs == null) await _initLocalStorage();
    var data = prefs?.getString(id);
    if (data != null) {
      return jsonDecode(data);
    }
    return null;
  }

  clearData(String id) async {
    if (prefs == null) await _initLocalStorage();
    return prefs?.remove(id);
  }
}
