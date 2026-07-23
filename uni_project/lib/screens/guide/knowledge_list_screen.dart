import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../models/knowledge_model.dart';
import '../../services/database_service.dart';
import '../../widgets/app_background.dart';
import 'knowledge_detail_screen.dart';

class KnowledgeListScreen extends StatefulWidget {
  // 💡 View All မှ လှမ်းပို့လိုက်သော Tag (ဥပမာ - "အပင်ရောဂါ") ကို လက်ခံရန်
  final String? initialTag;

  const KnowledgeListScreen({super.key, this.initialTag});

  @override
  State<KnowledgeListScreen> createState() => _KnowledgeListScreenState();
}

class _KnowledgeListScreenState extends State<KnowledgeListScreen> {
  final DatabaseService _dbService = DatabaseService();

  // Selected Tag state tracker
  late String _selectedTag;

  @override
  void initState() {
    super.initState();
    // 💡 လှမ်းပို့ထားသော initialTag ရှိပါက ထို Tag ကို Auto-select လုပ်မည်၊ မရှိပါက "အားလုံး" ဟု သတ်မှတ်မည်
    _selectedTag = widget.initialTag ?? "အားလုံး";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text(
          "အထွေထွေဗဟုသုတများ",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: AppBackground(
        child: FutureBuilder<List<KnowledgeModel>>(
          future: _dbService.getKnowledgeData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("ဒေတာ မရှိသေးပါဗျာ။"));
            }

            final allArticles = snapshot.data!;

            // 💡 1. JSON Data များထဲမှ ရှိသမျှ Tag များကို Dynamic ဆွဲထုတ်ခြင်း
            final Set<String> dynamicTags = {"အားလုံး"};
            for (var article in allArticles) {
              if (article.tag.trim().isNotEmpty) {
                dynamicTags.add(article.tag.trim());
              }
            }

            // 💡 မကိန်းဂဏန်း/မရှိသော Tag ကို လှမ်းပို့လိုက်မိပါကလည်း dynamicTags ထဲသို့ ထည့်ပေးခြင်း
            if (widget.initialTag != null && widget.initialTag!.trim().isNotEmpty) {
              dynamicTags.add(widget.initialTag!.trim());
            }

            final tagList = dynamicTags.toList();

            // 💡 2. Selected Tag ပေါ်မူတည်၍ Data List စစ်ထုတ်ခြင်း
            final filteredArticles = _selectedTag == "အားလုံး"
                ? allArticles
                : allArticles.where((article) => article.tag.trim() == _selectedTag).toList();

            return Column(
              children: [
                // 🏷️ Dynamic Filter Tag Buttons (AppBar အောက်ခြေ Filter Bar)
                Container(
                  height: 56,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: tagList.length,
                    itemBuilder: (context, index) {
                      final tag = tagList[index];
                      final isSelected = _selectedTag == tag;

                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(tag),
                          selected: isSelected,
                          selectedColor: AppColors.primaryColor,
                          backgroundColor: Colors.white.withOpacity(0.85),
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 13,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: isSelected ? AppColors.primaryColor : Colors.black12,
                            ),
                          ),
                          elevation: isSelected ? 2 : 0,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedTag = tag;
                              });
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),

                // 📝 Selected Tag အလိုက် ပြသပေးမည့် Article List
                Expanded(
                  child: filteredArticles.isEmpty
                      ? Center(
                    child: Text(
                      "\"$_selectedTag\" အတွက် အချက်အလက် မရှိသေးပါဗျာ။",
                      style: const TextStyle(color: Colors.black54, fontSize: 14),
                    ),
                  )
                      : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    itemCount: filteredArticles.length,
                    itemBuilder: (context, index) {
                      final article = filteredArticles[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => KnowledgeDetailScreen(article: article),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              )
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 📷 ပုံအကြီး
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                child: Image.asset(
                                  article.image,
                                  width: double.infinity,
                                  height: 180,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    width: double.infinity,
                                    height: 180,
                                    color: Colors.grey[200],
                                    child: const Icon(Icons.article, size: 50, color: Colors.grey),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // 🏷️ Category Tag Badge
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        article.tag.isNotEmpty ? article.tag : "ဗဟုသုတ",
                                        style: const TextStyle(
                                          color: AppColors.primaryColor,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    // 📝 Title
                                    Text(
                                      article.title,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        height: 1.4,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 12),
                                    const Divider(height: 1),
                                    const SizedBox(height: 10),

                                    // 🕒 Source & Read Time Row
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.menu_book_rounded, size: 14, color: Colors.grey.shade600),
                                            const SizedBox(width: 6),
                                            Text(
                                              article.source.isNotEmpty ? article.source : "အထွေထွေ",
                                              style: TextStyle(
                                                color: Colors.grey.shade600,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
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
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}