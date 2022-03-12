import 'package:flutter/cupertino.dart';

class Amenities {
  late String name;
  late String description;
  late String id;
  late String hostel;

  Amenities({required this.name, required this.description,required this.id,required this.hostel});
}

class Contacts {
  late String type;
  late String name;
  late String contact;
  late String id;
  late String hostel;

  Contacts({required this.name, required this.type, required this.contact,required this.id,required this.hostel});
}

class emergencycontacts {
  late String name;
  late String contact;

  emergencycontacts({required this.name, required this.contact});
}