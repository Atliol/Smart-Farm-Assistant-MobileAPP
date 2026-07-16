import 'package:flutter/material.dart';
import '../../services/database_service.dart';
import '../../models/aquaculture_model.dart';
import '../../widgets/app_background.dart';
import 'aquaculture_detail_screen.dart';

class AquacultureListScreen extends StatelessWidget {
  final DatabaseService _dbService = DatabaseService();

  AquacultureListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("ရေလုပ်ငန်းနည်းပညာများ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.teal.shade700, // ရေလုပ်ငန်းအလှသုံး သစ်လွင်သော Teal ရောင်
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: AppBackground(
        child: FutureBuilder<List<AquacultureModel>>(
          future: _dbService.getAquacultureData(),
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

            final items = snapshot.data!;

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final isFreshWater = item.waterType.contains("ရေချို");

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: isFreshWater ? Colors.cyan.shade100 : Colors.teal.shade100, width: 1.5),
                  ),
                  elevation: 1,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AquacultureDetailScreen(item: item),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          // 📷 Circular Image with Teal Border
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.teal.shade600, width: 2),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(35),
                              child: Image.asset(
                                item.image,
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  width: 70, height: 70, color: Colors.blue.shade50,
                                  child: const Icon(Icons.water, color: Colors.teal),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // 📝 Metadata Text
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 🏷️ Water Type Badge
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: isFreshWater ? Colors.cyan.shade50 : Colors.teal.shade50,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    item.waterType,
                                    style: TextStyle(
                                      color: isFreshWater ? Colors.cyan.shade800 : Colors.teal.shade800,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  item.title,
                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                // 🕒 Duration Icon/Text
                                Row(
                                  children: [
                                    Icon(Icons.calendar_month, size: 12, color: Colors.teal.shade400),
                                    const SizedBox(width: 4),
                                    Text(
                                      "မွေးမြူချိန်: ${item.duration}",
                                      style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}