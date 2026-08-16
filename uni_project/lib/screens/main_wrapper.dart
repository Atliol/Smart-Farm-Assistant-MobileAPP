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
  final int initialIndex;

  const MainWrapper({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  
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
        return NewsScreen();
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
    
    final bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      
      appBar: AppBar(
        title: const Text(
          AppStrings.appName,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: AppColors.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      
      drawer: const CustomDrawer(),

      
      body: _getScreen(_currentIndex),

      
      
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
                    _currentIndex = 2; 
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
                    
                    _buildNavItem(Icons.home, 'ပင်မ', 0),

                    
                    _buildNavItem(Icons.menu_book, 'လမ်းညွှန်', 1),

                    
                    const SizedBox(width: 40),

                    
                    _buildNavItem(Icons.sanitizer_rounded, 'ဆေးဝါး', 3),

                    
                    _buildNavItem(Icons.newspaper, 'သတင်းများ', 4),
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