import 'dart:convert';

import 'package:client/screens/userInit/main.dart';
import 'package:flutter/material.dart';
import 'package:client/screens/login/login.dart';
import 'package:client/services/Auth.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:client/screens/home/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../graphQL/home.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _sharedPreference();
  }

  void _sharedPreference() async {
    prefs = await SharedPreferences.getInstance();
  }

  SharedPreferences? prefs;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => AuthService(),
        child: Consumer<AuthService>(builder: (context, auth, child) {
          return auth.token == null
              ? LogIn()
              : (auth.isNewUser == false
                  ? ((prefs!.getString("roll") == null ||
                          prefs!.getString("name") == null ||
                          prefs!.getString("role") == null ||
                          prefs!.getString("mobile") == null ||
                          prefs!.getString("interests") == null ||
                          prefs!.getString("hostel") == null ||
                          prefs!.getString("id") == null)
                      ? getMeLoader(prefs: prefs!,)
                      : mainHome())
                  : userInit(auth: auth));
        }));
  }
}

String getMe = homeQuery().getMe;


class getMeLoader extends StatelessWidget {
  final SharedPreferences prefs;
  getMeLoader({required this.prefs});
  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
          document: gql(getMe),
        ),
        builder: (QueryResult result, {fetchMore, refetch}) {
          if (result.hasException) {
            return Text(result.exception.toString());
          }
          if (result.isLoading) {
            print("is loading");
            return const SizedBox.shrink();
          }
          print("after loading");
          String _userRole = result.data!["getMe"]["role"];
          String _hostelName = result.data!["getMe"]["hostel"]["name"];
          String _hostelId = result.data!["getMe"]["hostel"]["id"];
          String _id = result.data!["getMe"]["id"];
          String _name = result.data!["getMe"]["name"];
          String _roll = result.data!["getMe"]["roll"];
          String? _mobile = result.data!["getMe"]["mobile"];
          var interestJson = result.data!["getMe"]["interest"];
          List<String> interests = [];
          for (var i=0;i<interestJson.length;i++){
            interests.add(jsonEncode(interestJson[i]));
          }
          prefs.setString('roll', _roll);
          prefs.setString('name', _name);
          if(prefs.getString("role") != null) prefs.setString('role', _userRole);
          prefs.setStringList('interests', interests);
          prefs.setString("id", _id);
          prefs.setString('hostelName', _hostelName);
          prefs.setString('hostelId', _hostelId);
          if(_mobile != null) {
            prefs.setString('mobile', _mobile);
          }
          return const mainHome();
        });
  }
}

