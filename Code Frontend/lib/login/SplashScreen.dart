import 'dart:async';
import 'package:flutter/material.dart';

import '../HomePage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _loadSplashScreen();
  }

  _loadSplashScreen() async {
    // Delay untuk menampilkan splash screen selama 2 detik
    Timer(Duration(seconds: 2), () {
      // Pindah ke halaman berikutnya (misalnya halaman utama aplikasi)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white, // Warna abu-abu untuk latar belakang
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("lib/assets/logo2.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                width: 300, // Lebar gambar mengisi seluruh lebar layar
                height: 300, // Tinggi gambar mengisi seluruh tinggi layar
              ),
              Positioned(
                bottom: 16,
                child: Text(
                  'MITA TEMPAT',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
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
