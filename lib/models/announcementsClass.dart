class Announcement {
  String title;
  List <String> hostelIds;
  String description;
  var endTime;
  String? images;
  String id;
  String createdByUserId;
  List<String> hostelNames;

  Announcement({required this.title, required this.hostelIds, required this.description, required this.endTime, required this.id, required this.images, required this.createdByUserId,required this.hostelNames});
}