import 'package:client/graphQL/home.dart';
import 'package:client/widgets/headings.dart';
import 'package:client/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../graphQL/hostelProfile.dart';
import '../homeCards.dart';
import 'package:client/widgets/loading screens.dart';

class Hostelcontacts extends StatefulWidget {
  const Hostelcontacts({Key? key}) : super(key: key);

  @override
  _HostelcontactsState createState() => _HostelcontactsState();
}

class _HostelcontactsState extends State<Hostelcontacts> {

  String getMe = homeQuery().getMe;
  String hostelName = '';
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
        return Scaffold(
          body: Center(
            child: Column(
              children: [
                PageTitle('Contacts', context),
                Expanded(
                    child: ListView.separated(
                        itemBuilder: (context, index) => NewCardSkeleton(),
                        separatorBuilder: (context, index) => const SizedBox(height: 6,),
                        itemCount: 5)
                )
              ],
            ),
          ),
        );
      }

      hostelName = result.data!["getMe"]["hostel"]["name"];

      contacts.clear();
      emergencyContacts.clear();

      for (var i = 0; i <
          result.data!["getMe"]["hostel"]["contacts"].length; i++) {
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
        backgroundColor: const Color(0xFFDFDFDF),
        body: ListView(
          shrinkWrap: true,
          children: [
            PageTitle('Contacts', context),
            Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

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
    }
    );
  }
}
