class FertilizerModel {
  final String id;
  final String title;
  final String image;
  final String typeName;
  final String benefits;
  final String description;
  final List<FerSubStepModel> subSteps;

  FertilizerModel({
    required this.id,
    required this.title,
    required this.image,
    required this.typeName,
    required this.benefits,
    required this.description,
    required this.subSteps,
  });

  factory FertilizerModel.fromJson(Map<String, dynamic> json) {
    var list = json['sub_steps'] as List?;
    List<FerSubStepModel> stepsList = list != null
        ? list.map((i) => FerSubStepModel.fromJson(Map<String, dynamic>.from(i as Map))).toList()
        : [];

    return FertilizerModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      image: json['image'] as String? ?? '',
      typeName: json['type_name'] as String? ?? 'မဖော်ပြထားပါ',
      benefits: json['benefits'] as String? ?? 'အပင်အာဟာရဖြည့်တင်းရန်',
      description: json['description'] as String? ?? '',
      subSteps: stepsList,
    );
  }
}

class FerSubStepModel {
  final String subTitle;
  final String subImage;
  final String subDescription;

  FerSubStepModel({
    required this.subTitle,
    required this.subImage,
    required this.subDescription,
  });

  factory FerSubStepModel.fromJson(Map<String, dynamic> json) {
    return FerSubStepModel(
      subTitle: json['sub_title'] as String? ?? '',
      subImage: json['sub_image'] as String? ?? '',
      subDescription: json['sub_description'] as String? ?? '',
    );
  }
}