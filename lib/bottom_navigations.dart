import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:personal_task/core/utils/localization/l10n/app_localizations.dart';
import 'package:personal_task/features/home/view/home_view.dart';
import 'package:personal_task/features/profile/views/profile_view.dart';

import 'features/more/view/more_view.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});


  @override
  State<StatefulWidget> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
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
        _buildNavItem(Icons.more_horiz, AppLocalizations.of(context)!.more, 0),
        _buildNavItem(Icons.home, AppLocalizations.of(context)!.home, 1),
        _buildNavItem(Icons.person, AppLocalizations.of(context)!.profile, 2),
      ],
      color: Theme.of(context).colorScheme.primaryContainer,
      buttonBackgroundColor: Theme.of(context).primaryColor,
      backgroundColor: Colors.transparent,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 500),
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
          color: _currentIndex == index ? Colors.white : Theme.of(context).colorScheme.surface,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: _currentIndex == index ? Colors.white : Theme.of(context).colorScheme.surface,
          ),
        ),
      ],
    );
  }
}
