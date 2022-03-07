import 'dart:convert';

import 'package:client/graphQL/home.dart';
import 'package:client/widgets/headings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/tag.dart';
import '../../widgets/loadingScreens.dart';
import '../../widgets/tagButtons.dart';
import '../../widgets/text.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {

  ///GraphQL
  String getMe = homeQuery().getMe;

  ///Variables
  String name = "";
  String hostel = "";
  String roll = "";
  List<Tag> interests = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _sharedPreference();
  }
  SharedPreferences? prefs;
  void _sharedPreference()async{
    prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs!.getString('name')!;
      hostel = prefs!.getString('hostelName')!;
      roll = prefs!.getString("roll")!;
      print("interest pref :${prefs!.getStringList("interests")!}");
      var _interests = prefs!.getStringList("interests")!;
      for(var i=0;i<_interests.length;i++){
        print("interest : ${_interests[i]}");
        var interest = jsonDecode(_interests[i]);
        interests.add(
            Tag(
                category: interest["category"], Tag_name: interest["title"], id: interest["id"]
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: const Color(0xFF2B2E35),
      ),

      ///Background colour
      backgroundColor: const Color(0xFFDFDFDF),

      body: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    ///User Image
                    const Padding(
                      padding: EdgeInsets.fromLTRB(10, 25, 10, 10),
                      child: CircleAvatar(
                          radius: 65,
                          backgroundImage: NetworkImage('https://cdn.pixabay.com/photo/2020/07/01/12/58/icon-5359553_1280.png')
                      ),
                    ),
                    ///User Name
                    Heading(name),
                    ///User roll no.
                    Text(
                      roll,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF222222),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              ///User Hostel Name
              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                  child: Text(
                    "$hostel Hostel",
                    style: const TextStyle(
                      fontSize: 18,
                      color: Color(0xFF222222),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),


              ///Tags followed by User
              if (interests.isNotEmpty || interests != [])
                Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 25, 15, 15),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1.5,
                          color: const Color(0xFF222222),
                        ),
                        borderRadius: const BorderRadius.all(
                            Radius.circular(8.5)
                        ),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 12, 15, 0),
                            child: Row(
                              children: const [
                                Text(
                                  "My Interests",
                                  style: TextStyle(
                                    fontSize: 16.5,
                                    color: Color(0xFF222222),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
                            child: Wrap(
                              direction: Axis.horizontal,
                              children: interests.map((tag) =>
                                  SizedBox(
                                    child: Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                                        child: TagButtons(tag, context)
                                    ),
                                  )).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ///When user don't follow any tags
              if(interests.isEmpty || interests == [])
                const Center(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(15,25,15,15),
                    child: Text('No tags are followed'),
                  ),
                )
            ],
          ),
        ],
      ),
    );
  }
}
