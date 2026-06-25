import 'package:flutter/material.dart';

class SuggestionChip extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const SuggestionChip({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.teal.shade200),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text, style: const TextStyle(fontSize: 15, color: Colors.teal, fontWeight: FontWeight.w500)),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.teal),
          ],
        ),
      ),
    );
  }
}