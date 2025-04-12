import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'CustomLoaderPainter.dart';
import '../../screens/home_page.dart';
import '../../models/hajj_page.dart';
import '../../services/api_service.dart';

class CustomLoaderScreen extends StatefulWidget {
  const CustomLoaderScreen({super.key});

  @override
  State<CustomLoaderScreen> createState() => _CustomLoaderScreenState();
}

class _CustomLoaderScreenState extends State<CustomLoaderScreen>
    with SingleTickerProviderStateMixin {
  double percentValue = 0.0;
  AnimationController? _controller;
  double? _height;
  double? _width;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..addListener(() {
      setState(() {
        percentValue = lerpDouble(0, 100, _controller!.value)!;
      });
    });

    _controller!.forward();

    // Fetch API data during loader animation
    Future.wait([
      ApiService().fetchHajjPages(),
      Future.delayed(const Duration(seconds: 3)),
    ]).then((results) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HajjHomeScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          height: _height! / 2,
          width: _width! / 2,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                foregroundPainter: CustomLoaderPainter(
                  buttonBorderColor: Colors.grey[300],
                  progressColor: Colors.green,
                  percentage: percentValue,
                  width: 8.0,
                ),
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        '/icons/icon.png',
                        height: 160,
                        width: 160,
                        fit: BoxFit.cover,
                      ),
                      16.height,
                      Text(
                        '${percentValue.toInt()}%',
                        style: boldTextStyle(size: 24, color: Colors.green),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
