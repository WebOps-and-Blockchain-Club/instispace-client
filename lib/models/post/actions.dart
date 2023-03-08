class LinkModel {
  final String name;
  final String link;

  LinkModel({required this.name, required this.link});
}

class LikeModel {
  final int count;
  final bool isLikedByUser;

  LikeModel({required this.count, required this.isLikedByUser});
}

class DisLikeModel {
  final int count;
  final bool isDislikedByUser;

  DisLikeModel({required this.count, required this.isDislikedByUser});
}

class CommentsModel {
  final List<CommentModel> comments;
  final int count;

  CommentsModel({required this.comments, required this.count});

  CommentsModel.fromJson(List<dynamic> commentsList, this.count)
      : comments = commentsList.map((e) => CommentModel.fromJson(e)).toList();

  List<CommentModel> sort(
    String? on,
    int? count,
  ) {
    if (on == "LIKE_COUNT") {
      comments.sort((a, b) => a.like.count.compareTo(b.like.count));
    } else if (on == "CREATED_AT") {
      comments.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    }
    return comments.sublist(0, count ?? 2);
  }
}

class CommentModel {
  final String id;
  final String content;
  final LikeModel like;
  final List<String>? images;
  final String createdAt;
  final CreatedByModel createdBy;

  CommentModel(
      {required this.id,
      required this.content,
      required this.createdAt,
      this.images,
      required this.like,
      required this.createdBy});

  CommentModel.fromJson(Map<String, dynamic> data)
      : id = data["id"],
        content = data["content"],
        like =
            LikeModel(count: data["likeCount"], isLikedByUser: data["isLiked"]),
        images = data['photo'] != '' && data['photo'] != null
            ? data['photo'].split(' AND ')
            : null,
        createdBy = CreatedByModel.fromJson(data["createdBy"]),
        createdAt = data["createdAt"];
}

class SavePostModel {
  final bool isSavedByUser;

  SavePostModel({required this.isSavedByUser});
}

class CreatedByModel {
  final String id;
  final String name;
  final String? roll;
  final String? role;
  final String photo;

  CreatedByModel(
      {required this.id,
      required this.name,
      this.roll,
      this.role,
      required this.photo});

  CreatedByModel.fromJson(Map<String, dynamic> data)
      : id = data["id"],
        name = data["name"],
        roll = data["roll"],
        role = data["role"],
        photo = data["photo"] != ""
            ? data['photo']
            : data['roll'] == 'cfi@smail.iitm.ac.in'
                ? "https://media.licdn.com/dms/image/C4D0BAQGEK-WB5mNx4g/company-logo_200_200/0/1519911884159?e=2147483647&v=beta&t=4Tsb5Gx2LoQXmCk_wN1jqdCGX5qAY8ejRpFMgcTpSHE"
                : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ835BghQCqBsROIiDKH37nh68eOOCCsiq1WGGrYG8Cfw&s';
}
