import 'package:flutter/material.dart';
import '../../../services/price_service.dart';

class FilterDialog extends StatefulWidget {
  final String currentSelected;
  final Function(String) onSelect;

  const FilterDialog({
    super.key,
    required this.currentSelected,
    required this.onSelect,
  });

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  late String _tempSelected;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tempSelected = widget.currentSelected;
  }

  @override
  Widget build(BuildContext context) {
    final categories = PriceService.cropCategories.where((item) {
      return item.contains(_searchQuery);
    }).toList();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header Search Box (ပုံ ၂ စတိုင်)
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) => setState(() => _searchQuery = value),
                    decoration: InputDecoration(
                      hintText: "ရွေးထုတ်ရန်",
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                        icon: const Icon(Icons.cancel, color: Colors.grey),
                        onPressed: () => setState(() => _searchQuery = ''),
                      )
                          : null,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Radio Options List
            Expanded(
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final item = categories[index];
                  final isSelected = _tempSelected == item;

                  return ListTile(
                    title: Text(item, style: const TextStyle(fontSize: 15)),
                    trailing: Radio<String>(
                      value: item,
                      groupValue: _tempSelected,
                      activeColor: Colors.amber.shade700,
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _tempSelected = val);
                          widget.onSelect(val);
                          Navigator.pop(context);
                        }
                      },
                    ),
                    onTap: () {
                      setState(() => _tempSelected = item);
                      widget.onSelect(item);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}