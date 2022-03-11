import 'dart:convert';
import 'package:client/screens/userInit/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:client/screens/login/login.dart';
import 'package:client/services/Auth.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:client/screens/home/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../graphQL/auth.dart';
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
                  ? ((    prefs!.getString('roll') == null ||
                          prefs!.getString('name') == null ||
                          prefs!.getString('role') == null ||
                          prefs!.getStringList('interests') == null ||
              (prefs!.getString('hostelName') == null &&  prefs!.getString('role') == "USER")||
              (prefs!.getString('hostelId') == null && prefs!.getString('role') == "USER" )||
                          prefs!.getString("id") == null)
                      ? getMeLoader(prefs: prefs!,)
                      : mainHome())
                  : userInit(auth: auth));
        }));
  }
}




class getMeLoader extends StatefulWidget {
  final SharedPreferences prefs;
  getMeLoader({required this.prefs});

  @override
  State<getMeLoader> createState() => _getMeLoaderState();
}

class _getMeLoaderState extends State<getMeLoader> {
  String getMe = homeQuery().getMe;
  String logOut = authQuery().logOut;
  late AuthService _auth;
  late String fcmToken;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _auth = Provider.of<AuthService>(context, listen: false);
    });
  }
  @override
  Widget build(BuildContext context) {
    _firebaseMessaging.getToken().then((token) {
      fcmToken = token!;
    });
    return Query(
        options: QueryOptions(
          document: gql(getMe),
        ),
        builder: (QueryResult result, {fetchMore, refetch}) {
          if (result.hasException) {
            return Mutation(
              options: MutationOptions(
                  document: gql(logOut),
                  onCompleted: (result) async{
                    print("logout result:$result");
                    if (result["logout"] == true) {
                      await widget.prefs.clear();
                      print("pref Cleared , prefs :${widget.prefs}");
                      _auth.clearAuth();
                    }
                  }),
              builder:
                  (RunMutation runMutation, QueryResult? result) {
                if (result!.hasException) {
                  print(result.exception.toString());
                }
                return ListTile(
                  leading: const Icon(Icons.logout),
                  horizontalTitleGap: 0,
                  title: const Text("Logout"),
                  onTap: () {
                    runMutation({
                      "fcmToken": fcmToken,
                    });
                  },
                );
              },
            );
          }
          if (result.isLoading) {
            print("is loading");
            return const SizedBox.shrink();
          }
          print("after loading");
          String _userRole = result.data!["getMe"]["role"];
          print("role : $_userRole");
          String _hostelName = (result.data!["getMe"]["hostel"] == null)?"":result.data!["getMe"]["hostel"]["name"];
          print("hostel : $_hostelName");
          String _hostelId = (result.data!["getMe"]["hostel"] == null)?"":result.data!["getMe"]["hostel"]["id"];
          print("hostelId : $_hostelId");
          String _id = result.data!["getMe"]["id"];
          print("id : $_id");
          String _name = result.data!["getMe"]["name"];
          print("name : $_name");
          String _roll = result.data!["getMe"]["roll"];
          print("roll :$_roll");
          String? _mobile = result.data!["getMe"]["mobile"];
          var interestJson = result.data!["getMe"]["interest"];
          List<String> interests = [];
          for (var i=0;i<interestJson.length;i++){
            interests.add(jsonEncode(interestJson[i]));
          }
          print("interests :$interests");
          widget.prefs.setString('roll', _roll);
          widget.prefs.setString('name', _name);
          widget.prefs.setString('role', _userRole);
          widget.prefs.setStringList('interests', interests);
          widget.prefs.setString("id", _id);
          widget.prefs.setString('hostelName', _hostelName);
          widget.prefs.setString('hostelId', _hostelId);
          if(_mobile != null) {
            widget.prefs.setString('mobile', _mobile);
          }
          print("done loading data");
          return const mainHome();
        });
  }
}

