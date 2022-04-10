class Tag{
  String Tag_name;
  String category;
  String id;
  Tag({required this.Tag_name,required this.category,required this.id});

  Map toJson()=>{
    'title': Tag_name,
    'id': id,
    'category': category
  };
}