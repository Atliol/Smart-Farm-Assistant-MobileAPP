import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../services/database_service.dart';
import '../../../models/fertilizer_model.dart';
import '../../../widgets/app_background.dart';
import 'fertilizer_detail_screen.dart';

class FertilizerListScreen extends StatelessWidget {
  final DatabaseService _dbService = DatabaseService();

  FertilizerListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("ဓာတ်မြေသြဇာ အသုံးချနည်းများ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: AppBackground(
        child: FutureBuilder<List<FertilizerModel>>(
          future: _dbService.getFertilizerData(),
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

            final fertilizers = snapshot.data!;

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: fertilizers.length,
              itemBuilder: (context, index) {
                final item = fertilizers[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FertilizerDetailScreen(data: item)),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(color: Colors.green.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 4))
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                          child: Image.asset(
                            item.image,
                            width: double.infinity, height: 160, fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              width: double.infinity, height: 160, color: Colors.green.shade50,
                              child: Icon(Icons.opacity_rounded, size: 50, color: Colors.green.shade400),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(20)),
                                child: Text(item.typeName, style: TextStyle(color: Colors.green.shade900, fontSize: 11, fontWeight: FontWeight.bold)),
                              ),
                              const SizedBox(height: 10),
                              Text(item.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                              const SizedBox(height: 6),
                              Text(item.description, style: TextStyle(fontSize: 13, color: Colors.grey.shade600, height: 1.4), maxLines: 2, overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(Icons.star_rounded, size: 16, color: Colors.green.shade700),
                                  const SizedBox(width: 6),
                                  Expanded(child: Text("အကျိုးအာနိသင် - ${item.benefits}", style: TextStyle(color: Colors.grey.shade700, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis)),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
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