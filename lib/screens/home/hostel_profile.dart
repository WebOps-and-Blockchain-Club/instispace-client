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
      for(var i = 0; i < result.data!["getMe"]["hostel"]["amenities"].length; i++) {
        amenities.add(Amenities(
            name: result.data!["getMe"]["hostel"]["amenities"][i]["name"],
            description: result.data!["getMe"]["hostel"]["amenities"][i]["description"]
        ));
      }

      return Scaffold(
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
                      children: const [
                        Text(
                            "HOSTEL AMENITIES",
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
              ],
            ),
          ),
      ],
        ),
      );
    });
  }
}
