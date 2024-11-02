import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import 'PerbandinganAlternatifPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DataPenilaianPage(),
    );
  }
}

class DataPenilaianPage extends StatefulWidget {
  @override
  _DataPenilaianPageState createState() => _DataPenilaianPageState();
}

class DataKriteria {
  int id;
  String idKriteria;
  String idAlternatif;
  double nilai;

  DataKriteria({
    required this.id,
    required this.idAlternatif,
    required this.idKriteria,
    required this.nilai,
  });
}

class _DataPenilaianPageState extends State<DataPenilaianPage> {
  List<dynamic> data = [];
  List<DataKriteria> kriteriaList = [];
  List<KriteriaData> kriteriaValueList = [
    KriteriaData(value: 1.0, text: "1"),
    KriteriaData(value: 2.0, text: "2"),
    KriteriaData(value: 3.0, text: "3"),
    KriteriaData(value: 4.0, text: "4"),
    KriteriaData(value: 5.0, text: "5"),
  ];
  KriteriaData? selectedValue;
  Timer? _timer; // Timer untuk auto-reload

  @override
  void initState() {
    super.initState();
    fetchData();
    // Mulai auto-reload setelah widget diinisialisasi
    startAutoReload();
  }

  @override
  void dispose() {
    super.dispose();
    // Hentikan auto-reload saat widget dihapus
    stopAutoReload();
  }

  // Fungsi untuk memulai auto-reload
  void startAutoReload() {
    // Hentikan timer jika sudah berjalan sebelumnya untuk menghindari duplikasi
    stopAutoReload();
    // Mulai auto-reload setiap 10 detik
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      fetchData();
    });
  }

  // Fungsi untuk menghentikan auto-reload
  void stopAutoReload() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
  }

  // Fungsi untuk mengambil data dari API
  Future<void> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    final response = await http
        .get(Uri.parse('http://192.168.239.65:5000/penilaian/$userId'));
    if (response.statusCode == 200) {
      // Bersihkan data sebelum memuat data baru
      data.clear();
      final responseData = json.decode(response.body)['data'];
      final Map<String, dynamic> uniqueValuesMap = {};

      // Kelompokkan data berdasarkan 'id_alternatif' dan 'id_kriteria'
      for (var item in responseData) {
        final key = '${item['id_alternatif']}_${item['id_kriteria']}';
        uniqueValuesMap[key] = item;
      }

      // Tambahkan data ke dalam list data
      uniqueValuesMap.values.forEach((value) {
        data.add(value);
      });

      // Urutkan data berdasarkan 'id_alternatif'
      data.sort((a, b) => a['id_alternatif'].compareTo(b['id_alternatif']));

      // Dapatkan list unik dari kriteria yang ada
      for (var item in responseData) {
        final kriteria = item['id_kriteria'];
        if (!kriteriaList.any((kriteriaData) =>
            kriteriaData.idAlternatif == item['id_alternatif'] &&
            kriteriaData.idKriteria == kriteria)) {
          kriteriaList.add(DataKriteria(
              id: item['id'],
              idAlternatif: item['id_alternatif'],
              idKriteria: item['id_kriteria'],
              nilai: item['nilai']));
        }
      }
      setState(() {});
    } else {
      print('Gagal memuat data dari API');
    }
  }

  Future<String> getNamaAlternatif(String idAlternatif) async {
    final response = await http.get(Uri.parse(
        'http://192.168.239.65:5000/data-alternatif-kode/$idAlternatif'));
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final namaAlternatif = responseData['data'][0]['nama'];
      return namaAlternatif;
    } else {
      throw Exception('Gagal mendapatkan data nama alternatif');
    }
  }

  // Fungsi untuk menampilkan dialog konfirmasi jika data sudah ada
  void showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Data Sudah Ada'),
        content: Text(
            'Anda sudah memiliki data. Untuk menambah data baru, Anda perlu menghapus data yang sudah ada.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Tutup dialog
              deleteAllData(); // Panggil fungsi untuk menghapus data
            },
            child: Text('Hapus Data'),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk menghapus semua data
  void deleteAllData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    final response = await http.delete(
        Uri.parse('http://192.168.239.65:5000/hapus_penilaian/$userId'));
    if (response.statusCode == 200) {
      fetchData(); // Muat data lagi setelah menghapus data
    } else {
      print('Gagal menghapus data');
    }
  }

  // Fungsi untuk navigasi ke halaman perbandingan alternatif
  void navigateToPerbandinganPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NilaiPerbandinganPage(),
      ),
    );
  }

  // Widget untuk membangun tabel data
  Widget buildDataTable(Map<String, dynamic> item) {
    final kriteriaDataList =
        _getKriteriaDataByAlternatif(item['id_alternatif']);
    return DataTable(
      columns: [
        DataColumn(label: Text('Kode')),
        DataColumn(label: Text('Nilai')),
        DataColumn(label: Text('Aksi')),
      ],
      rows: kriteriaDataList.map((kriteriaData) {
        return DataRow(
          cells: [
            DataCell(Center(child: Text('${kriteriaData.idKriteria}'))),
            DataCell(Center(child: Text(kriteriaData.nilai.toString()))),
            DataCell(IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  // Kirim 'penilaianId', 'id_kriteria', dan 'id' ke fungsi editValue
                  editValue(kriteriaData.idKriteria, kriteriaData.id);
                })),
          ],
        );
      }).toList(),
    );
  }

  // Fungsi untuk mendapatkan data kriteria untuk suatu alternatif
  List<DataKriteria> _getKriteriaDataByAlternatif(String alternatifId) {
    return kriteriaList
        .where((kriteria) => kriteria.idAlternatif == alternatifId)
        .toList();
  }

  // Fungsi untuk menampilkan dialog edit nilai
  void editValue(String kriteria, int penilaianId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Nilai'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Edit nilai untuk $kriteria:'),
            DropdownButton<KriteriaData>(
              value: selectedValue,
              items: kriteriaValueList.map((KriteriaData kriteriaData) {
                return DropdownMenuItem<KriteriaData>(
                  value: kriteriaData,
                  child: Text(kriteriaData.text),
                );
              }).toList(),
              onChanged: (KriteriaData? newValue) {
                setState(() {
                  selectedValue = newValue;
                });
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              if (selectedValue != null) {
                // Kirim 'penilaianId', 'id_kriteria', dan nilai baru ke fungsi updateKriteriaValue
                _updateKriteriaValue(
                    penilaianId, kriteria, selectedValue!.value);

                // Perbarui nilai kriteria hanya untuk alternatif yang dipilih
                final alternatifId = data.firstWhere(
                    (item) => item['id'] == penilaianId)['id_alternatif'];
                final kriteriaData = kriteriaList.firstWhere((kriteriaData) =>
                    kriteriaData.idAlternatif == alternatifId &&
                    kriteriaData.idKriteria == kriteria);
                kriteriaData.nilai = selectedValue!.value;
              }
              Navigator.of(context).pop();
            },
            child: Text('Simpan'),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk memperbarui data nilai di API
  Future<void> _updateKriteriaValue(
      int penilaianId, String kriteria, double newValue) async {
    final response = await http.put(
      Uri.parse('http://192.168.239.65:5000/penilaian/$penilaianId'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'id_penilaian': penilaianId,
        'id_kriteria': kriteria,
        'nilai': newValue,
      }),
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data perbandingan berhasil di perbarui'),
        ),
      );
      // fetchData(); // Tidak perlu memuat data lagi karena hanya nilai di satu alternatif yang diubah
    } else {
      print('Gagal memperbarui nilai');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Gagal memperbarui nilai. Silakan coba lagi.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Penilaian'),
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          final item = data[index];
          if (index == 0 ||
              item['id_alternatif'] != data[index - 1]['id_alternatif']) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ListTile(
                  title: FutureBuilder<String>(
                    future: getNamaAlternatif(item['id_alternatif']),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text('Mengambil data...');
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        final namaAlternatif = snapshot.data!;
                        return Text('Nama Tempat: $namaAlternatif');
                      }
                    },
                  ),
                ),
                buildDataTable(item),
                Divider(),
              ],
            );
          } else {
            return Container();
          }
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              // if (isDataExist()) {
              //   showConfirmationDialog(context);
              // } else {
              navigateToPerbandinganPage(context);
              // }
            },
            child: Icon(Icons.add),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {
              fetchData(); // Muat data lagi
            },
            child: Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }
}

class KriteriaData {
  final double value;
  final String text;

  KriteriaData({required this.value, required this.text});
}
