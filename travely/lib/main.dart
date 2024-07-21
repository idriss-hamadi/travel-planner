
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'home_page.dart';
import 'splash_screen.dart'; // Import the SplashScreen

import 'consts.dart';

void main() {
  Gemini.init(
    apiKey: Gemini_Api_key, // Make sure Gemini_Api_key is defined in consts.dart
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel Planner',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        useMaterial3: true,
      ),
      home: SplashScreen(), // Set SplashScreen as the initial screen
      debugShowCheckedModeBanner: false, // Add this line

    );
  }
}