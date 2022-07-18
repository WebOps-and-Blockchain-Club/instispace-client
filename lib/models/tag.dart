class TagsModel {
  final List<TagModel> tags;

  TagsModel({required this.tags});

  TagsModel.fromJson(List<dynamic> data)
      : tags = data.map((e) => TagModel.fromJson(e)).toList();

  List<Map<String, dynamic>> toJson() => tags.map((e) => e.toJson()).toList();

  List<TagModel> sortByCategory() {
    tags.sort((a, b) => a.category.compareTo(b.category));
    return tags;
  }

  List<String> getCategorys() {
    return tags.map((e) => e.category).toSet().toList();
  }

  List<TagModel> filterByCategory(String category) {
    List<TagModel> filteredTags = [];
    tags.forEach(((element) {
      if (element.category == category) {
        filteredTags.add(element);
      }
    }));
    return filteredTags;
  }

  List<String> getTagIds() {
    return tags.map((e) => e.id).toList();
  }

  List<CategoryModel> getCategorysModel() {
    return getCategorys()
        .map((e) => CategoryModel(category: e, tags: filterByCategory(e)))
        .toList();
  }

  void add(TagModel tag) {
    tags.add(tag);
  }

  void remove(TagModel tag) {
    tags.removeWhere((element) => element.id == tag.id);
  }

  bool contains(TagModel tag) {
    bool isContain = false;
    for (var element in tags) {
      if (element.id == tag.id) isContain = true;
    }
    return isContain;
  }
}

class TagModel {
  final String id;
  final String title;
  final String category;
  //create callback func const

  TagModel({required this.id, required this.title, required this.category});

  TagModel.fromJson(Map<String, dynamic> data)
      : id = data["id"],
        title = data["title"],
        category = data["category"];

  Map<String, dynamic> toJson() =>
      {"__typename": "Tag", "id": id, "title": title, "category": category};
}

class CategoryModel {
  final String category;
  final List<TagModel> tags;

  CategoryModel({required this.category, required this.tags});
}

class Tag {
  String Tag_name;
  String category;
  String id;
  Tag({required this.Tag_name, required this.category, required this.id});

  Map toJson() => {'title': Tag_name, 'id': id, 'category': category};
}
