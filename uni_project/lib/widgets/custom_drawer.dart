import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uni_project/widgets/app_background.dart';

import '../constants/app_colors.dart';
import '../drawer_screens/about_screen.dart';
import '../drawer_screens/contact_us_screen.dart';
import '../drawer_screens/privacy_policy_screen.dart';
import '../drawer_screens/user_guide_screen.dart';

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
            // Drawer Header
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

            // Drawer Items (💡 Screen များနှင့် ချိတ်ဆက်ပြီးပါပြီ)
            ListTile(
              leading: const Icon(Icons.help, color: AppColors.primaryColor),
              title: const Text('User Guide'),
              onTap: () {
                Navigator.pop(context); // Drawer ကို အရင်ပိတ်မည်
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UserGuideScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip, color: AppColors.primaryColor),
              title: const Text('Privacy Policy'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.contact_mail, color: AppColors.primaryColor),
              title: const Text('Contact Us'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ContactUsScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info, color: AppColors.primaryColor),
              title: const Text('About'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}