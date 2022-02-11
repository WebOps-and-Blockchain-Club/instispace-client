class queryClass{
  String id;
  String title;
  String photo;
  String content;
  int likeCount;
  String createdByName;
  String createdByRoll;
  bool isLiked;
  String createdById;

  queryClass({required this.id,required this.title,required this.likeCount,required this.content, required this.createdByName, required this.createdByRoll,required this.photo,required this.isLiked, required this.createdById});
}