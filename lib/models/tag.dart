import 'event.dart';
import 'netop.dart';
import 'post.dart';

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
    return tags.map((e) => e.id.toString()).toList();
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
  final List<PostModel>? events;
  final List<PostModel>? netops;

  TagModel(
      {required this.id,
      required this.title,
      required this.category,
      this.events,
      this.netops});

  TagModel.fromJson(Map<String, dynamic> data)
      : id = data["id"],
        title = data["title"],
        category = data["category"],
        events = data["events"] != null
            ? EventsModel.fromJson(data["events"]).toPostsModel()
            : null,
        netops = data["netops"] != null
            ? NetopsModel.fromJson(data["netops"]).toPostsModel()
            : null;

  Map<String, dynamic> toJson() =>
      {"__typename": "Tag", "id": id, "title": title, "category": category};
}

class CategoryModel {
  final String category;
  final List<TagModel> tags;

  CategoryModel({required this.category, required this.tags});
}
