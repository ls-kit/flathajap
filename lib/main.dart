import 'package:flutter/material.dart';
import 'package:hajj_app/screens/home_page.dart';
import 'package:hajj_app/widgets/custom_loader/CustomLoaderScreen.dart'; // ✅ Import your custom loader

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'HindSiliguri'),
      home: const SplashLoader(), // 👈 Start with splash loader
    );
  }
}

class SplashLoader extends StatefulWidget {
  const SplashLoader({super.key});

  @override
  State<SplashLoader> createState() => _SplashLoaderState();
}

class _SplashLoaderState extends State<SplashLoader> {
  @override
  void initState() {
    super.initState();

    // Wait 3 seconds then navigate to home
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HajjHomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomLoaderScreen(); // 🎯 Your animated loader
  }
}
