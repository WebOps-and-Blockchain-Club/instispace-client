import 'dart:ui';
import 'package:client/graphQL/notification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:shared_preferences/shared_preferences.dart';


class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  void initState(){
    super.initState();
    _sharedPreference();
  }

  void _sharedPreference() async{
    print('sharedpreference called');
    prefs = await SharedPreferences.getInstance();
    setState(() {
      if(prefs?.getString("notifyNetop")!=null){
        dropdownValueNetops = prefs?.getString("notifyNetop");
      }
      print("dropDownValueNetops: $dropdownValueNetops");
      if(prefs?.getString("notifyEvent")!=null){
        dropdownValueEvents = prefs?.getString("notifyEvent");
      }
      print("dropDownValueEvents : $dropdownValueEvents");
      if(prefs?.getBool('isSwitchedLnF') == true){
        isSwitchedLnF = true;
        print("isSwitchedLnF:$isSwitchedLnF");
      }
      if(prefs?.getBool('isSwitchedQueries')== false){
        isSwitchedQueries = false;
        print("isSwitchedQueries:$isSwitchedQueries");
      }
    });
  }

  String changeNotificationPreference = notificationQuery().changeNotificationPreference;

  SharedPreferences? prefs;
  List<String> notificationPref=[];
  bool isSwitchedLnF = false;
  bool isSwitchedQueries = true;
  String? dropdownValueNetops = "Followed Tags";
  String? dropdownValueEvents = "Followed Tags";
  Map<String,String> notificationPrefs={
    "All":"FORALL",
    "Followed Tags":"FOLLOWED_TAGS",
    "None":"NONE",
  };
  @override
  Widget build(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // if (message.notification != null) {
        message.data.keys.map((key){
          print("key : $key");
          print("value : ${message.data[key]}");
        }).toList();
        // print('Message data: ${message.data}');
      // }
    });
    return Scaffold(
        appBar: AppBar(
          title: const Text("Notification setting"),
        ),
        body: Column(
          children: [
            //netop
            Mutation(
            options: MutationOptions(
              document: gql(changeNotificationPreference),
              onCompleted: (result){
                print("NetopPrefChange result:$result");
              }
            ),
              builder: (RunMutation runMutation,
                  QueryResult? result){
                if (result!.hasException){
                  print(result.exception.toString());
                }
                return ListTile(
                    leading: const Text('Netops'),
                    trailing: DropdownButton<String>(
                      value: dropdownValueNetops,
                      onChanged: (String? newValue){
                        setState(() {
                          dropdownValueNetops = newValue!;
                          prefs?.setString("notifyNetop", dropdownValueNetops!);
                          print("notifyNetop:${prefs?.getString("notifyNetop")}");
                        });
                        runMutation({
                          "notifyNetop":notificationPrefs[dropdownValueNetops],
                          "toggleNotifyMyQuery":isSwitchedQueries,
                          "toggleNotifyFound":isSwitchedLnF,
                        });
                      },
                      items: notificationPrefs.keys
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    )
                );
              },
        ),
            //events
            Mutation(
                options: MutationOptions(
                  document: gql(changeNotificationPreference),
                  onCompleted: (result){
                    print("EventPrefChange result:$result");
                  }
                ),
                builder: (RunMutation runMutation,
                    QueryResult? result,){
                  if (result!.hasException){
                    print(result.exception.toString());
                  }
                  return ListTile(
                      leading: const Text('Events'),
                      trailing: DropdownButton<String>(
                        value: dropdownValueEvents,
                        onChanged: (String? newValue){
                          setState(() {
                            dropdownValueEvents = newValue!;
                            prefs?.setString("notifyEvent", dropdownValueEvents!);
                            print("notifyEvent:${prefs?.getString("notifyEvent")}");
                          });
                          print("EventPref");
                          runMutation({
                            "notifyEvent":notificationPrefs[dropdownValueEvents],
                            "toggleNotifyMyQuery":isSwitchedQueries,
                            "toggleNotifyFound":isSwitchedLnF,
                          });
                        },
                        items: notificationPrefs.keys
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      )
                  );
                }
            ),
            //LnF
            Mutation(
                options: MutationOptions(
                  document: gql(changeNotificationPreference),
                  onCompleted: (result){
                    print("LnfPref:$result");
                  }
                ),
                builder: (RunMutation runMutation,
                    QueryResult? result){
                  if (result!.hasException){
                    print(result.exception.toString());
                  }
                  return ListTile(
                    leading: const Text('Found'),

                    trailing: Switch(
                      value: isSwitchedLnF,
                      onChanged: (value)  {
                        setState(() {
                          isSwitchedLnF = value;
                          print(isSwitchedLnF);
                        });
                        prefs?.setBool('isSwitchedLnF', isSwitchedLnF);
                        runMutation({
                          "toggleNotifyFound":isSwitchedLnF,
                          "toggleNotifyMyQuery":isSwitchedQueries
                        });
                      },
                      activeTrackColor: Colors.lightGreenAccent,
                      activeColor: Colors.green,
                    ),
                  );
                }
            ),
            //Query
            Mutation(
                options: MutationOptions(
                  document: gql(changeNotificationPreference),
                    onCompleted: (result){
                      print("QueriesPref:$result");
                    }
                ),
                builder: (RunMutation runMutation,
                    QueryResult? result){
                  if (result!.hasException){
                    print(result.exception.toString());
                  }
                  return ListTile(
                    leading:const Text('Queries'),
                    trailing: Switch(
                      value: isSwitchedQueries,
                      onChanged: (value){
                        setState(() {
                          isSwitchedQueries = value;
                          print("isSwitchedQueries:$isSwitchedQueries");
                        });
                        prefs?.setBool('isSwitchedQueries', isSwitchedQueries);
                        runMutation({
                          "toggleNotifyMyQuery":isSwitchedQueries,
                          "toggleNotifyFound":isSwitchedLnF,
                        });
                      },
                      activeTrackColor: Colors.lightGreenAccent,
                      activeColor: Colors.green,
                    ),
                  );
                }
            ),
          ],
        )
    );
  }
}




