class AquacultureModel {
  final String id;
  final String title;
  final String image;
  final String waterType;
  final String duration;
  final String phLevel;
  final String description;
  final List<AquaSubStepModel> subSteps;

  AquacultureModel({
    required this.id,
    required this.title,
    required this.image,
    required this.waterType,
    required this.duration,
    required this.phLevel,
    required this.description,
    required this.subSteps,
  });

  factory AquacultureModel.fromJson(Map<String, dynamic> json) {
    var list = json['sub_steps'] as List?;
    List<AquaSubStepModel> stepsList = list != null
        ? list.map((i) => AquaSubStepModel.fromJson(Map<String, dynamic>.from(i as Map))).toList() // 💡 ပြင်ဆင်ထားသော လိုင်း
        : [];

    return AquacultureModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      image: json['image'] as String? ?? '',
      waterType: json['water_type'] as String? ?? '',
      duration: json['duration'] as String? ?? '',
      phLevel: json['ph_level'] as String? ?? '',
      description: json['description'] as String? ?? '',
      subSteps: stepsList,
    );
  }
}

class AquaSubStepModel {
  final String subTitle;
  final String subImage;
  final String subDescription;

  AquaSubStepModel({
    required this.subTitle,
    required this.subImage,
    required this.subDescription,
  });

  factory AquaSubStepModel.fromJson(Map<String, dynamic> json) {
    return AquaSubStepModel(
      subTitle: json['sub_title'] as String? ?? '',
      subImage: json['sub_image'] as String? ?? '',
      subDescription: json['sub_description'] as String? ?? '',
    );
  }
}