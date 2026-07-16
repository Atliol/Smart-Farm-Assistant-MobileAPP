class KnowledgeModel {
  final String id;
  final String title;
  final String image;
  final String date;
  final String readTime;
  final String tag;
  final String description;
  final List<KnowSubStepModel> subSteps;

  KnowledgeModel({
    required this.id,
    required this.title,
    required this.image,
    required this.date,
    required this.readTime,
    required this.tag,
    required this.description,
    required this.subSteps,
  });

  factory KnowledgeModel.fromJson(Map<String, dynamic> json) {
    var list = json['sub_steps'] as List?;
    List<KnowSubStepModel> stepsList = list != null
        ? list.map((i) => KnowSubStepModel.fromJson(Map<String, dynamic>.from(i as Map))).toList() // 💡 ပြင်ဆင်ထားသော လိုင်း
        : [];

    return KnowledgeModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      image: json['image'] as String? ?? '',
      date: json['date'] as String? ?? '',
      readTime: json['read_time'] as String? ?? '',
      tag: json['tag'] as String? ?? '',
      description: json['description'] as String? ?? '',
      subSteps: stepsList,
    );
  }
}

class KnowSubStepModel {
  final String subTitle;
  final String subImage;
  final String subDescription;

  KnowSubStepModel({
    required this.subTitle,
    required this.subImage,
    required this.subDescription,
  });

  factory KnowSubStepModel.fromJson(Map<String, dynamic> json) {
    return KnowSubStepModel(
      subTitle: json['sub_title'] as String? ?? '',
      subImage: json['sub_image'] as String? ?? '',
      subDescription: json['sub_description'] as String? ?? '',
    );
  }
}