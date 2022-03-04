import 'package:client/models/hostelProfile.dart';
import 'package:flutter/material.dart';
import '../../../models/hostelProfile.dart';
import 'package:url_launcher/url_launcher.dart';


///Amenity Card

class HostelAmenity extends StatefulWidget {

  final Amenities amenities;
  HostelAmenity({required this.amenities});

  @override
  _HostelAmenityState createState() => _HostelAmenityState();
}

class _HostelAmenityState extends State<HostelAmenity> {

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
            ///Name
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 10, 5),
              child: Row(
                children: [
                  Text(widget.amenities.name,
                    style: const TextStyle(
                      fontSize: 16.5,
                      fontWeight: FontWeight.bold,
                    ),
              ),
                ],
              ),
            ),

            ///Description
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 10, 10),
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
            Row(),
          ],
        ),
      ),
    );
  }
}


///Hostel Contact Card

class HostelContacts extends StatefulWidget {

  final Contacts contacts;
  HostelContacts({required this.contacts});

  @override
  _HostelContactsState createState() => _HostelContactsState();
}

class _HostelContactsState extends State<HostelContacts> {

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
                  child: SizedBox(
                    width: 120,
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
                          children: [
                            const Icon(
                              Icons.call,
                              color: Colors.white,
                              size: 14,
                            ),

                            const SizedBox(
                              width: 5,
                            ),

                            Text(widget.contacts.contact,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                    ),
                  ),
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
                child: SizedBox(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.35,
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
                        children: [
                          const Icon(
                            Icons.call,
                            color: Colors.white,
                            size: 14,
                          ),

                          const SizedBox(
                            width: 5,
                          ),

                          Text(widget.Emergencycontacts.contact,
                            style: const TextStyle(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}



