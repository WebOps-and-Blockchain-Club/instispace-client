class BadgeModel {
  final String? id;

  final String tier;
  final int threshold;
  final String imageUrl;

  BadgeModel({
    this.id,
    required this.tier,
    required this.threshold,
    required this.imageUrl,
  });

  BadgeModel.fromJson(Map<String, dynamic> data)
      : id = data['id'],
        tier = data['tier'],
        threshold = data['threshold'],
        imageUrl = data['imageUrl'];

  Map<String, dynamic> toJson() => {
        'tier': tier,
        'threshold': threshold,
        'imageURL': imageUrl,
      };
}
