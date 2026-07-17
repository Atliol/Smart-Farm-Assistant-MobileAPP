import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../models/land_area_model.dart';
import 'measure_map_screen.dart';

class SavedLandScreen extends StatefulWidget {
  const SavedLandScreen({super.key});

  @override
  State<SavedLandScreen> createState() => _SavedLandScreenState();
}

class _SavedLandScreenState extends State<SavedLandScreen> {
  // 💡 စမ်းသပ်ရန် Mock Data များ ထည့်သွင်းပေးထားပါသည် (Backend မှလာလျှင် Future/Stream သုံးရပါမည်)
  final List<LandAreaModel> _savedLands = [
    LandAreaModel(
      id: "1",
      title: "My Farm - North",
      areaAcres: 2.48,
      areaSqMeters: 10032.45,
      areaHectares: 1.003,
      perimeterMeters: 415.68,
      points: [],
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    LandAreaModel(
      id: "2",
      title: "Rice Field",
      areaAcres: 1.25,
      areaSqMeters: 5059.20,
      areaHectares: 0.505,
      perimeterMeters: 310.20,
      points: [],
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Saved Land", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // 💡 ညာဘက်အပေါ်က '+' နှိပ်လျှင် မြေပုံတိုင်းရန် သွားမည်
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MeasureMapScreen()),
              );
            },
          ),
        ],
      ),
      body: _savedLands.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.landscape, size: 80, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            const Text("သိမ်းဆည်းထားသော မြေကွက်များ မရှိသေးပါဗျာ။", style: TextStyle(color: Colors.grey)),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _savedLands.length,
        itemBuilder: (context, index) {
          final land = _savedLands[index];

          // ရက်စွဲ Format ပြင်ဆင်ခြင်း
          final String formattedDate = "${land.createdAt.day}/${land.createdAt.month}/${land.createdAt.year}";

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  // 🟢 Left side - Visual Preview (Green Box)
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.shade100),
                    ),
                    child: Icon(Icons.map_outlined, color: Colors.green.shade700, size: 35),
                  ),
                  const SizedBox(width: 16),

                  // 📝 Center - Information
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          land.title,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${land.areaAcres.toStringAsFixed(2)} Acres",
                          style: TextStyle(
                            color: Colors.green.shade800,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          "${land.areaSqMeters.toStringAsFixed(2)} m²",
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 10, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              formattedDate,
                              style: const TextStyle(color: Colors.grey, fontSize: 11),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // ⚙️ Right side - Options Button
                  IconButton(
                    icon: const Icon(Icons.more_vert, color: Colors.grey),
                    onPressed: () {
                      // 💡 Edit သို့မဟုတ် Delete ပြုလုပ်ရန် Option ပေးနိုင်ပါသည်
                      _showBottomSheetOptions(context, land);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // 💡 မြေကွက်ပြင်ဆင်/ဖျက်သိမ်းရန် Bottom Sheet
  void _showBottomSheetOptions(BuildContext context, LandAreaModel land) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.blue),
                title: const Text("အမည်ပြင်ဆင်မည်"),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: ပြင်ဆင်ရန် Dialog box ပြသခြင်း logic ရေးနိုင်ပါသည်
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text("ဖျက်သိမ်းမည်"),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: API (DELETE) သို့မဟုတ် Local database မှ ဖျက်သည့် logic ရေးနိုင်ပါသည်
                },
              ),
            ],
          ),
        );
      },
    );
  }
}