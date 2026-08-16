import 'package:flutter/material.dart';
import '../../models/crop_price_model.dart';
import '../../services/price_service.dart';
import 'widgets/filter_dialog.dart';

class DailyPriceScreen extends StatefulWidget {
  const DailyPriceScreen({super.key});

  @override
  State<DailyPriceScreen> createState() => _DailyPriceScreenState();
}

class _DailyPriceScreenState extends State<DailyPriceScreen> {
  final PriceService _priceService = PriceService();

  String _selectedCity = 'ရန်ကုန်';
  String _selectedCropCategory = 'အားလုံး';
  late Future<List<CropPriceModel>> _priceFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  
  Future<void> _loadData() async {
    setState(() {
      _priceFuture = _priceService.fetchDailyPrices(
        city: _selectedCity,
        selectedCrop: _selectedCropCategory,
      );
    });
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    final months = [
      'ဇန်နဝါရီ',
      'ဖေဖော်ဝါရီ',
      'မတ်',
      'ဧပြီ',
      'မေ',
      'ဇွန်',
      'ဇူလိုင်',
      'သြဂုတ်',
      'စက်တင်ဘာ',
      'အောက်တိုဘာ',
      'နိုဝင်ဘာ',
      'ဒီဇင်ဘာ'
    ];
    return "${months[now.month - 1]} ${now.day}";
  }

  void _openFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => FilterDialog(
        currentSelected: _selectedCropCategory,
        onSelect: (selected) {
          setState(() {
            _selectedCropCategory = selected;
          });
          _loadData();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF00897B),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "နေ့စဉ် သီးနှံစျေးနှုန်းများ",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded, color: Colors.white),
            onPressed: _openFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          
          Container(
            color: const Color(0xFF00897B),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                
                Expanded(
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.calendar_today_outlined,
                            color: Colors.white, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          _getFormattedDate(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                
                Expanded(
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedCity,
                        isExpanded: true,
                        dropdownColor: const Color(0xFF00897B),
                        icon: const Icon(Icons.arrow_drop_down,
                            color: Colors.white),
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedCity = newValue;
                            });
                            _loadData();
                          }
                        },
                        items: PriceService.cities
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            alignment: Alignment.center,
                            child: Text(value,
                                style: const TextStyle(color: Colors.white)),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          
          Container(
            color: const Color(0xFF4CAF50),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: const Row(
              children: [
                Expanded(
                    flex: 4,
                    child: Text("အမျိုးအစား",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold))),
                Expanded(
                    flex: 2,
                    child: Text("ယူနစ်",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold))),
                Expanded(
                    flex: 3,
                    child: Text("စျေးနှုန်း",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold))),
              ],
            ),
          ),

          
          Expanded(
            child: RefreshIndicator(
              color: const Color(0xFF00897B),
              onRefresh: _loadData,
              child: FutureBuilder<List<CropPriceModel>>(
                future: _priceFuture,
                builder: (context, snapshot) {
                  
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF00897B),
                      ),
                    );
                  }

                  
                  if (snapshot.hasError) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.2),
                        const Icon(
                          Icons.wifi_off_rounded,
                          size: 70,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        const Center(
                          child: Text(
                            "အင်တာနက် ချိတ်ဆက်မှု မရှိပါ သို့မဟုတ်\nဒေတာ ရယူရာတွင် အမှားတစ်ခု ရှိနေပါသည်။",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                              height: 1.4,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: _loadData,
                            icon: const Icon(Icons.refresh, color: Colors.white),
                            label: const Text(
                              "ပြန်လည်ကြိုးစားမည်",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00897B),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }

                  final prices = snapshot.data ?? [];

                  
                  if (prices.isEmpty) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.25),
                        const Icon(
                          Icons.find_in_page_outlined,
                          size: 65,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 12),
                        const Center(
                          child: Text(
                            "စျေးနှုန်းများ မရှိသေးပါ",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    );
                  }

                  
                  Map<String, List<CropPriceModel>> groupedPrices = {};
                  for (var price in prices) {
                    if (!groupedPrices.containsKey(price.category)) {
                      groupedPrices[price.category] = [];
                    }
                    groupedPrices[price.category]!.add(price);
                  }

                  return ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: groupedPrices.keys.length,
                    itemBuilder: (context, index) {
                      String category = groupedPrices.keys.elementAt(index);
                      List<CropPriceModel> categoryItems =
                      groupedPrices[category]!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            color: const Color(0xFFECEFF1),
                            child: Text(
                              "$category အမျိုးအစားများ",
                              style: const TextStyle(
                                color: Color(0xFF00897B),
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          ...categoryItems.map((item) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                    color: Colors.grey.shade200),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Text(
                                    item.cropName,
                                    style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.black87),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    item.unit,
                                    style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.black54),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    item.price,
                                    textAlign: TextAlign.end,
                                    style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.black87),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          )),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}