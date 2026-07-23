import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../services/database_service.dart';
import '../../../models/fungicide_model.dart';
import '../../../widgets/app_background.dart';
import 'fungicide_detail_screen.dart';

class FungicideListScreen extends StatelessWidget {
  final DatabaseService _dbService = DatabaseService();

  FungicideListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("မှိုရောဂါကာကွယ်၊ကုသဆေးများ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: AppBackground(
        child: FutureBuilder<List<FungicideModel>>(
          future: _dbService.getFungicideData(),
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

            final fungicides = snapshot.data!;

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: fungicides.length,
              itemBuilder: (context, index) {
                final item = fungicides[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FungicideDetailScreen(data: item)),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.teal.shade50, width: 1.5),
                      boxShadow: [
                        BoxShadow(color: Colors.teal.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 4))
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
                              width: double.infinity, height: 160, color: Colors.teal.shade50,
                              child: Icon(Icons.healing_rounded, size: 50, color: Colors.teal.shade400),
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
                                decoration: BoxDecoration(color: Colors.teal.shade50, borderRadius: BorderRadius.circular(20)),
                                child: Text(item.chemicalName, style: TextStyle(color: Colors.teal.shade900, fontSize: 11, fontWeight: FontWeight.bold)),
                              ),
                              const SizedBox(height: 10),
                              Text(item.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                              const SizedBox(height: 6),
                              Text(item.description, style: TextStyle(fontSize: 13, color: Colors.grey.shade600, height: 1.4), maxLines: 2, overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 12),
                              const Divider(height: 1),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Icon(Icons.coronavirus_rounded, size: 16, color: Colors.teal.shade600),
                                  const SizedBox(width: 6),
                                  Expanded(child: Text("ကာကွယ်နိုင်သောရောဂါ - ${item.targetDisease}", style: TextStyle(color: Colors.teal.shade900, fontSize: 12, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis)),
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