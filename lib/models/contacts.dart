import 'hostel.dart';

class ContactsModel {
  final List<ContactModel> contacts;

  ContactsModel({required this.contacts});

  ContactsModel.fromJson(List<dynamic> data)
      : contacts = data.map((e) => ContactModel.fromJson(e)).toList();

  List<ContactModel> search(String key) {
    List<ContactModel> _contacts = [];
    contacts.forEach(((e) {
      if (key == "" ||
          (e.hostel.name + e.name + e.number + e.type)
              .toLowerCase()
              .contains(key.toLowerCase())) {
        _contacts.add(e);
      }
    }));
    return _contacts;
  }
}

class ContactModel {
  final String id;
  final String name;
  final String type;
  final String number;
  final HostelModel hostel;
  final List<String> permissions;

  ContactModel(
      {required this.id,
      required this.name,
      required this.type,
      required this.number,
      required this.hostel,
      required this.permissions});

  ContactModel.fromJson(Map<String, dynamic> data)
      : id = data["id"],
        name = data["name"],
        type = data["type"],
        number = data["contact"],
        hostel = HostelModel.fromJson(data["hostel"]),
        permissions = data["permissions"].cast<String>();
}
