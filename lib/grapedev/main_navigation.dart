import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'home_screen.dart';
import 'analytics_screen.dart';
import 'devices_screen.dart';
import 'alert_screen.dart';
import 'settings_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({Key? key}) : super(key: key);

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    AnalyticsScreen(),
    DevicesScreen(),
    AlertScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AquaFlowColors.background,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AquaFlowColors.cardBg,
          border: Border(
            top: BorderSide(color: AquaFlowColors.cardBorder, width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: Colors.transparent,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AquaFlowColors.cyanNeon,
          unselectedItemColor: AquaFlowColors.textMuted,
          selectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: 'Início',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_outlined),
              activeIcon: Icon(Icons.bar_chart_rounded),
              label: 'Análises',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.sensors_outlined),
              activeIcon: Icon(Icons.sensors_rounded),
              label: 'Dispositivos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.warning_amber_rounded),
              activeIcon: Icon(Icons.warning_rounded),
              label: 'Alertas',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings_rounded),
              label: 'Ajustes',
            ),
          ],
        ),
      ),
    );
  }
}