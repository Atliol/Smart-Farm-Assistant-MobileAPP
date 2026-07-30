import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';

class SuggestionChip extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const SuggestionChip({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(25),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primaryColor.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(25),
            color: Colors.white.withOpacity(0.6),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 💡 စာသားကို Expanded နဲ့ အုပ်ပေးလိုက်ရင် Overflow မဖြစ်တော့ပါဘူး
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2, // 💡 လိုအပ်ပါက ၂ ကြောင်းထိ ဆင်းခွင့်ပြုမည်
                  overflow: TextOverflow.ellipsis, // ရှည်လွန်းရင် ... ပြမည်
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: AppColors.primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}