import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePageUserPerkenalan(),
    );
  }
}

class HomePageUserPerkenalan extends StatefulWidget {
  @override
  _HomePageUserPerkenalanState createState() => _HomePageUserPerkenalanState();
}

class UserData {
  final String nama;

  UserData({
    required this.nama,
  });
}

class _HomePageUserPerkenalanState extends State<HomePageUserPerkenalan> {
  UserData? userData;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    final response =
        await http.get(Uri.parse('http://192.168.239.65:5000/user/$userId'));
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body)['data'][0];
      setState(() {
        userData = UserData(
          nama: responseData['nama'],
        );
      });
    } else {
      throw Exception('Failed to load user data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            userData != null
                ? Text(
                    'Selamat Datang, ${userData!.nama}!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : CircularProgressIndicator(),
            SizedBox(height: 20),
            Text(
              'Tata Cara Penggunaan Aplikasi:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            StepByStepGuide(
              stepNumber: '1',
              stepTitle: 'Langkah 1: Pahami Kriteria Penilaian',
              stepDescription:
                  'Pelajari daftar kriteria yang memengaruhi penilaian tempat. Setiap kriteria memiliki bobot berbeda terhadap hasil akhir.',
              icon: Icons.info,
            ),
            StepByStepGuide(
              stepNumber: '2',
              stepTitle: 'Langkah 2: Tambah Data Tempat',
              stepDescription:
                  'Masukkan nama, kode, dan alamat tempat yang ingin dibandingkan. Simpan data untuk melanjutkan.',
              icon: Icons.data_saver_on_rounded,
            ),
            StepByStepGuide(
              stepNumber: '3',
              stepTitle: 'Langkah 3: Isi Nilai Kriteria',
              stepDescription:
                  'Beri nilai pada kriteria yang relevan untuk masing-masing tempat. Nilai ini akan digunakan dalam perhitungan skor.',
              icon: Icons.assignment_add,
            ),
            StepByStepGuide(
              stepNumber: '4',
              stepTitle: 'Langkah 4: Lihat Hasil Perbandingan',
              stepDescription:
                  'Lihat hasil perbandingan tempat pada halaman "Nilai Perbandingan". Dapatkan informasi tentang tempat yang paling cocok berdasarkan skor.',
              icon: Icons.bar_chart,
            ),
            StepByStepGuide(
              stepNumber: '5',
              stepTitle: 'Langkah 5: Ubah Nilai Kriteria',
              stepDescription:
                  'Edit nilai kriteria jika diperlukan pada halaman "Nilai Perbandingan Tempat".',
              icon: Icons.edit,
            ),
            StepByStepGuide(
              stepNumber: '6',
              stepTitle: 'Langkah 6: Melihat Perhitungan',
              stepDescription:
                  'Lihat perhitungan sistem pada halaman "Perhitungan". Pelajari skor masing-masing tempat berdasarkan nilai kriteria.',
              icon: Icons.calculate,
            ),
          ],
        ),
      ),
    );
  }
}

class StepByStepGuide extends StatelessWidget {
  final String stepNumber;
  final String stepTitle;
  final String stepDescription;
  final IconData icon;

  StepByStepGuide({
    required this.stepNumber,
    required this.stepTitle,
    required this.stepDescription,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              child: Center(
                child: Icon(
                  icon,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                stepTitle,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 6),
        Text(
          stepDescription,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[800],
          ),
        ),
        Divider(),
      ],
    );
  }
}
