import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uni_project/widgets/app_background.dart';

class PesticidesScreen extends StatelessWidget {
  const PesticidesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: Center(
          child: Text(
            'Pesticides Screen',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}