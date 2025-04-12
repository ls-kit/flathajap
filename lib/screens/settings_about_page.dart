import 'package:flutter/material.dart';

class SettingsAboutPage extends StatelessWidget {
  const SettingsAboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: const Center(child: Text('এই পেজে হজ সংক্রান্ত তথ্য থাকবে')),
    );
  }
}
