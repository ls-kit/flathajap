import 'package:flutter/material.dart';
import 'package:hajj_app/screens/home_page.dart';
import 'package:hajj_app/widgets/custom_loader/CustomLoaderScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'হজ্ব গাইড',
      theme: ThemeData(
        fontFamily: 'HindSiliguri',
        primaryColor: const Color(0xFF1B5E20),
        scaffoldBackgroundColor: const Color(0xFFFAF9F6),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1B5E20),
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF1B5E20),
            foregroundColor: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF1B5E20), size: 26),
        cardColor: Colors.white,
        dividerColor: Color(0xFFEEEEEE),
      ),
      home: const SplashLoader(),
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
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HajjHomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomLoaderScreen();
  }
}
