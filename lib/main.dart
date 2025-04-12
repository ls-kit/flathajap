import 'package:flutter/material.dart';
import 'package:hajj_app/screens/home_page.dart'; // ✅ Fixed import path

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HajjHomeScreen(), // ✅ Class name from your screen
      debugShowCheckedModeBanner: false,
    );
  }
}
