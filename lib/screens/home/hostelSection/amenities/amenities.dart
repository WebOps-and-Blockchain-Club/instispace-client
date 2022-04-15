import 'package:client/graphQL/auth.dart';
import 'package:client/graphQL/home.dart';
import 'package:client/graphQL/hostel.dart';
import 'package:client/models/hostelProfile.dart';
import 'package:client/screens/home/hostelSection/contactAndAmenitiesCard.dart';
import 'package:client/screens/home/hostelSection/amenities/createAmenity.dart';
import 'package:client/screens/userInit/dropDown.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../models/hostelProfile.dart';
import '../../../../widgets/text.dart';
import 'package:client/widgets/loadingScreens.dart';

class HostelAmenities extends StatefulWidget {
  const HostelAmenities({Key? key}) : super(key: key);

  @override
  _HostelAmenitiesState createState() => _HostelAmenitiesState();
}

class _HostelAmenitiesState extends State<HostelAmenities> {

  ///GraphQL
  String getMe = homeQuery().getMe;
  String getHostels = authQuery().getHostels;
  String getAmenities = hostelQM().getAmenities;

  ///Variables
  String hostelName = '';
  String amenityName = '';
  String hostelId = '';
  Map<String, String> hostels = {};
  String _dropDownValue = "All";
  String hostelFilterId = "";
  String search = "";
  int take = 0;
  late int total;
  List<Amenities> amenities = [];
  late String userRole;


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

      ///Loading Screen
      if (result.isLoading) {
        return Scaffold(
          body: Center(
            child: Column(
              children: [
                PageTitle('Hostel Amenities', context),
                Expanded(
                    child: ListView.separated(
                        itemBuilder: (context, index) => const NewCardSkeleton(),
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
      print("userRole : $userRole");
      if(userRole != "ADMIN" && userRole != "HAS") {
        hostelName = result.data!["getMe"]["hostel"]["name"];
      }
      if(userRole == "ADMIN" || userRole == "HAS"){
        return Query(
          options: QueryOptions(
              document: gql(getHostels)
          ),
          builder: (QueryResult result, {fetchMore, refetch}) {
            if (result.hasException) {
              return Text(result.exception.toString());
            }

            ///Loading Screen
            if (result.isLoading) {
              return Scaffold(
                body: Center(
                  child: Column(
                    children: [
                      PageTitle('Hostel Amenities', context),
                      Expanded(
                          child: ListView.separated(
                              itemBuilder: (context, index) => const NewCardSkeleton(),
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
            hostels.putIfAbsent(
                "All",
                    () =>
                ""
            );
            for (var i = 0; i < result.data!["getHostels"].length; i++) {
              hostels.putIfAbsent(
                result.data!["getHostels"][i]["name"],
                    () =>
                result.data!["getHostels"][i]["id"],
              );
            }

            return Query(
              options: QueryOptions(
                  document: gql(getAmenities),
                  variables: {"hostelId": hostelFilterId}
              ),
              builder: (QueryResult result, {fetchMore, refetch}){
                if(result.hasException) {
                  return Text(result.hasException.toString());
                }

                ///Loading Screen
                if (result.isLoading) {
                  return Scaffold(
                    body: Center(
                      child: Column(
                        children: [
                          PageTitle('Hostel Amenities', context),
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

                amenities.clear();
                for(var i = 0; i < result.data!["getAmenities"].length; i++) {
                  amenities.add(Amenities(
                      name: result.data!["getAmenities"][i]["name"],
                      description: result.data!["getAmenities"][i]["description"],
                      id: result.data!["getAmenities"][i]["id"],
                      hostel: result.data!["getAmenities"][i]["hostel"]["name"]
                  ));
                }

                return Scaffold(
                  ///Background colour
                  backgroundColor: const Color(0xFFDFDFDF),

                  body: RefreshIndicator(
                    onRefresh: () {
                      return refetch!();
                    },
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Column(
                          children: [
                            ///Heading
                            PageTitle('Hostel Amenities', context),

                            ///Hostel DropDown
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15,15,15,0),
                              child: dropDown(
                                  Hostels: hostels.keys.toList(),
                                  dropDownValue: _dropDownValue,
                                  callback: (val) {
                                    setState(() {
                                      _dropDownValue = val;
                                      hostelFilterId = hostels[val]!;
                                    });
                                  }),
                            ),

                            ///For no hostel amenities case
                            if (result.data!["getAmenities"] == null || result.data!["getAmenities"].isEmpty)
                              const Padding(
                                padding: EdgeInsets.fromLTRB(0,250,0,0),
                                child: Text(
                                  'No hostel amenities added yet !!',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w600
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),


                            ///Listing of Amenities
                            if (result.data!["getAmenities"] != null || result.data!["getAmenities"].isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(5.0, 8.0, 5.0, 0.0),
                                      child: ListView(
                                          controller: scrollController,
                                          shrinkWrap: true,
                                          children: [Column(
                                            children: amenities
                                                .map((post) =>
                                                HostelAmenity(
                                                  amenities: post,
                                                  userRole: userRole, refetch: refetch,
                                                ))
                                                .toList(),
                                          ),
                                          ]
                                      ),
                                    ),
                                    if (result.isLoading)
                                      const Center(
                                        child: CircularProgressIndicator(
                                          color: Color(0xFFDEDDFF),
                                        ),
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
          },
        );
      }

      else {
        ///If no amenities are there
        if (result.data!["getMe"]["hostel"]["amenities"] == null ||
            result.data!["getMe"]["hostel"]["amenities"].isEmpty) {
          return Scaffold(
            body: Center(
              child: Column(
                children: [
                  ///heading
                  PageTitle('Hostel Amenities', context),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 250, 0, 0),
                    child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          'No hostel amenities added yet !!',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.w600
                          ),
                          textAlign: TextAlign.center,
                        )
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: _getFAB(refetch),
          );
        }
        else {
          amenities.clear();
          for (var i = 0; i <
              result.data!["getMe"]["hostel"]["amenities"].length; i++) {
            amenities.add(Amenities(
              name: result.data!["getMe"]["hostel"]["amenities"][i]["name"],
              description: result.data!["getMe"]["hostel"]["amenities"][i]["description"],
              id: result.data!["getMe"]["hostel"]["amenities"][i]["id"],
              hostel: result.data!["getMe"]["hostel"]["name"],
            ));
          }
        }
      }

          return Scaffold(
            ///Background colour
            backgroundColor: const Color(0xFFDFDFDF),

            body: RefreshIndicator(
              onRefresh: (){
                return refetch!();
              },
              child: ListView(
                shrinkWrap: true,
                children: [
                    Column(
                      children: [
                        ///Heading
                        PageTitle('Hostel Amenities', context),

                        ///For no hostel amenities case
                        if (amenities.isEmpty)
                          const Padding(
                            padding:  EdgeInsets.fromLTRB(0,250,0,0),
                            child: Text(
                              'No hostel amenities added yet !!',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w600
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),


                        ///Listing of Amenities
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(5.0, 8.0, 5.0, 0.0),
                                child: ListView(
                                    controller: scrollController,
                                    shrinkWrap: true,
                                    children: [Column(
                                      children: amenities
                                          .map((post) =>
                                          HostelAmenity(
                                            amenities: post, userRole: userRole,refetch: refetch,
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
                ],
              ),
            ),
            floatingActionButton: _getFAB(refetch),
          );
    });
  }


  ///Widget for the floating action button
  Widget? _getFAB(Future<QueryResult?> Function()? refetch) {
    if(userRole=="ADMIN" || userRole == 'HAS' || userRole == 'HOSTEL_SEC'){
      return FloatingActionButton(onPressed: () {
        Navigator.of(context).push(
            MaterialPageRoute(
                builder: (BuildContext context)=> CreateHostelAmenity(refetch: refetch, userRole: userRole,)));
      },
        child: const Icon(Icons.add,color: Color(0xFFFFFFFF),),
        backgroundColor: Colors.black,
      );
    }
    else {
      return null;
    }
  }
}
