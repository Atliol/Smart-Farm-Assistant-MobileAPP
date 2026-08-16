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
        title: const Text(
          "ဆောင်းပါးဖတ်ရှုရန်",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: AppBackground(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              Image.asset(
                article.image,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: double.infinity, height: 250, color: Colors.grey[300],
                  child: const Icon(Icons.book, size: 50, color: Colors.grey),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
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
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.access_time_rounded, size: 14, color: Colors.grey.shade600),
                            const SizedBox(width: 6),
                            Text(
                              article.readTime.isNotEmpty ? article.readTime : "၅ မိနစ်စာဖတ်ရန်",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    
                    Text(
                      article.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A237E),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),

                    
                    Text(
                      article.description,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.8,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 24),

                    
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
                                const SizedBox(height: 12),

                                
                                if (step.subImage.isNotEmpty) ...[
                                  Container(
                                    width: double.infinity,
                                    height: 200,
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade50,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: AppColors.primaryColor.withOpacity(0.15),
                                        width: 1,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.02),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.asset(
                                        step.subImage,
                                        width: double.infinity,
                                        height: double.infinity,
                                        fit: BoxFit.contain, 
                                        errorBuilder: (context, error, stackTrace) => Container(
                                          color: Colors.grey.shade100,
                                          child: Icon(
                                            Icons.image_not_supported_rounded,
                                            color: Colors.grey.shade400,
                                            size: 40,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
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