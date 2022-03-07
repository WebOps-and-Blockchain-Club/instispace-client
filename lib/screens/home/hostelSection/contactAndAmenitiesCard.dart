import 'package:client/graphQL/hostel.dart';
import 'package:client/models/hostelProfile.dart';
import 'package:client/screens/home/hostelSection/Amenities/updateAmenity.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../models/hostelProfile.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../widgets/NetOpCard.dart';
import '../../../widgets/marquee.dart';
import 'contacts/updateContact.dart';


///Amenity Card

class HostelAmenity extends StatefulWidget {

  final Amenities amenities;
  final String userRole;
  final Refetch<Object?>? refetch;
  HostelAmenity({required this.amenities,required this.userRole,required this.refetch});

  @override
  _HostelAmenityState createState() => _HostelAmenityState();
}

class _HostelAmenityState extends State<HostelAmenity> {

  String deleteAmenity = hostelQM().deleteAmenity;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 4.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.5)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///Name
            Container(
              color: Color(0xFF42454D),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                //     Text(widget.amenities.name,
                //       style: const TextStyle(
                //         color: Colors.white,
                //         fontSize: 16.5,
                //         fontWeight: FontWeight.bold,
                //       ),
                // ),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(0,0,0,0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: MarqueeWidget(
                            direction: Axis.horizontal,
                            child: Text(
                              capitalize(widget.amenities.name),
                              style: const TextStyle(
                                //Conditional Font Size
                                fontWeight: FontWeight.bold,
                                //Conditional Font Size
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                    ),

                    ///Edit Button, delete button
                    if (widget.userRole == "ADMIN" || widget.userRole == "HAS" || widget.userRole == "HOSTEL_SEC")
                      Row(
                        children: [
                          ///Edit Button
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) => UpdateAmenity(amenities: widget.amenities,refetch: widget.refetch,)));
                            },
                            icon: const Icon(Icons.edit_outlined),
                            color: Colors.white,
                            iconSize: 20,
                          ),

                          ///Delete Button
                          Mutation(
                              options:MutationOptions(
                                  document: gql(deleteAmenity),
                                  onCompleted: (resultData){
                                    if(resultData["deleteAmenity"]){
                                      widget.refetch!();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Amenity deleted')),
                                      );
                                    }
                                    else{
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text("Amenity didn't get deleted")),
                                      );
                                    }
                                  },
                                  onError: (dynamic error){
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Amenity didn't get deleted,server error")),
                                    );
                                  }
                              ),
                              builder: (
                                  RunMutation runMutation,
                                  QueryResult? result,
                                  ){
                                if (result!.hasException){
                                  print(result.exception.toString());
                                }
                                if(result.isLoading){
                                  return Center(
                                      child: LoadingAnimationWidget.threeRotatingDots(
                                        color: Color(0xFF2B2E35),
                                        size: 20,
                                      ));
                                }
                                return IconButton(
                                  onPressed: ()
                                  {
                                    runMutation({
                                      "amenityId": widget.amenities.id
                                    });
                                  },
                                  icon: const Icon(Icons.delete_outline),
                                  iconSize: 20,
                                  color: Colors.white,
                                );
                              }
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),

            ///Description
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
              child: Wrap(
                children: [
                  Text(widget.amenities.description,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),

            if(widget.userRole == "ADMIN" || widget.userRole == "HAS" || widget.userRole == "HOSTEL_SEC")
                Padding(
                  padding: const EdgeInsets.fromLTRB(15,0,15,15),
                  child: Wrap(
                      children: [ElevatedButton(
                        onPressed: () => {},
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8,2,8,2),
                          child: Text(
                            widget.amenities.hostel,
                            style: const TextStyle(
                              color: Color(0xFF2B2E35),
                              fontSize: 12.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                            primary: const Color(0xFFDFDFDF),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 2,
                                horizontal: 6),
                            minimumSize: const Size(35, 30)
                        ),
                      ),
                      ]
                  ),
                ),
          ],
        ),
      ),
    );
  }
}


///Hostel Contact Card

class HostelContacts extends StatefulWidget {

  final Contacts contacts;
  final String userRole;
  final Refetch<Object?>? refetch;
  HostelContacts({required this.contacts,required this.userRole, required this.refetch});

  @override
  _HostelContactsState createState() => _HostelContactsState();
}

class _HostelContactsState extends State<HostelContacts> {

  String deleteContact = hostelQM().deleteContact;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
      child: Card(
        elevation: 3,
        color: const Color(0xFFFFFFFF),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    ///Designation
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 10, 10, 5),
                      child: Wrap(
                        children: [
                          Text(widget.contacts.type,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    ///Contact Name
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 10, 10),
                      child: Wrap(
                        children: [
                          Text(widget.contacts.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                ///Mobile
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 15, 0),
                  child: ElevatedButton(
                      onPressed: () {
                        launch('tel:${widget.contacts.contact}');
                      },
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xFF42454D),
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        minimumSize: const Size(50, 35),
                      ),
                      child: Row(
                        children: const [
                           Icon(
                            Icons.call,
                            color: Colors.white,
                            size: 14,
                          ),

                           SizedBox(
                            width: 5,
                          ),

                          Text("Call",
                            style:  TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                  ),
                ),
              ],
            ),

            if(widget.userRole == "ADMIN" || widget.userRole == "HAS" || widget.userRole == "HOSTEL_SEC")
              Padding(
                padding: const EdgeInsets.fromLTRB(15,0,15,15),
                child: Wrap(
                    children: [ElevatedButton(
                      onPressed: () => {},
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8,2,8,2),
                        child: Text(
                          widget.contacts.hostel,
                          style: const TextStyle(
                            color: Color(0xFF2B2E35),
                            fontSize: 12.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: const Color(0xFFDFDFDF),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 2,
                              horizontal: 6),
                          minimumSize: const Size(35, 30)
                      ),
                    ),
                    ]
                ),
              ),

            if (widget.userRole == "ADMIN" || widget.userRole == "HAS" || widget.userRole == "HOSTEL_SEC")
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => UpdateContact(contacts: widget.contacts,refetch: widget.refetch,)));
                      },
                      icon: Icon(Icons.edit,color: Colors.grey,)
                  ),
                  Mutation(
                      options:MutationOptions(
                          document: gql(deleteContact),
                          onCompleted: (resultData){
                            print("deleteResultData : ${resultData}");
                            if(resultData["deleteHostelContact"]){
                              widget.refetch!();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Contact deleted')),
                              );
                            }
                            else{
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Contact didn't get deleted")),
                              );
                            }
                          },
                          onError: (dynamic error){
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Contact didn't get deleted,server error")),
                            );
                          }
                      ),
                      builder: (
                          RunMutation runMutation,
                          QueryResult? result,
                          ){
                        if (result!.hasException){
                          print(result.exception.toString());
                        }
                        if(result.isLoading){
                          return Center(
                              child: LoadingAnimationWidget.threeRotatingDots(
                                color: const Color(0xFF2B2E35),
                                size: 20,
                              ));
                        }
                        return IconButton(
                          onPressed: ()
                          {
                            runMutation({
                              "contactId": widget.contacts.id
                            });
                          },
                          icon: const Icon(Icons.delete),
                          iconSize: 20,
                          color: Colors.grey,
                        );
                      }
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}


///Emergency Contact Card

class EmergencyContacts extends StatefulWidget {

  final emergencycontacts Emergencycontacts;
  EmergencyContacts({required this.Emergencycontacts});

  @override
  _EmergencyContactsState createState() => _EmergencyContactsState();
}

class _EmergencyContactsState extends State<EmergencyContacts> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
      child: Card(
        elevation: 3,
        color: const Color(0xFFFFFFFF),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0)),

        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ///Name
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
                child: SizedBox(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.30,
                  child: Wrap(
                      children: [
                        Text(widget.Emergencycontacts.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),]
                  ),
                ),
              ),

              ///Mobile
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 12, 0),
                child: ElevatedButton(
                  onPressed: () {
                    launch('tel:${widget.Emergencycontacts.contact}');
                  },

                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xFF42454D),
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    minimumSize: const Size(50, 35),
                  ),

                  child: Center(
                    child: Row(
                      children: const[
                        Icon(
                          Icons.call,
                          color: Colors.white,
                          size: 14,
                        ),

                        SizedBox(
                          width: 5,
                        ),

                        Text("Call",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



