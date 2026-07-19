class FungicideModel {
  final String id;
  final String title;
  final String image;
  final String chemicalName;
  final String targetDisease;
  final String description;
  final List<FungSubStepModel> subSteps;

  FungicideModel({
    required this.id,
    required this.title,
    required this.image,
    required this.chemicalName,
    required this.targetDisease,
    required this.description,
    required this.subSteps,
  });

  factory FungicideModel.fromJson(Map<String, dynamic> json) {
    var list = json['sub_steps'] as List?;
    List<FungSubStepModel> stepsList = list != null
        ? list.map((i) => FungSubStepModel.fromJson(Map<String, dynamic>.from(i as Map))).toList()
        : [];

    return FungicideModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      image: json['image'] as String? ?? '',
      chemicalName: json['chemical_name'] as String? ?? 'မဖော်ပြထားပါ',
      targetDisease: json['target_disease'] as String? ?? 'အပင်ရောဂါများ',
      description: json['description'] as String? ?? '',
      subSteps: stepsList,
    );
  }
}

class FungSubStepModel {
  final String subTitle;
  final String subImage;
  final String subDescription;

  FungSubStepModel({
    required this.subTitle,
    required this.subImage,
    required this.subDescription,
  });

  factory FungSubStepModel.fromJson(Map<String, dynamic> json) {
    return FungSubStepModel(
      subTitle: json['sub_title'] as String? ?? '',
      subImage: json['sub_image'] as String? ?? '',
      subDescription: json['sub_description'] as String? ?? '',
    );
  }
}