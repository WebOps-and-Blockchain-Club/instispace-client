import 'package:client/graphQL/auth.dart';
import 'package:client/graphQL/home.dart';
import 'package:client/graphQL/hostelProfile.dart';
import 'package:client/screens/home/homeCards.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/material.dart';

import '../../graphQL/hostelProfile.dart';

class HostelProfile extends StatefulWidget {
  const HostelProfile({Key? key}) : super(key: key);

  @override
  _HostelProfileState createState() => _HostelProfileState();
}

class _HostelProfileState extends State<HostelProfile> {
  String getMe = homeQuery().getMe;
  String hostelName = '';
  String amenityName = '';
  List<Amenities> amenities = [];
  List<Contacts> contacts = [];
  List<emergencycontacts> emergencyContacts = [];
  ScrollController scrollController = ScrollController(initialScrollOffset: 0.0);

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
        document: gql(getMe),
    ),
    builder: (QueryResult result, {fetchMore, refetch}) {
      if (result.hasException) {
        print(result.exception.toString());
      }
      if (result.isLoading) {
        return Center(
          child: CircularProgressIndicator(
            color: Colors.blue[700],
          ),
        );
      }

      hostelName = result.data!["getMe"]["hostel"]["name"];

      amenities.clear();
      contacts.clear();
      emergencyContacts.clear();
      for(var i = 0; i < result.data!["getMe"]["hostel"]["amenities"].length; i++) {
        amenities.add(Amenities(
            name: result.data!["getMe"]["hostel"]["amenities"][i]["name"],
            description: result.data!["getMe"]["hostel"]["amenities"][i]["description"]
        ));
      }

      for(var i = 0; i < result.data!["getMe"]["hostel"]["contacts"].length; i++) {
        contacts.add(Contacts(
            name: result.data!["getMe"]["hostel"]["contacts"][i]["name"],
            type: result.data!["getMe"]["hostel"]["contacts"][i]["type"],
            contact: result.data!["getMe"]["hostel"]["contacts"][i]["contact"]
        ));
      }

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

      return Scaffold(
        appBar: AppBar(
          title: const Text("My Hostel",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,

            ),
          ),
          backgroundColor: Color(0xFF5451FD),
          elevation: 0.0,
          automaticallyImplyLeading: true,
        ),

        //UI
        body: ListView(
          shrinkWrap: true,
          children: [Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Hostel Name
                Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 10, 8, 4),
                    child: Column(
                      children: [
                        Text(
                            "$hostelName Hostel",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 22,
                            color: Color(0xFF5050ED),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                //HOSTEL AMENITIES
                Padding(
                  padding: const EdgeInsets.fromLTRB(6, 15, 0, 0),
                  child: Text(
                    "HOSTEL AMENITIES",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16.5,
                      color: Color(0xFF808080),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(5.0, 8.0, 5.0, 0.0),
                  child: ListView(
                    controller: scrollController,
                    shrinkWrap: true,
                      children: [Column(
                        children: amenities
                            .map((post) => HostelAmenity(
                          amenities: post,
                        ))
                            .toList(),
                      ),
                    ]
                  ),
                ),

                //HOSTEL CONTACTS
                Padding(
                  padding: const EdgeInsets.fromLTRB(6, 15, 0, 0),
                  child: const Text(
                    "HOSTEL CONTACTS",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16.5,
                      color: Color(0xFF808080),
                    ),
                  ),
                ),

                //H-Contact List
                Padding(
                  padding: const EdgeInsets.fromLTRB(5.0, 8.0, 5.0, 0.0),
                  child: ListView(
                    controller: scrollController,
                    shrinkWrap: true,
                    children:[ Column(
                        children: contacts
                            .map((post) => HostelContacts(
                          contacts: post,
                        ))
                            .toList(),
                      ),
                    ]
                  ),
                ),

                //EMERGENCY CONTACTS
                Padding(
                  padding: const EdgeInsets.fromLTRB(6, 15, 0, 0),
                  child: const Text(
                    "EMERGENCY CONTACTS",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16.5,
                      color: Color(0xFF808080),
                    ),
                  ),
                ),

                //E-Contact List
                Padding(
                  padding: const EdgeInsets.fromLTRB(5.0, 8.0, 5.0, 15.0),
                  child: ListView(
                    controller: scrollController,
                    shrinkWrap: true,
                      children: [Column(
                        children: emergencyContacts
                            .map((post) => EmergencyContacts(
                          Emergencycontacts: post,
                        ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
        ),
      );
    });
  }
}
