import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../models/land_area_model.dart';
import '../../services/land_api_service.dart';
import 'measure_map_screen.dart';
import 'package:uni_project/screens/home/home_screen.dart';
import 'view_saved_map_screen.dart';

class SavedLandScreen extends StatefulWidget {
  const SavedLandScreen({super.key});

  @override
  State<SavedLandScreen> createState() => _SavedLandScreenState();
}

class _SavedLandScreenState extends State<SavedLandScreen> {
  late Future<List<LandAreaModel>> _landsFuture;

  @override
  void initState() {
    super.initState();
    _loadLandData();
  }


  void _loadLandData() {
    if (!mounted) return;
    setState(() {
      _landsFuture = LandApiService().getSavedLands();
    });
  }

  Future<void> _editLandTitle(String id, String currentTitle) async {
    final TextEditingController nameController = TextEditingController(text: currentTitle);

    bool? confirmUpdate = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("မြေကွက်အမည်ပြင်ဆင်ရန်"),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            hintText: "မြေကွက်အမည်အသစ် ထည့်သွင်းပါ",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("မပြောင်းတော့ပါ", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("ပြင်ဆင်မည်", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirmUpdate == true && nameController.text.trim().isNotEmpty) {
      try {
        bool isSuccess = await LandApiService().updateLandTitle(id, nameController.text.trim());
        if (!mounted) return;
        if (isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("မြေကွက်အမည်ကို '${nameController.text.trim()}' သို့ ပြင်ဆင်ပြီးပါပြီ။")),
          );
          _loadLandData();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("ဆာဗာမှ ပြင်ဆင်ရန် မအောင်မြင်ပါ။")));
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("အမှားအယွင်းရှိပါသည်: $e")));
      }
    }
  }

  Future<void> _deleteLand(String id, String title) async {
    bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("မြေကွက်ဖျက်သိမ်းရန်"),
        content: Text("'$title' ကို စာရင်းထဲမှ လုံးဝဖျက်သိမ်းရန် သေချာပါသလားဗျာ။"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("မဖျက်တော့ပါ", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("ဖျက်မည်", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmDelete == true) {
      try {
        bool isSuccess = await LandApiService().deleteLandArea(id);
        if (!mounted) return;
        if (isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("'$title' ကို ဖျက်သိမ်းပြီးပါပြီ။")));
          _loadLandData();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("ဆာဗာမှ ဖျက်သိမ်းရန် မအောင်မြင်ပါ။")));
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("အမှားအယွင်းရှိပါသည်: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Saved Land", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MeasureMapScreen()),
              );
              _loadLandData();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.primaryColor,
        onRefresh: () async => _loadLandData(),
        child: FutureBuilder<List<LandAreaModel>>(
          future: _landsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  Center(child: Text("ဒေတာများရယူရန် မအောင်မြင်ပါဗျာ။", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade600))),
                ],
              );
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                  Icon(Icons.landscape, size: 80, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  const Center(child: Text("သိမ်းဆည်းထားသော မြေကွက်များ မရှိသေးပါဗျာ။", style: TextStyle(color: Colors.grey))),
                ],
              );
            }

            final savedLands = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: savedLands.length,
              itemBuilder: (context, index) {
                final land = savedLands[index];
                final String formattedDate = "${land.createdAt.day}/${land.createdAt.month}/${land.createdAt.year}";
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200)),
                  elevation: 0,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ViewSavedMapScreen(land: land)));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Container(
                            width: 80, height: 80,
                            decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.green.shade100)),
                            child: Icon(Icons.map_outlined, color: Colors.green.shade700, size: 35),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(land.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                const SizedBox(height: 4),
                                Text("${land.areaAcres.toStringAsFixed(2)} Acres", style: TextStyle(color: Colors.green.shade800, fontWeight: FontWeight.bold, fontSize: 14)),
                                Text("${land.areaSqMeters.toStringAsFixed(2)} m²", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_today, size: 10, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Text(formattedDate, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          IconButton(icon: const Icon(Icons.more_vert, color: Colors.grey), onPressed: () => _showBottomSheetOptions(context, land)),
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

  void _showBottomSheetOptions(BuildContext context, LandAreaModel land) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(leading: const Icon(Icons.edit, color: Colors.blue), title: const Text("အမည်ပြင်ဆင်မည်"), onTap: () { Navigator.pop(context); _editLandTitle(land.id, land.title); }),
              ListTile(leading: const Icon(Icons.delete, color: Colors.red), title: const Text("ဖျက်သိမ်းမည်"), onTap: () { Navigator.pop(context); _deleteLand(land.id, land.title); }),
            ],
          ),
        );
      },
    );
  }
}