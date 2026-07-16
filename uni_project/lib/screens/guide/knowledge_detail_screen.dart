import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../models/knowledge_model.dart';
import '../../widgets/app_background.dart';

class KnowledgeDetailScreen extends StatelessWidget {
  final KnowledgeModel article;

  const KnowledgeDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("ဆောင်းပါးဖတ်ရှုရန်", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: AppBackground(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 📷 Banner Image
              Image.asset(
                article.image,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: double.infinity, height: 250, color: Colors.grey[300],
                  child: const Icon(Icons.article, size: 50, color: Colors.grey),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🏷️ Tag & Meta Info
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            article.tag,
                            style: TextStyle(color: AppColors.primaryColor, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          "${article.date}  •  ${article.readTime}",
                          style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // 📝 Main Title
                    Text(
                      article.title,
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A237E),
                          height: 1.4
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),

                    // 📖 Main Description
                    Text(
                      article.description,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.8, // စာပိုဒ်ဖတ်ရသက်သာစေရန် Line Height တိုးထားပါသည်
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.justify, // စာသားများကို ဘယ်ညာအညီညှိပေးရန်
                    ),
                    const SizedBox(height: 24),

                    // 💡 Sub steps များ ဆွဲထုတ်ပြခြင်း
                    if (article.subSteps.isNotEmpty) ...[
                      Column(
                        children: article.subSteps.map((step) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  step.subTitle,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                if (step.subImage.isNotEmpty) ...[
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.asset(
                                      step.subImage,
                                      width: double.infinity,
                                      height: 160,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                                Text(
                                  step.subDescription,
                                  style: TextStyle(
                                    fontSize: 15,
                                    height: 1.7,
                                    color: Colors.grey.shade800,
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}