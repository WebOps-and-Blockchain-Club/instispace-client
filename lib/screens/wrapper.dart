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
  const Wrapper({Key? key}) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => AuthService(),
        child: Consumer<AuthService>(builder: (context, auth, child) {
          return auth.token == null
              ? LogIn()
              : (auth.isNewUser == false
                  ? GetMeLoader(
                      auth: auth,
                    )
                  : userInit(auth: auth));
        }));
  }
}

class GetMeLoader extends StatefulWidget {
  final AuthService auth;
  const GetMeLoader({Key? key, required this.auth}) : super(key: key);

  @override
  State<GetMeLoader> createState() => _GetMeLoaderState();
}

class _GetMeLoaderState extends State<GetMeLoader> {
  String getMe = homeQuery().getMe;
  String logOut = authQuery().logOut;
  late String fcmToken;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<bool> setUserid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if ((prefs.getString('roll') == null ||
        prefs.getString('name') == null ||
        prefs.getString('role') == null ||
        prefs.getStringList('interests') == null ||
        (prefs.getString('hostelName') == null &&
            prefs.getString('role') == "USER") ||
        (prefs.getString('hostelId') == null &&
            prefs.getString('role') == "USER") ||
        prefs.getString("id") == null)) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    _firebaseMessaging.getToken().then((token) {
      fcmToken = token!;
    });
    return FutureBuilder(
        future: setUserid(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == true) {
              return const mainHome();
            } else {
              return Query(
                  options: QueryOptions(
                    document: gql(getMe),
                  ),
                  builder: (QueryResult result, {fetchMore, refetch}) {
                    if (result.hasException) {
                      return Mutation(
                        options: MutationOptions(
                            document: gql(logOut),
                            onCompleted: (result) async {
                              if (result?["logout"] == true) {
                                widget.auth.clearMe();
                              }
                            }),
                        builder:
                            (RunMutation runMutation, QueryResult? result) {
                          if (result!.hasException) {
                            widget.auth.clearMe();
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
                      return const SizedBox.shrink();
                    }
                    String _userRole = result.data!["getMe"]["role"];
                    String _hostelName =
                        (result.data!["getMe"]["hostel"] == null)
                            ? ""
                            : result.data!["getMe"]["hostel"]["name"];
                    String _hostelId = (result.data!["getMe"]["hostel"] == null)
                        ? ""
                        : result.data!["getMe"]["hostel"]["id"];
                    String _id = result.data!["getMe"]["id"];
                    String _name = result.data!["getMe"]["name"];
                    String _roll = result.data!["getMe"]["roll"];
                    String? _mobile = result.data!["getMe"]["mobile"];
                    var interestJson = result.data!["getMe"]["interest"];
                    List<String> interests = [];
                    for (var i = 0; i < interestJson.length; i++) {
                      interests.add(jsonEncode(interestJson[i]));
                    }
                    widget.auth.setMe(_roll, _name, _userRole, interests, _id,
                        _hostelName, _hostelId, _mobile);
                    return const Scaffold(body: CircularProgressIndicator());
                  });
            }
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}
