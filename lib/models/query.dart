class queryClass{
  String id;
  String title;
  List<String> imgUrl;
  String content;
  int likeCount;
  String createdByName;
  String createdByRoll;
  bool isLiked;
  String createdById;

  queryClass({required this.id,required this.title,required this.likeCount,required this.content, required this.createdByName, required this.createdByRoll,required this.imgUrl,required this.isLiked, required this.createdById});
}