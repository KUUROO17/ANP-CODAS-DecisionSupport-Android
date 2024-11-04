import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'PengisianNilaiKriteriaPage.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pengisian Nilai Antar Kriteria',
      home: ViewDataPerbandingan(),
    );
  }
}

class ViewDataPerbandingan extends StatefulWidget {
  @override
  _ViewDataPerbandinganState createState() => _ViewDataPerbandinganState();
}

class _ViewDataPerbandinganState extends State<ViewDataPerbandingan> {
  List<Map<String, dynamic>> perbandinganKriteria = [];
  List<Map<String, dynamic>> kriteriaList = [];

  @override
  void initState() {
    super.initState();
    getDataPerbandinganFromApi();
    getDataKriteriaFromApi();
  }

  Future<void> getDataPerbandinganFromApi() async {
    final response = await http
        .get(Uri.parse('http://192.168.239.65:5000/simpan_perbandingan'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['data'] != null) {
        setState(() {
          perbandinganKriteria = List.from(data['data']);
        });
      }
    } else {
      print('Gagal memuat data perbandingan');
    }
  }

  Future<void> getDataKriteriaFromApi() async {
    final response =
        await http.get(Uri.parse('http://192.168.239.65:5000/data-kriteria'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['data'] != null) {
        setState(() {
          kriteriaList = List.from(data['data']);
        });
      }
    } else {
      print('Gagal memuat data kriteria');
    }
  }

  Future<void> hapusSemuaNilaiPerbandingan() async {
    final response = await http.delete(
        Uri.parse('http://192.168.239.65:5000/hapus_semua_perbandingan'));

    if (response.statusCode == 200) {
      print('Semua nilai perbandingan berhasil dihapus');
    } else {
      print('Gagal menghapus semua nilai perbandingan');
    }
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Konfirmasi Alert!!!',
            style: TextStyle(
              color: Colors.red,
            ),
          ),
          content: Text(
              'jika anda ingin menambahkan nilai perbandingan kriteria anda harus menghapus nilai sebelumnya Apakah Anda yakin ingin menghapus semua nilai perbandingan?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Tidak'),
            ),
            ElevatedButton(
              onPressed: () {
                hapusSemuaNilaiPerbandingan();
                Navigator.of(context).pop();
                getDataPerbandinganFromApi();
              },
              child: Text('Ya'),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(int index) {
    double? selectedValue = perbandinganKriteria[index]['nilai_perbandingan'];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Nilai Perbandingan'),
          content: Container(
            width: 200, // Atur lebar sesuai kebutuhan
            child: DropdownButton<double>(
              isExpanded: true, // Menyesuaikan lebar dengan parent widget
              value: selectedValue,
              onChanged: (newValue) {
                setState(() {
                  perbandinganKriteria[index]['nilai_perbandingan'] = newValue;
                });
              },
              items: [
                DropdownMenuItem<double>(
                  value: 1.0,
                  child: Text('1 (Sama penting)'),
                ),
                DropdownMenuItem<double>(
                  value: 2.0,
                  child: Text('2 (Mendekati sedikit lebih penting)'),
                ),
                DropdownMenuItem<double>(
                  value: 3.0,
                  child: Text('3 (Sedikit lebih penting)'),
                ),
                DropdownMenuItem<double>(
                  value: 4.0,
                  child: Text('4 (Mendekati lebih penting)'),
                ),
                DropdownMenuItem<double>(
                  value: 5.0,
                  child: Text('5 (Lebih penting)'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Nilai perbandingan berhasil diubah'),
                  ),
                );

                // Tambahkan kode untuk menyimpan perubahan nilai perbandingan ke API
                int id = perbandinganKriteria[index]['id'];
                double? newValue =
                    perbandinganKriteria[index]['nilai_perbandingan'];
                simpanPerubahanNilaiPerbandingan(id, newValue);
                Navigator.of(context).pop();
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void simpanPerubahanNilaiPerbandingan(int id, double? newValue) async {
    final String apiUrl = 'http://192.168.239.65:5000/simpan_perbandingan/$id';
    final Map<String, dynamic> requestBody = {
      'nilai_perbandingan': newValue,
    };

    final response = await http.put(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      print('Data perbandingan berhasil diupdate');
    } else {
      print('Gagal mengupdate data perbandingan');
    }
  }

  String getKriteriaName(String kodeKriteria) {
    Map<String, dynamic> kriteria =
        kriteriaList.firstWhere((kriteria) => kriteria['kode'] == kodeKriteria);
    return kriteria['nama'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Perbandingan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('Kriteria')),
                    DataColumn(label: Text('Nilai')),
                    DataColumn(label: Text('Edit')),
                  ],
                  rows: perbandinganKriteria
                      .map(
                        (data) => DataRow(
                          cells: [
                            DataCell(Text('Apakah sama penting' ' ' +
                                getKriteriaName(data['kriteria1']) +
                                ' sama ' +
                                getKriteriaName(data['kriteria2']))),
                            DataCell(Text('${data['nilai_perbandingan']}')),
                            DataCell(IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                _showEditDialog(
                                    perbandinganKriteria.indexOf(data));
                              },
                            )),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    getDataPerbandinganFromApi();
                  },
                  icon: Icon(Icons.refresh),
                  label: Text('Reload'),
                ),
                SizedBox(width: 16.0),
                ElevatedButton.icon(
                  onPressed: () {
                    if (perbandinganKriteria.isNotEmpty) {
                      _showConfirmationDialog();
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PengisianNilaiPage()),
                      );
                    }
                  },
                  icon: Icon(Icons.add),
                  label: Text('Add'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
