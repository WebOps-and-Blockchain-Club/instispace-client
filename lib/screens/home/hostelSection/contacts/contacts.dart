import 'package:client/graphQL/auth.dart';
import 'package:client/graphQL/home.dart';
import 'package:client/graphQL/hostel.dart';
import 'package:client/screens/userInit/dropDown.dart';
import 'package:client/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../../models/hostelProfile.dart';
import '../contactAndAmenitiesCard.dart';
import 'package:client/widgets/loadingScreens.dart';

import 'createHostelContacts.dart';

class Hostelcontacts extends StatefulWidget {
  const Hostelcontacts({Key? key}) : super(key: key);

  @override
  _HostelcontactsState createState() => _HostelcontactsState();
}

class _HostelcontactsState extends State<Hostelcontacts> {

  ///GraphQL
  String getMe = homeQuery().getMe;
  String getHostels = authQuery().getHostels;
  String getContact = hostelQM().getContact;

  ///Variables
  String hostelName = '';
  String contactHostelName = '';
  List<Contacts> contacts = [];
  List<emergencycontacts> emergencyContacts = [];
  String hostelIdFilter = "";
  String _dropDownValue = "All";
  String search = "";
  int take = 0;
  late int total;
  late String userRole;
  Map<String, String> hostels = {};

  ///Controllers
  ScrollController scrollController = ScrollController(initialScrollOffset: 0.0);


  @override
  Widget build(BuildContext context) {

    emergencyContacts.clear();
    emergencyContacts.add(emergencycontacts(
        contact: '04422578185',
        name: 'Electrical Emergency'
    ));
    emergencyContacts.add(emergencycontacts(
        contact: '04422579999',
        name: 'Security Duty'
    ));
    emergencyContacts.add(emergencycontacts(
        contact: '04422578888',
        name: 'Hospital enquiries'
    ));
    emergencyContacts.add(emergencycontacts(
        contact: '04422579999',
        name: 'Animals related'
    ));
    emergencyContacts.add(emergencycontacts(
        contact: '04422578510',
        name: 'CCW Accounts related'
    ));
    emergencyContacts.add(emergencycontacts(
        contact: '04422578513',
        name: 'Accomodation related'
    ));
    emergencyContacts.add(emergencycontacts(
        contact: '04422578511',
        name: 'Mess related'
    ));
    emergencyContacts.add(emergencycontacts(
        contact: '04422579476',
        name: 'Prime mart'
    ));

    return Query(
        options: QueryOptions(
        document: gql(getMe),
    ),
    builder: (QueryResult result, {fetchMore, refetch}) {
      if (result.hasException) {
        return Text(result.exception.toString());
      }
      if (result.isLoading) {
        return Scaffold(
          body: Center(
            child: Column(
              children: [
                PageTitle('Contacts', context),
                Expanded(
                    child: ListView.separated(
                        itemBuilder: (context,
                            index) => const NewCardSkeleton(),
                        separatorBuilder: (context, index) =>
                        const SizedBox(height: 6,),
                        itemCount: 5)
                )
              ],
            ),
          ),
        );
      }

      userRole = result.data!["getMe"]["role"];

      if (userRole == "ADMIN" || userRole == "HAS") {
        return Query(
            options: QueryOptions(
              document: gql(getHostels),
            ),
            builder: (QueryResult result, {fetchMore, refetch}) {
              if (result.hasException) {
                return Text(result.exception.toString());
              }

              if (result.isLoading) {
                return Scaffold(
                  body: Center(
                    child: Column(
                      children: [
                        PageTitle('Contacts', context),
                        Expanded(
                            child: ListView.separated(
                                itemBuilder: (context,
                                    index) => const NewCardSkeleton(),
                                separatorBuilder: (context, index) =>
                                const SizedBox(height: 6,),
                                itemCount: 5)
                        )
                      ],
                    ),
                  ),
                );
              }


              hostels.clear();
              hostels.putIfAbsent("All", () => "");
              for (var i = 0; i < result.data!["getHostels"].length; i++) {
                hostels.putIfAbsent(
                    result.data!["getHostels"][i]["name"],
                        () =>
                    result.data!["getHostels"][i]["id"]
                );
              }

              return Query(
                options: QueryOptions(
                    document: gql(getContact),
                    variables: {"hostelId": hostelIdFilter}
                ),
                builder: (QueryResult result, {fetchMore, refetch}) {
                  if (result.hasException) {
                    return Text(result.hasException.toString());
                  }
                  if (result.isLoading) {
                    return Scaffold(
                      body: Center(
                        child: Column(
                          children: [
                            PageTitle('Contacts', context),
                            Expanded(
                                child: ListView.separated(
                                    itemBuilder: (context,
                                        index) => const NewCardSkeleton(),
                                    separatorBuilder: (context,
                                        index) => const SizedBox(height: 6,),
                                    itemCount: 5)
                            )
                          ],
                        ),
                      ),
                    );
                  }

                  contacts.clear();
                  for (var i = 0; i < result.data!["getContact"].length; i++) {
                    contacts.add(Contacts(
                      name: result.data!["getContact"][i]["name"],
                      type: result.data!["getContact"][i]["type"],
                      contact: result.data!["getContact"][i]["contact"],
                      id: result.data!["getContact"][i]["id"],
                      hostel: result.data!["getContact"][i]["hostel"]["name"]
                    ),
                    );
                  }
                  return Scaffold(
                    backgroundColor: const Color(0xFFDFDFDF),

                    body: RefreshIndicator(
                      onRefresh: (){
                        return refetch!();
                      },
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              ///Heading
                              PageTitle('Contacts', context),

                              dropDown(
                                  Hostels: hostels.keys.toList(),
                                  dropDownValue: _dropDownValue,
                                  callback: (val) {
                                    setState(() {
                                      _dropDownValue = val;
                                      hostelIdFilter = hostels[val]!;
                                    });
                                  }
                              ),

                              ///Listing of Hostel Contacts
                              if(contacts.isNotEmpty)
                              const Center(
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(8, 10, 8, 4),
                                  child: Text('Hostel Contacts',
                                    style: TextStyle(
                                        color: Color(0xFF222222),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                              ),
                              if(contacts.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        5.0, 8.0, 5.0, 0.0),
                                    child: RefreshIndicator(
                                      onRefresh: () {
                                        return refetch!();
                                      },
                                      child: ListView(
                                          controller: scrollController,
                                          shrinkWrap: true,
                                          children: [Column(
                                            children: contacts
                                                .map((post) =>
                                                HostelContacts(
                                                  contacts: post,
                                                  userRole: userRole, refetch: refetch,
                                                ))
                                                .toList(),
                                          ),
                                          ]
                                      ),
                                    ),
                                  ),

                                  ///EMERGENCY CONTACTS
                                  const Center(
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(8, 10, 8, 4),
                                      child: Text('Emergency Contacts',
                                        style: TextStyle(
                                            color: Color(0xFF222222),
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                                  ),

                                  //Emergency-Contact List
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        5.0, 8.0, 5.0, 15.0),
                                    child: ListView(
                                      controller: scrollController,
                                      shrinkWrap: true,
                                      children: [Column(
                                        children: emergencyContacts
                                            .map((post) =>
                                            EmergencyContacts(
                                              Emergencycontacts: post,
                                            ))
                                            .toList(),
                                      ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                    ),

                    floatingActionButton: _getFAB(refetch),
                  );
                },
              );
            }
        );
      }
      if (userRole == "USER") {
    hostelName = result.data!["getMe"]["hostel"]["name"];

    if (result.data!["getMe"]["hostel"]["contacts"] != null ||
    result.data!["getMe"]["hostel"]["contacts"].isNotEmpty) {
    contacts.clear();
    for (var i = 0; i <
    result.data!["getMe"]["hostel"]["contacts"].length; i++) {
    contacts.add(Contacts(
    name: result.data!["getMe"]["hostel"]["contacts"][i]["name"],
    type: result.data!["getMe"]["hostel"]["contacts"][i]["type"],
    contact: result.data!["getMe"]["hostel"]["contacts"][i]["contact"],
    id: result.data!["getMe"]["hostel"]["contacts"][i]["id"],
      hostel: result.data!["getMe"]["hostel"],
    ),
    );
    }
    }
    }
        return Scaffold(
          backgroundColor: const Color(0xFFDFDFDF),
          body: RefreshIndicator(
            onRefresh: (){
              return refetch!();
            },
            child: ListView(
              shrinkWrap: true,
              children: [

                ///Heading
                PageTitle('Contacts', context),

                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
                  child: ListView(
                    shrinkWrap: true,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            ///Hostel Contacts
                            if(contacts.isNotEmpty)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(8, 10, 8, 4),
                                child: Text('Hostel Contacts',
                                  style: TextStyle(
                                      color: Color(0xFF222222),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ),
                            //Hostel contact list
                            if(contacts.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    5.0, 8.0, 5.0, 0.0),
                                child: ListView(
                                    controller: scrollController,
                                    shrinkWrap: true,
                                    children: [ Column(
                                      children: contacts
                                          .map((post) =>
                                          HostelContacts(
                                            contacts: post,
                                            userRole: userRole, refetch: refetch,
                                          ))
                                          .toList(),
                                    ),
                                    ]
                                ),
                              ),

                            ///EMERGENCY CONTACTS
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(8, 10, 8, 4),
                                child: Text('Emergency Contacts',
                                  style: TextStyle(
                                      color: Color(0xFF222222),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ),

                            //Emergency-Contact List
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  5.0, 8.0, 5.0, 15.0),
                              child: ListView(
                                controller: scrollController,
                                shrinkWrap: true,
                                children: [Column(
                                  children: emergencyContacts
                                      .map((post) =>
                                      EmergencyContacts(
                                        Emergencycontacts: post,
                                      ))
                                      .toList(),
                                ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ]
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
  ///Widget for the floating action button
  Widget? _getFAB(Future<QueryResult?> Function()? refetch) {
    if(userRole=="ADMIN" || userRole == 'HAS' || userRole == 'HOSTEL_SEC'){
      return FloatingActionButton(onPressed: () {
        Navigator.of(context).push(
            MaterialPageRoute(
                builder: (BuildContext context)=> CreateHostelContact(refetch: refetch, userRole: userRole,)));
      },
        child: const Icon(Icons.add,color: Colors.white,),
        backgroundColor: Colors.black,
      );
    }
    else {
      return null;
    }
  }
}
