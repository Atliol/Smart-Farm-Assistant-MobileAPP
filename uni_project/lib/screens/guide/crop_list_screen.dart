import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../services/database_service.dart';
import '../../models/crop_model.dart';
import '../../widgets/app_background.dart';
import 'crop_detail_screen.dart';

class CropListScreen extends StatelessWidget {
  const CropListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("သီးနှံစိုက်ပျိုးနည်းများ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: AppBackground(
        child: FutureBuilder<List<CropModel>>(
          future: DatabaseService().getCropsData(), // Hive/JSON မှ ဒေတာလှမ်းတောင်းခြင်း
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("ဒေတာ မရှိသေးပါဗျာ။"));
            }

            final crops = snapshot.data!;

            // 💡 JSON/Hive ထဲက သီးနှံအရေအတွက် အတိုင်း Dynamic UI ပြသခြင်း
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: crops.length,
              itemBuilder: (context, index) {
                final crop = crops[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 2,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(20),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        crop.image, // Local Asset လမ်းကြောင်းဖတ်ခြင်း
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 60, height: 60, color: Colors.grey[350],
                          child: const Icon(Icons.image, color: Colors.white),
                        ),
                      ),
                    ),
                    title: Text(crop.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text("ဝင်ရောက်ဖတ်ရှုရန် နှိပ်ပါ", style: TextStyle(color: Colors.green, fontSize: 12)),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // 💡 နှိပ်လိုက်သော သီးနှံ၏ သီးသန့် အချက်အလက် UI သို့ သွားမည်
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CropDetailScreen(crop: crop),
                        ),
                      );
                    },
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