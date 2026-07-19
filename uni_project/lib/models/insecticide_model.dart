class InsecticideModel {
  final String id;
  final String title;
  final String image;
  final String chemicalName;
  final String targetPest;
  final String description;
  final List<InsSubStepModel> subSteps;

  InsecticideModel({
    required this.id,
    required this.title,
    required this.image,
    required this.chemicalName,
    required this.targetPest,
    required this.description,
    required this.subSteps,
  });

  factory InsecticideModel.fromJson(Map<String, dynamic> json) {
    var list = json['sub_steps'] as List?;
    List<InsSubStepModel> stepsList = list != null
        ? list.map((i) => InsSubStepModel.fromJson(Map<String, dynamic>.from(i as Map))).toList()
        : [];

    return InsecticideModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      image: json['image'] as String? ?? '',
      chemicalName: json['chemical_name'] as String? ?? 'မဖော်ပြထားပါ',
      targetPest: json['target_pest'] as String? ?? 'အင်းဆက်ပိုးမွှားများ',
      description: json['description'] as String? ?? '',
      subSteps: stepsList,
    );
  }
}

class InsSubStepModel {
  final String subTitle;
  final String subImage;
  final String subDescription;

  InsSubStepModel({
    required this.subTitle,
    required this.subImage,
    required this.subDescription,
  });

  factory InsSubStepModel.fromJson(Map<String, dynamic> json) {
    return InsSubStepModel(
      subTitle: json['sub_title'] as String? ?? '',
      subImage: json['sub_image'] as String? ?? '',
      subDescription: json['sub_description'] as String? ?? '',
    );
  }
}