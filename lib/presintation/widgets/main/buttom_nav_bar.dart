import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../style/app_text_styles.dart';
import '../../style/main_style.dart';

class ButtomNavBar extends StatelessWidget {
  const ButtomNavBar({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainStyle.backgrountColor,
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: MainStyle.backgrountColor,
          border: Border(
            top: BorderSide(
              color: Colors.white12,
              width: 1,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: navigationShell.currentIndex,

          onTap: (index) {
            navigationShell.goBranch(
              index,
              initialLocation:
              index == navigationShell.currentIndex,
            );
          },

          backgroundColor: MainStyle.backgrountColor,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: MainStyle.actionColor,
          unselectedItemColor: Colors.white38,

          selectedIconTheme: const IconThemeData(
            color: MainStyle.actionColor,
            size: 25,
          ),
          unselectedIconTheme: const IconThemeData(
            color: Colors.white38,
            size: 23,
          ),

          selectedLabelStyle:
          AppTextStyles.miniGreenText.copyWith(
            fontSize: 10,
            letterSpacing: 1,
          ),
          unselectedLabelStyle:
          AppTextStyles.label.copyWith(
            fontSize: 10,
            letterSpacing: 1,
            color: Colors.white38,
          ),

          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'HOME',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment_outlined),
              activeIcon: Icon(Icons.assignment),
              label: 'PLAN',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.auto_awesome_outlined),
              activeIcon: Icon(Icons.auto_awesome),
              label: 'AI',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined),
              activeIcon: Icon(Icons.calendar_month),
              label: 'SCHEDULE',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.emoji_events_outlined),
              activeIcon: Icon(Icons.emoji_events),
              label: 'AWARD',
            ),
          ],
        ),
      ),
    );
  }
}