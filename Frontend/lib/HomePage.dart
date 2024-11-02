import 'package:flutter/material.dart';
import 'login/login_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mita Tempat'),
        automaticallyImplyLeading: false, // Hilangkan tombol kembali
      ),
      body: Container(
        color: Colors.white, // Warna latar belakang abu-abu
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'lib/assets/logo2.png', // Ubah sesuai path gambar Anda
                width: 500,
                height: 300,
              ),
              SizedBox(height: 16),
              Text(
                'Selamat datang di Mita Tempat! Aplikasi cerdas untuk mendukung keputusan pemilihan lokasi BSI SMART AGEN di Lhokseumawe. Sukseskan bisnis Anda dengan MitaTempat sekarang!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic, // Gaya teks menjadi italic
                  fontFamily: 'Helvetica',
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Navigasi ke halaman UserPage saat tombol "User" ditekan
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Text('LOGIN'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}
