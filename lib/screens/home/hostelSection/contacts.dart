import 'package:client/graphQL/home.dart';
import 'package:client/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../models/hostelProfile.dart';
import 'contactAndAmenitiesCard.dart';
import 'package:client/widgets/loadingScreens.dart';

class Hostelcontacts extends StatefulWidget {
  const Hostelcontacts({Key? key}) : super(key: key);

  @override
  _HostelcontactsState createState() => _HostelcontactsState();
}

class _HostelcontactsState extends State<Hostelcontacts> {

  ///GraphQL
  String getMe = homeQuery().getMe;

  ///Variables
  String hostelName = '';
  List<Contacts> contacts = [];
  List<emergencycontacts> emergencyContacts = [];

  ///Controllers
  ScrollController scrollController = ScrollController(initialScrollOffset: 0.0);

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
        return Scaffold(
          body: Center(
            child: Column(
              children: [
                PageTitle('Contacts', context),
                Expanded(
                    child: ListView.separated(
                        itemBuilder: (context, index) => const NewCardSkeleton(),
                        separatorBuilder: (context, index) => const SizedBox(height: 6,),
                        itemCount: 5)
                )
              ],
            ),
          ),
        );
      }

      hostelName = result.data!["getMe"]["hostel"]["name"];


      if (result.data!["getMe"]["hostel"]["contacts"] != null || result.data!["getMe"]["hostel"]["contacts"].isNotEmpty){
        contacts.clear();
        for (var i = 0; i <
            result.data!["getMe"]["hostel"]["contacts"].length; i++) {
          contacts.add(Contacts(
              name: result.data!["getMe"]["hostel"]["contacts"][i]["name"],
              type: result.data!["getMe"]["hostel"]["contacts"][i]["type"],
              contact: result.data!["getMe"]["hostel"]["contacts"][i]["contact"]
          ));
        }
      }


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

      return Scaffold(
        backgroundColor: const Color(0xFFDFDFDF),
        body: ListView(
          shrinkWrap: true,
          children: [

            ///Heading
            PageTitle('Contacts', context),

            SizedBox(
              height: MediaQuery.of(context).size.height*0.8,
              child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
              child: RefreshIndicator(
                color: const Color(0xFF2B2E35),
                onRefresh: () {
                  return refetch!();
                },
                child: ListView(
                  children:[
                    Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      ///Hostel Contacts
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
                      if(contacts.isNotEmpty || contacts != [])
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

                      ///For empty screen
                      if (contacts.isEmpty || contacts == [])
                        const Padding(
                          padding: EdgeInsets.fromLTRB(5, 8, 5, 0),
                          child: Text('No Hostel Contacts',style: TextStyle(fontSize: 24,fontWeight: FontWeight.w600),),
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
                  ]
                ),
              ),
          ),
            ),
          ],
        ),
      );
    }
    );
  }
}
