import 'package:client/graphQL/auth.dart';
import 'package:client/graphQL/home.dart';
import 'package:client/models/hostelProfile.dart';
import 'package:client/screens/home/HostelSection/contactAndAmenitiesCard.dart';
import 'package:client/screens/home/hostelSection/Amenities/createAmenity.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/material.dart';

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

  ///Variables
  String hostelName = '';
  String amenityName = '';
  String amenityHostelId = '';
  String amenityHostelName = '';
  // Map<Amenities,String> amenities = {};
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

      if(userRole == "USER") {
        hostelName = result.data!["getMe"]["hostel"]["name"];
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
                          'No Hostel Amenities added yet !!',
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
          );
        }
        else {
          amenities.clear();
          for (var i = 0; i <
              result.data!["getMe"]["hostel"]["amenities"].length; i++) {
            amenities.add(Amenities(
                name: result.data!["getMe"]["hostel"]["amenities"][i]["name"],
                description: result
                    .data!["getMe"]["hostel"]["amenities"][i]["description"]
            ));
          }
        }
      }

      // if(userRole == "ADMIN" || userRole == "HAS"){
      //   return Query(
      //     options: QueryOptions(
      //       document: gql(getHostels)
      //     ),
      //     builder: (QueryResult result, {fetchMore, refetch}) {
      //       if (result.hasException) {
      //         return Text(result.exception.toString());
      //       }
      //       if (result.isLoading) {
      //         return Scaffold(
      //           body: Center(
      //             child: Column(
      //               children: [
      //                 PageTitle('Hostel Amenities', context),
      //                 Expanded(
      //                     child: ListView.separated(
      //                         itemBuilder: (context, index) => const NewCardSkeleton(),
      //                         separatorBuilder: (context, index) =>
      //                         const SizedBox(height: 6,),
      //                         itemCount: 5)
      //                 )
      //               ],
      //             ),
      //           ),
      //         );
      //       }
      //       if (result.data!["getHostels"]["amenities"] == null ||
      //           result.data!["getHostels"]["amenities"].isEmpty) {
      //         return Scaffold(
      //           body: Center(
      //             child: Column(
      //               children: [
      //
      //                 ///heading
      //                 PageTitle('Hostel Amenities', context),
      //                 Padding(
      //                   padding: const EdgeInsets.fromLTRB(0, 250, 0, 0),
      //                   child: Container(
      //                       alignment: Alignment.center,
      //                       child: const Text(
      //                         'No Hostel Amenities added yet !!',
      //                         style: TextStyle(
      //                             color: Colors.black,
      //                             fontSize: 30,
      //                             fontWeight: FontWeight.w600
      //                         ),
      //                         textAlign: TextAlign.center,
      //                       )
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ),
      //         );
      //       }
      //       else {
      //         amenities.clear();
      //         for (var i = 0; i <
      //             result.data!["getHostels"]["amenities"].length; i++) {
      //           amenityHostelId = result.data!["getHostels"]["amenities"][i]["hostel"]["id"];
      //           amenityHostelName = result.data!["getHostels"]["amenities"][i]["hostel"]["name"];
      //           // amenities.putIfAbsent(Amenities(
      //           //     name: result.data!["getHostels"]["amenities"][i]["name"],
      //           //     description: result
      //           //         .data!["getHostels"]["amenities"][i]["description"]
      //           // ), () => amenityHostelName
      //           // );
      //
      //           amenities.add(Amenities(
      //               name: result.data!["getMe"]["hostel"]["amenities"][i]["name"],
      //               description: result
      //                   .data!["getMe"]["hostel"]["amenities"][i]["description"]
      //           ));
      //         }
      //       }
      //     },
      //   );
      // }

          return Scaffold(
            //UI
            backgroundColor: const Color(0xFFDFDFDF),

            body:

            ListView(
              shrinkWrap: true,
              children: [
                if(userRole == "USER")
                  Column(
                    children: [
                      ///Heading
                      PageTitle('Hostel Amenities', context),

                      ///Listing of Amenities
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(5.0, 8.0, 5.0, 0.0),
                              child: RefreshIndicator(
                                onRefresh: () {
                                  return refetch!();
                                },
                                child: ListView(
                                    controller: scrollController,
                                    shrinkWrap: true,
                                    children: [Column(
                                      children: amenities
                                          .map((post) =>
                                          HostelAmenity(
                                            amenities: post,
                                          ))
                                          .toList(),
                                    ),
                                    ]
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                if(userRole == "ADMIN" || userRole == "HAS" || userRole == "HOSTEL_SEC")
                  Container()
              ],
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
        child: const Icon(Icons.add),
        backgroundColor: Colors.black,
      );
    }
    else {
      return null;
    }
  }
}
