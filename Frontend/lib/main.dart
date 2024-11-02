import 'package:flutter/material.dart';
import 'login/SplashScreen.dart';
// Kode lainnya tidak berubah

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi Kriteria',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(), // Ganti home menjadi KriteriaHomePage
    );
  }
}