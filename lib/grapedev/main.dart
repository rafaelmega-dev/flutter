import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'login_screen.dart';

void main() {
  runApp(const AquaFlowApp());
}

class AquaFlowApp extends StatelessWidget {
  const AquaFlowApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AquaFlow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AquaFlowColors.background,
      ),
      home: const LoginScreen(),
    );
  }
}