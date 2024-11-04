import 'package:belajar_api/login/login_page.dart';
import 'package:flutter/material.dart';
import 'kriteria_home_page.dart';
import 'ViewDataPerbandingan.dart';
import 'ResultPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Halaman Tombol',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeAdmin(),
    );
  }
}

class HomeAdmin extends StatelessWidget {
  double buttonSize = 80.0; // Ukuran tombol dapat diatur di sini

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton( 
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
            icon: Icon(Icons.logout)),
        title: Text('Halaman Admin'),
        // leading: const Icon(null),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.count(
            crossAxisCount: 2, // Menampilkan 2 tombol dalam satu baris
            crossAxisSpacing: 25.0, // Jarak horizontal antara tombol-tombol
            mainAxisSpacing: 25.0, // Jarak vertikal antara tombol-tombol
            children: [
              buildElevatedButton(
                context,
                Icons.data_saver_on, // Ikon input data
                'Input Data Kriteria',
                Colors.blue, // Warna latar belakang tombol menjadi biru
                buttonSize,
              ),
              buildElevatedButton(
                context,
                Icons.balance_sharp, // Ikon penilaian data kriteria
                'Penilaian Data Kriteria',
                Colors.green, // Warna latar belakang tombol menjadi hijau
                buttonSize,
              ),
              buildElevatedButton(
                context,
                Icons.data_object_sharp, // Ikon Result
                'Result',
                Colors.yellow, // Warna latar belakang tombol menjadi kuning
                buttonSize,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildElevatedButton(BuildContext context, IconData icon, String label,
      Color color, double size) {
    double iconSize = size * 0.6;
    double fontSize = size * 0.20;

    return ElevatedButton(
      onPressed: () {
        // Tambahkan fungsi untuk tombol sesuai keperluan masing-masing
        if (label == 'Input Data Kriteria') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => KriteriaHomePage(),
            ),
          );
        } else if (label == 'Penilaian Data Kriteria') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewDataPerbandingan(),
            ),
          );
        } else if (label == 'Result') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultPage(),
            ),
          );
        } else if (label == 'User Setting') {
          // Tambahkan fungsi untuk tombol User Setting
        } else if (label == 'Profile') {
          // Tambahkan fungsi untuk tombol Profile
        }
      },
      style: ElevatedButton.styleFrom(
        primary:
            color, // Warna latar belakang tombol sesuai dengan warna yang diberikan
        minimumSize: Size(
            size, size), // Ukuran tombol sesuai dengan ukuran yang diberikan
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              16.0), // Memberikan ujung rounded pada tombol
        ),
      ),
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.spaceEvenly, // Ruang di atas tombol
        children: [
          Icon(
            icon,
            size: iconSize, // Ukuran ikon tombol sesuai dengan ukuran tombol
          ),
          Text(
            label,
            style: TextStyle(
                fontSize:
                    fontSize), // Ukuran teks tombol sesuai dengan ukuran tombol
          ),
        ],
      ),
    );
  }
}
