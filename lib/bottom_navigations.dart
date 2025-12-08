import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:personal_task/core/constants/app_colors.dart';
import 'package:personal_task/features/home/view/home_view.dart';
import 'package:personal_task/features/profile/views/profile_view.dart';

import 'features/more/view/more_view.dart';

class BottomNavigations extends StatefulWidget {
  const BottomNavigations({super.key});

  @override
  _BottomNavigationsState createState() => _BottomNavigationsState();
}

class _BottomNavigationsState extends State<BottomNavigations> {
  int _currentIndex = 1;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  final List<Widget> _pages = [MoreView(), HomeView(), ProfileView()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: _buildEnhancedCurvedNavBar(),
    );
  }

  Widget _buildEnhancedCurvedNavBar() {
    return CurvedNavigationBar(
      key: _bottomNavigationKey,
      index: _currentIndex,
      height: 65.0,
      items: <Widget>[
        _buildNavItem(Icons.more_horiz, 'More', 0),
        _buildNavItem(Icons.home, 'Home', 1),
        _buildNavItem(Icons.person, 'Profile', 2),
      ],
      color: Colors.white,
      buttonBackgroundColor: AppColors.primary,
      backgroundColor: Colors.transparent,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 700),
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 24,
          color: _currentIndex == index ? Colors.white : Colors.grey[700],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: _currentIndex == index ? Colors.white : Colors.grey[700],
          ),
        ),
      ],
    );
  }
}