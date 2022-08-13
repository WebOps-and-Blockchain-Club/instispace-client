import 'post.dart';
import 'hostel.dart';

class AmenitiesModel {
  final List<AmenityModel> amenities;

  AmenitiesModel({required this.amenities});

  AmenitiesModel.fromJson(List<dynamic> data)
      : amenities = data.map((e) => AmenityModel.fromJson(e)).toList();

  List<PostModel> toPostsModel(String key) {
    List<AmenityModel> _amenities = [];
    amenities.forEach(((e) {
      if (key == "" ||
          (e.hostel.name + e.title + e.description)
              .toLowerCase()
              .contains(key.toLowerCase())) {
        _amenities.add(e);
      }
    }));
    return _amenities.map((e) => e.toPostModel()).toList();
  }
}

class AmenityModel {
  final String id;
  final String title;
  final String description;
  final List<String>? attachements;
  final HostelModel hostel;
  final List<String> permissions;

  AmenityModel(
      {required this.id,
      required this.title,
      required this.description,
      this.attachements,
      required this.hostel,
      required this.permissions});

  AmenityModel.fromJson(Map<String, dynamic> data)
      : id = data["id"],
        title = data["name"],
        description = data["description"],
        attachements = data["images"]?.split(" AND "),
        hostel = HostelModel.fromJson(data["hostel"]),
        permissions = data["permissions"].cast<String>();

  PostModel toPostModel() {
    return PostModel(
        id: id,
        title: title,
        description: description,
        attachements: attachements,
        subTitle: hostel.name,
        permissions: permissions);
  }
}

class AmenityEditModel {
  final String id;
  final String title;
  final String description;

  AmenityEditModel(
      {required this.id, required this.title, required this.description});
}
