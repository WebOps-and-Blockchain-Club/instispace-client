import 'package:client/models/tag.dart';
import 'package:client/models/commentclass.dart';

class NetOpReportPost {
  String title;
  String description;
  String? imgUrl;
  String? linkToAction;
  List<Tag> tags;
  String endTime;
  String id;
  String? attachment;
  String createdByName;
  String? linkName;
  String reportDescription;
  String reportedByName;
  String reportedByRoll;

  NetOpReportPost({required this.title,
    required this.description,
    required this.imgUrl,
    required this.linkToAction,
    required this.tags,
    required this.endTime,
    required this.createdByName,
    required this.id,
    required this.attachment,
    required this.linkName,
    required this.reportDescription,
    required this.reportedByRoll,
    required this.reportedByName
  });
}
