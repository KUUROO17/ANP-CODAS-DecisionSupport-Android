import 'package:flutter/material.dart';
import 'AlternatifHomePage.dart';
import 'data_kriteria.dart';
// import 'PerbandinganAlternatifPage.dart';
import 'viewperbandinganalternatif.dart';

class HomeDataAlternatif extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => KriteriaHomePage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors
                    .blue, // Ubah warna latar belakang tombol 1 menjadi biru
                padding: EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 8.0), // Ubah ukuran tombol
              ),
              child: Text(
                'Melihat info Data Kriteria',
                style: TextStyle(fontSize: 16.0), // Ubah ukuran teks tombol
              ),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AlternatifHomePage( ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors
                    .green, // Ubah warna latar belakang tombol 2 menjadi hijau
                padding: EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 8.0), // Ubah ukuran tombol
              ),
              child: Text(
                'Tambah Data Tempat',
                style: TextStyle(fontSize: 16.0), // Ubah ukuran teks tombol
              ),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DataPenilaianPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors
                    .orange, // Ubah warna latar belakang tombol 3 menjadi oranye
                padding: EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 8.0), // Ubah ukuran tombol
              ),
              child: Text(
                'Nilai Perbandingan Tempat',
                style: TextStyle(fontSize: 16.0), // Ubah ukuran teks tombol
              ),
            ),
            SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }
}

class HalamanDua extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Halaman Dua'),
      ),
      body: Center(
        child: Text('Ini adalah Halaman Dua'),
      ),
    );
  }
}

class HalamanTiga extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Halaman Tiga'),
      ),
      body: Center(
        child: Text('Ini adalah Halaman Tiga'),
      ),
    );
  }
}
