import '../category.dart';
import '../tag.dart';

class PostQueryVariableModel {
  final int take;
  final String lastPostId;
  final bool byLikes;
  final bool byComments;
  final String? search;
  final bool postToBeApproved;
  final bool followedTags;
  final bool viewReportedPosts;
  final List<TagModel>? tags;
  final bool isSaved;
  final bool showOldPost;
  final bool isLiked;
  final List<PostCategoryModel>? categories;
  final bool createdByMe;
  final String? createdById;

  PostQueryVariableModel(
      {this.take = 10,
      this.lastPostId = '',
      this.byLikes = false,
      this.byComments = false,
      this.search,
      this.postToBeApproved = false,
      this.followedTags = false,
      this.viewReportedPosts = false,
      this.tags,
      this.isSaved = false,
      this.showOldPost = false,
      this.isLiked = false,
      this.categories,
      this.createdByMe = false,
      this.createdById});

  Map<String, dynamic> toJson() {
    return {
      "take": take,
      "lastEventId": lastPostId,
      "orderInput": {"byLikes": byLikes, "byComments": byComments},
      "filteringCondition": {
        "search": search?.trim(),
        "posttobeApproved": postToBeApproved,
        "followedTags": followedTags,
        "viewReportedPosts": viewReportedPosts,
        "tags": tags?.map((e) => e.id).toList(),
        "isSaved": isSaved,
        "showOldPost": showOldPost,
        "isLiked": isLiked,
        "categories": categories?.map((e) => e.name).toList(),
        "createdByMe": createdByMe,
        "createBy": createdById,
      },
    };
  }
}
