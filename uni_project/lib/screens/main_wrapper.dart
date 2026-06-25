import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uni_project/screens/pesticides/pesticides_screen.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../widgets/custom_drawer.dart';
import 'ai/ai_screen.dart';
import 'guide/guide_screen.dart';
import 'home/home_screen.dart';
import 'news/news_screen.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 0;

  //Bottom Navigation Screen Lists
  Widget _getScreen(int index) {
    switch (index) {
      case 0:
        return HomeScreen(onTabChanged: (newIndex) {
          setState(() {
            _currentIndex = newIndex;
          });
        });
      case 1:
        return const GuideScreen();
      case 2:
        return const AiScreen();
      case 3:
        return const PesticidesScreen();
      case 4:
        return const NewsScreen();
      default:
        return HomeScreen(
          onTabChanged: (newIndex) {
            setState(() {
              _currentIndex = newIndex;
            });
          },
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    // 💡 ၁။ စာရိုက်ရန် ကီးဘုတ် ပွင့်နေသလားဆိုတာကို လှမ်းစစ်ဆေးခြင်း
    final bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      //AppBar
        appBar: AppBar(
          title: const Text(
            AppStrings.appName,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: AppColors.primaryColor,
          iconTheme: const IconThemeData(color: Colors.white),
        ),

        //SideBar/ Drawer
        drawer: const CustomDrawer(),

        //Screen Changes according to index
        body: _getScreen(_currentIndex),

        //(AI) => FloatingActionButton
        // 💡 ၂။ ကီးဘုတ် ပွင့်နေပါက AI Button အဝိုင်းကြီးကို null (ဖျောက်ထားခြင်း) ပေးလိုက်ပါသည်
      // (AI) => FloatingActionButton
// 💡 ပြင်ဆင်လိုက်သည့်အပိုင်း: ကီးဘုတ်ပွင့်နေချိန် သို့မဟုတ် AI Screen (index 2) သို့ ရောက်ရှိနေချိန်တွင် AI Button ကြီးကို လုံးဝ ဖျောက်ထားပါမည်
      floatingActionButton: isKeyboardOpen || _currentIndex == 2
          ? null
          : AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: _currentIndex == 2 ? 80 : 70,
        height: _currentIndex == 2 ? 80 : 70,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primaryColor,
          border: Border.all(
            color: Colors.white,
            width: 5,
          ),
          boxShadow: _currentIndex == 2
              ? [
            BoxShadow(
              color: AppColors.primaryColor.withOpacity(0.4),
              blurRadius: 15,
              spreadRadius: 3,
            ),
          ]
              : [],
        ),
        child: IconButton(
          onPressed: () {
            setState(() {
              _currentIndex = 2; //AI Screen
            });
          },
          icon: const Icon(
            Icons.psychology,
            color: Colors.white,
            size: 32,
          ),
        ),
      ),

        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

        //BottomNavigation Bar
        // 💡 ၃။ ကီးဘုတ် ပွင့်နေပါက အောက်ခြေ Navigation Bar တစ်ခုလုံးကိုပါ ယာယီ ဖျောက်ထားလိုက်ပါသည်
        bottomNavigationBar: isKeyboardOpen
            ? null
            : BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 8,
            child: SizedBox(
              height: 65,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                  //Home
                  _buildNavItem(Icons.home, 'Home', 0),

              //Guide
              _buildNavItem(Icons.menu_book, 'Guide', 1),
                    //AI Button Space
                    const SizedBox(width: 40),

                    //Pesticides
                    _buildNavItem(Icons.science, 'Pesticides', 3),

                    //News
                    _buildNavItem(Icons.newspaper, 'News', 4),
                  ],
              ),
            ),
        ),
    );
  }

  Widget _buildNavItem(
      IconData icon,
      String label,
      int index,
      ) {
    final bool isSelected = _currentIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? AppColors.primaryColor : Colors.grey,
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? AppColors.primaryColor : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}