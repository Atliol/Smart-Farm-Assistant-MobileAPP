class HerbicideModel {
  final String id;
  final String title;
  final String image;
  final String chemicalName;
  final String targetWeed;
  final String description;
  final List<HerbSubStepModel> subSteps;

  HerbicideModel({
    required this.id,
    required this.title,
    required this.image,
    required this.chemicalName,
    required this.targetWeed,
    required this.description,
    required this.subSteps,
  });

  factory HerbicideModel.fromJson(Map<String, dynamic> json) {
    var list = json['sub_steps'] as List?;
    List<HerbSubStepModel> stepsList = list != null
        ? list.map((i) => HerbSubStepModel.fromJson(Map<String, dynamic>.from(i as Map))).toList()
        : [];

    return HerbicideModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      image: json['image'] as String? ?? '',
      chemicalName: json['chemical_name'] as String? ?? 'မဖော်ပြထားပါ',
      targetWeed: json['target_weed'] as String? ?? 'ပေါင်းမြက်များ',
      description: json['description'] as String? ?? '',
      subSteps: stepsList,
    );
  }
}

class HerbSubStepModel {
  final String subTitle;
  final String subImage;
  final String subDescription;

  HerbSubStepModel({
    required this.subTitle,
    required this.subImage,
    required this.subDescription,
  });

  factory HerbSubStepModel.fromJson(Map<String, dynamic> json) {
    return HerbSubStepModel(
      subTitle: json['sub_title'] as String? ?? '',
      subImage: json['sub_image'] as String? ?? '',
      subDescription: json['sub_description'] as String? ?? '',
    );
  }
}