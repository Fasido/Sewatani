import 'package:flutter/material.dart';

import '../config/app_theme.dart';
import '../screens/common/splash_screen.dart';

class SewaTaniApp extends StatelessWidget {
  const SewaTaniApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SewaTani',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
