import 'package:flutter/material.dart';
import 'splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Random User Info',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Arial', primarySwatch: Colors.purple),
      home: const SplashScreen(),
    );
  }
}
