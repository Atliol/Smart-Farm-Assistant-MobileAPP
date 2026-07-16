import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../services/database_service.dart';
import '../../models/livestock_model.dart'; // 💡 LivestockModel သို့ ပြောင်းလဲထားပါသည်
import '../../widgets/app_background.dart';
import 'livestock_detail_screen.dart'; // 💡 LivestockDetailScreen သို့ ပြောင်းလဲထားပါသည်

class LivestockListScreen extends StatelessWidget {
  // DatabaseService ကို instance အဆင့်မှာ သိမ်းထားခြင်းဖြင့် StatelessWidget Rebuild ဖြစ်စဉ် Loop ပတ်ခြင်းကို တားဆီးပါသည်
  final DatabaseService _dbService = DatabaseService();

  LivestockListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("မွေးမြူနည်းပညာများ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: AppBackground(
        child: FutureBuilder<List<LivestockModel>>(
          // 🔥 DatabaseService ထဲက မွေးမြူရေးဒေတာယူမည့် function အသစ်ကို လှမ်းခေါ်ခြင်း
          future: _dbService.getLivestockData(),
          builder: (context, snapshot) {
            // ၁။ ဒေတာ loading ဖြစ်နေစဉ်ပြသရန်
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            // ၂။ Error တစ်ခုခု တက်ခဲ့ရင် ပြသရန်
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }

            // ၃။ ဒေတာ တကယ်မရှိရင် ပြသရန်
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("ဒေတာ မရှိသေးပါဗျာ။"));
            }

            final livestockList = snapshot.data!;

            // မူရင်းလှပသော UI Design (ListView.builder နှင့် Card) ကို မွေးမြူရေးအတွက် ပြန်လည်အသုံးပြုခြင်း
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: livestockList.length,
              itemBuilder: (context, index) {
                final livestock = livestockList[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 2,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(20),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        livestock.image, // JSON ထဲမှ Offline ပုံလမ်းကြောင်း
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 60, height: 60, color: Colors.grey[350],
                          child: const Icon(Icons.image, color: Colors.white),
                        ),
                      ),
                    ),
                    title: Text(livestock.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text("ဝင်ရောက်ဖတ်ရှုရန် နှိပ်ပါ", style: TextStyle(color: Colors.green, fontSize: 12)),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // နှိပ်လိုက်လျှင် မွေးမြူရေး အသေးစိတ်ပြ Screen သို့ ဒေတာသယ်ဆောင်ပြီး သွားခြင်း
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LivestockDetailScreen(livestock: livestock),
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