import 'package:flutter/material.dart';

void main() {
  runApp(const SewaTaniApp());
}

class SewaTaniApp extends StatelessWidget {
  const SewaTaniApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SewaTani',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF2E7D32),
      ),
      home: const Scaffold(
        body: Center(
          child: Text(
            'SewaTani awal',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}