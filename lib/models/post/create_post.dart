class CreatePostModel {
  final FieldModel? imagePrimary;
  final FieldModel? title;
  final FieldModel? description;
  final FieldModel? link;
  final FieldModel? imageSecondary;
  final FieldModel? tag;
  final FieldModel? location;
  final FieldModel? postTime;
  final FieldModel? endTime;

  CreatePostModel({
    this.imagePrimary,
    this.title,
    this.description,
    this.link,
    this.imageSecondary,
    this.tag,
    this.location,
    this.postTime,
    this.endTime,
  });
}

class FieldModel {
  final bool required;
  final String? label;
  final bool enableEdit;
  final int maxImgs;
  final Duration time;
  final DateTime? initTime;

  FieldModel(
      {this.required = true,
      this.label,
      this.enableEdit = true,
      this.maxImgs = 4,
      DateTime? initTime,
      this.time = const Duration(hours: 2)})
      : initTime = initTime ?? DateTime.now();
}
