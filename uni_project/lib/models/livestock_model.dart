class LivestockModel {
  final String id;
  final String title;
  final String image;
  final String type;
  final String duration;
  final String feedType;
  final String description;
  final List<LiveSubStepModel> subSteps;

  LivestockModel({
    required this.id,
    required this.title,
    required this.image,
    required this.type,
    required this.duration,
    required this.feedType,
    required this.description,
    required this.subSteps,
  });

  factory LivestockModel.fromJson(Map<String, dynamic> json) {
    var list = json['sub_steps'] as List?;
    List<LiveSubStepModel> stepsList = list != null
        ? list.map((i) => LiveSubStepModel.fromJson(Map<String, dynamic>.from(i as Map))).toList() // 💡 ပြင်ဆင်ထားသော လိုင်း
        : [];

    return LivestockModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      image: json['image'] as String? ?? '',
      type: json['type'] as String? ?? '',
      duration: json['duration'] as String? ?? '',
      feedType: json['feed_type'] as String? ?? '',
      description: json['description'] as String? ?? '',
      subSteps: stepsList,
    );
  }
}

class LiveSubStepModel {
  final String subTitle;
  final String subImage;
  final String subDescription;

  LiveSubStepModel({
    required this.subTitle,
    required this.subImage,
    required this.subDescription,
  });

  factory LiveSubStepModel.fromJson(Map<String, dynamic> json) {
    return LiveSubStepModel(
      subTitle: json['sub_title'] as String? ?? '',
      subImage: json['sub_image'] as String? ?? '',
      subDescription: json['sub_description'] as String? ?? '',
    );
  }
}