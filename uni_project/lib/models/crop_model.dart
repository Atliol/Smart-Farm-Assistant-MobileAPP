class CropModel {
  final String id;
  final String title;
  final String image;
  final String description;
  final List<SubStepModel> subSteps;

  CropModel({
    required this.id,
    required this.title,
    required this.image,
    required this.description,
    required this.subSteps,
  });

  factory CropModel.fromJson(Map<String, dynamic> json) {
    var list = json['sub_steps'] as List?;
    List<SubStepModel> stepsList = list != null
        ? list.map((i) => SubStepModel.fromJson(Map<String, dynamic>.from(i as Map))).toList() // 💡 ပြင်ဆင်ထားသော လိုင်း
        : [];

    return CropModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      image: json['image'] as String? ?? '',
      description: json['description'] as String? ?? '',
      subSteps: stepsList,
    );
  }
}

class SubStepModel {
  final String subTitle;
  final String subImage;
  final String subDescription;

  SubStepModel({
    required this.subTitle,
    required this.subImage,
    required this.subDescription,
  });

  factory SubStepModel.fromJson(Map<String, dynamic> json) {
    return SubStepModel(
      subTitle: json['sub_title'] as String? ?? '',
      subImage: json['sub_image'] as String? ?? '',
      subDescription: json['sub_description'] as String? ?? '',
    );
  }
}