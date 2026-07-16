import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../services/database_service.dart';
import '../../models/crop_model.dart';
import '../../widgets/app_background.dart';
import 'crop_detail_screen.dart';

class CropListScreen extends StatelessWidget {
  // 💡 DatabaseService ကို တစ်ကြိမ်တည်း ဆောက်ပြီး future ကို instance အဆင့်မှာ သိမ်းထားခြင်းဖြင့်
  // StatelessWidget ဖြစ်နေသော်လည်း UI Rebuild ဖြစ်တိုင်း Data ကို ထပ်ခါတလဲလဲ မတောင်းတော့ဘဲ Loop ပတ်ခြင်းမှ ကာကွယ်ပေးပါတယ်။
  final DatabaseService _dbService = DatabaseService();

  CropListScreen({super.key});

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
          // 🔥 DatabaseService ထဲက variable ကတစ်ဆင့် ခေါ်ယူသိမ်းဆည်းထားသော future ကို သုံးစွဲခြင်း
          future: _dbService.getCropsData(),
          builder: (context, snapshot) {
            // ၁။ ဒေတာ loading ဖြစ်နေစဉ်ပြသရန်
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            // ၂။ အကယ်၍ Error တစ်ခုခု တက်ခဲ့ရင် Debug Console မှာတင်မကဘဲ UI မှာပါ မြင်ရအောင် စစ်ပေးခြင်း
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }

            // ၃။ ဒေတာ တကယ်မရှိရင် ပြသရန်
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("ဒေတာ မရှိသေးပါဗျာ။"));
            }

            final crops = snapshot.data!;

            // 💡 မူရင်း UI Design (ListView.builder နှင့် Card) ကို လုံးဝ (လုံးဝ) မပြောင်းလဲဘဲ ပြန်လည်အသုံးပြုထားပါသည်
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
                        crop.image,
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