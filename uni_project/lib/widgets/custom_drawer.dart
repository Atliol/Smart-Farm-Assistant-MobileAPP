import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uni_project/widgets/app_background.dart';

import '../constants/app_colors.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.transparent,
      child: AppBackground(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            //Drawer Header
            const DrawerHeader(
              decoration: BoxDecoration(color: AppColors.primaryColor),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage(
                      'assets/app_logo.png',
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Shwe Lel Yar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            //Drawer Items
            ListTile(
              leading: const Icon(Icons.account_circle, color: AppColors.primaryColor),
              title: const Text('Profile'),
              onTap: () {
                //TODO: Navigate to Profile Screen
              },
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip, color: AppColors.primaryColor),
              title: const Text('Privacy Policy'),
              onTap: () {
                //TODO: Navigate to Privacy Policy Screen
              },
            ),
            ListTile(
              leading: const Icon(Icons.share, color: AppColors.primaryColor),
              title: const Text('Share'),
              onTap: () {
                //TODO: Share Logic
              },
            ),
            ListTile(
              leading: const Icon(Icons.star, color: AppColors.primaryColor),
              title: const Text('Rate Us'),
              onTap: () {
                //TODO: Rating Logic
              },
            ),
            ListTile(
              leading: const Icon(Icons.contact_mail, color: AppColors.primaryColor),
              title: const Text('Contact Us'),
              onTap: () {
                //TODO: Navigate to Contact Screen
              },
            ),
            ListTile(
              leading: const Icon(Icons.info, color: AppColors.primaryColor),
              title: const Text('About'),
              onTap: () {
                //TODO: Navigate to About Screen
              },
            ),
          ],
        ),
      )
    );
  }
}