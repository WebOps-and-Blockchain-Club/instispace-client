import 'user.dart';

class GroupModel {
  String id;
  String name;
  String code;
  String startTime;
  String endTime;
  int? minMembers;
  int? maxMembers;
  List<UserModel>? users;
  List<QuestionModel>? questions;

  GroupModel(
      {required this.id,
      required this.name,
      required this.code,
      required this.startTime,
      required this.endTime,
      required this.minMembers,
      required this.maxMembers,
      this.users,
      this.questions});

  GroupModel.fromJson(Map<String, dynamic> data)
      : id = data["group"]["id"],
        name = data["group"]["name"],
        code = data["group"]["code"],
        minMembers = data["minMembers"],
        maxMembers = data["maxMembers"],
        startTime = data["startTime"],
        endTime = data["endTime"],
        users = data["group"]["users"]
            ?.map((e) => UserModel.fromJson(e))
            .toList()
            .cast<UserModel>(),
        questions = data["questions"] != null
            ? QuestionsModel.fromJson(data["questions"]).questions
            : null;
}

class QuestionsModel {
  final List<QuestionModel> questions;

  QuestionsModel({required this.questions});

  QuestionsModel.fromJson(List<dynamic> data)
      : questions = data.map((e) => QuestionModel.fromJson(e)).toList();
}

class QuestionModel {
  final String id;
  final String description;
  final String? image;
  final SubmissionModel? submission;

  QuestionModel(
      {required this.id,
      required this.description,
      required this.image,
      this.submission});

  QuestionModel.fromJson(Map<String, dynamic> data)
      : id = data["id"],
        description = data["description"],
        image = data["images"],
        submission = data["submission"] != null
            ? SubmissionModel.fromJson(data["submission"])
            : null;
}

class SubmissionModel {
  final String id;
  final String description;
  final String? images;
  final CreatedByModel createdBy;
  final String createdAt;

  SubmissionModel(
      {required this.id,
      required this.description,
      this.images,
      required this.createdBy,
      required this.createdAt});

  SubmissionModel.fromJson(Map<String, dynamic> data)
      : id = data["id"],
        description = data["description"],
        images = data["images"],
        createdBy = CreatedByModel.fromJson(data["submittedBy"]),
        createdAt = data["createdAt"];
}
