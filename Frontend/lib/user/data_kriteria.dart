import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Album {
  final String kode;
  final String nama;
  final String status;

  Album({
    required this.kode,
    required this.nama,
    required this.status,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      kode: json['kode'],
      nama: json['nama'],
      status: json['status'],
    );
  }
}

Future<List<Album>> fetchAlbums() async {
  final response =
      await http.get(Uri.parse('http://192.168.239.65:5000/data-kriteria'));

  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body)['data'];
    List<Album> albums = data.map((json) => Album.fromJson(json)).toList();
    return albums;
  } else {
    throw Exception('Failed to load albums');
  }
}

Future<List<double>> fetchNilaiBobot() async {
  final response = await http
      .get(Uri.parse('http://192.168.239.65:5000/ambil_nilai_perbandingan'));

  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);
    List<double> nilaiBobot =
        data.map((value) => double.parse(value.toString())).toList();
    return nilaiBobot;
  } else {
    throw Exception('Failed to load nilai bobot');
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Data Kriteria',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: KriteriaHomePage(),
    );
  }
}

class KriteriaHomePage extends StatefulWidget {
  const KriteriaHomePage({Key? key}) : super(key: key);

  @override
  _KriteriaHomePageState createState() => _KriteriaHomePageState();
}

class _KriteriaHomePageState extends State<KriteriaHomePage> {
  late Future<List<Album>> futureAlbums;
  late Future<List<double>> futureNilaiBobot;

  @override
  void initState() {
    super.initState();
    futureAlbums = fetchAlbums();
    futureNilaiBobot = fetchNilaiBobot();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Kriteria'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'DATA KRITERIA :',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Album>>(
              future: futureAlbums,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Album> albums = snapshot.data!;
                  return FutureBuilder<List<double>>(
                    future: futureNilaiBobot,
                    builder: (context, bobotSnapshot) {
                      if (bobotSnapshot.hasData) {
                        List<double> nilaiBobot = bobotSnapshot.data!;
                        if (albums.length != nilaiBobot.length) {
                          return Text(
                              'Jumlah data kriteria/alternatif tidak sesuai dengan jumlah data nilai bobot.');
                        }
                        return ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            DataTable(
                              columnSpacing: 16.0,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color:
                                        Colors.black), // Garis di sekitar tabel
                              ),
                              columns: const <DataColumn>[
                                DataColumn(label: Text('No')),
                                DataColumn(label: Text('Kode')),
                                DataColumn(label: Text('Nama Kriteria')),
                                DataColumn(label: Text('Status')),
                                DataColumn(label: Text('Nilai Bobot')),
                              ],
                              rows: albums.map((album) {
                                bool isEven = albums.indexOf(album) % 2 == 0;
                                Color rowColor =
                                    isEven ? Colors.grey[300]! : Colors.white;

                                // Ambil nilai bobot sesuai dengan indeks data
                                double bobot =
                                    nilaiBobot[albums.indexOf(album)];

                                return DataRow(
                                  color: MaterialStateColor.resolveWith(
                                      (states) => rowColor),
                                  cells: <DataCell>[
                                    DataCell(Text((1 + albums.indexOf(album))
                                        .toString())),
                                    DataCell(Text(album.kode)),
                                    DataCell(Text(album.nama)),
                                    DataCell(Text(album.status)),
                                    DataCell(Text(bobot.toString())),
                                  ],
                                );
                              }).toList(),
                            ),
                          ],
                        );
                      } else if (bobotSnapshot.hasError) {
                        return Text('${bobotSnapshot.error}');
                      }
                      // By default, show a loading spinner.
                      return const CircularProgressIndicator();
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'PENGERTIAN KRITERIA :',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildKriteriaCard(
                  'pengertian status kriteria (max)',
                  'Kriteria Max mengacu pada kondisi di mana tidak ada biaya atau kerugian yang terlibat. Dalam kriteria ini, semakin tinggi nilai yang diberikan, semakin baik hasilnya tanpa menyebabkan pengeluaran uang tambahan atau dampak negatif.',
                ),
                _buildKriteriaCard('pengertian status kriteria (min)',
                    'Kriteria Cost atau Min mengacu pada kondisi di mana terdapat pengeluaran biaya atau kerugian. Dalam kriteria ini, semakin rendah nilai yang diberikan, semakin baik hasilnya. Artinya, kriteria ini menunjukkan bahwa tujuan utamanya adalah untuk meminimalkan biaya atau dampak negatif yang terlibat. '),
                _buildKriteriaCard(
                  'Kepadatan Penduduk',
                  'Kepadatan penduduk adalah ukuran jumlah orang yang tinggal dalam suatu daerah per satuan luas. Dalam konteks mencari lokasi bank, kepadatan penduduk yang tinggi dapat menunjukkan adanya potensi pasar yang besar.',
                ),
                _buildKriteriaCard(
                  'Keamanan dan Kenyamanan',
                  'Keamanan dan kenyamanan merujuk pada faktor-faktor yang membuat lokasi bank aman dan nyaman bagi nasabah dan karyawan. Hal ini mencakup faktor seperti lokasi yang bebas dari ancaman keamanan dan mudah dijangkau oleh transportasi umum, serta lingkungan yang bersih dan nyaman.',
                ),
                _buildKriteriaCard(
                  'Aksesibilitas dan Visibilitas',
                  'Aksesibilitas dan visibilitas merujuk pada kemudahan akses ke lokasi bank dan kemudahan untuk melihat atau menemukan lokasi tersebut. Faktor-faktor ini meliputi kemudahan dijangkau oleh transportasi umum, parkir yang memadai, dan mudah ditemukan oleh orang yang mencari lokasi bank.',
                ),
                _buildKriteriaCard(
                  'Infrastruktur dan Usaha Sekitar',
                  'Infrastruktur dan usaha sekitar mencakup fasilitas yang dibutuhkan untuk menjalankan operasi bank dan keberadaan usaha sekitar yang dapat mendukung lokasi bank, seperti tempat makan, toko-toko, dan lain sebagainya.',
                ),
                _buildKriteriaCard(
                  'Pertumbuhan Ekonomi Sekitar',
                  'Pertumbuhan ekonomi sekitar merujuk pada keadaan perekonomian di wilayah tempat lokasi bank berada. Jika wilayah tersebut memiliki pertumbuhan ekonomi yang baik, maka akan meningkatkan potensi pasar untuk bank dan memperkuat pangsa pasar bank di wilayah tersebut.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKriteriaCard(String judul, String pengertian) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              judul,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(pengertian),
          ],
        ),
      ),
    );
  }

  Future<void> _reloadData() async {
    setState(() {
      futureAlbums = fetchAlbums();
      futureNilaiBobot = fetchNilaiBobot();
    });
  }
}
