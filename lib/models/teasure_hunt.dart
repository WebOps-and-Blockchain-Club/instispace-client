import 'user.dart';

class GroupModel {
  String id;
  String name;
  String code;
  List<UserModel>? users;
  List<QuestionModel>? questions;

  GroupModel(
      {required this.id,
      required this.name,
      required this.code,
      this.users,
      this.questions});

  GroupModel.fromJson(Map<String, dynamic> data)
      : id = data["id"],
        name = data["name"],
        code = data["code"],
        users = data["users"]?.map((e) => UserModel.fromJson(e)).toList(),
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
        submission = SubmissionModel.fromJson(data["submission"]);
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
        images = data["image"],
        createdBy = CreatedByModel.fromJson(data["createdBy"]),
        createdAt = data["createdAt"];
}
