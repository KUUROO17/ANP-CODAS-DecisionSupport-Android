import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pengisian Nilai Antar Kriteria',
      home: PengisianNilaiPage(),
    );
  }
}

class PengisianNilaiPage extends StatefulWidget {
  @override
  _PengisianNilaiPageState createState() => _PengisianNilaiPageState();
}

class _PengisianNilaiPageState extends State<PengisianNilaiPage> {
  List<Map<String, dynamic>> kriteriaList = [];
  List<Map<String, dynamic>> perbandinganKriteria = [];
  double? nilaiAntarKriteria;

  @override
  void initState() {
    super.initState();
    getDataKriteriaFromApi();
  }

  Future<void> getDataKriteriaFromApi() async {
    final response =
        await http.get(Uri.parse('http://192.168.239.65:5000/data-kriteria'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['data'] != null) {
        setState(() {
          kriteriaList = List.from(data['data']);
          // Membuat kombinasi perbandingan kriteria
          for (int i = 0; i < kriteriaList.length - 1; i++) {
            for (int j = i + 1; j < kriteriaList.length; j++) {
              perbandinganKriteria.add({
                "kriteria1": kriteriaList[i]["kode"],
                "kriteria2": kriteriaList[j]["kode"],
                "nilai_perbandingan": null,
              });
            }
          }
        });
      }
    } else {
      print('Failed to load data');
    }
  }

  Future<void> simpanPerbandinganToApi() async {
    final url = Uri.parse('http://192.168.239.65:5000/simpan_perbandingan');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode(perbandinganKriteria);

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Data perbandingan berhasil disimpan'),
          ),
        );
        Navigator.pop(context, true);
      } else {
        print('Gagal menyimpan data perbandingan di server');
      }
    } catch (e) {
      print('Terjadi kesalahan saat menyimpan data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pengisian Nilai Antar Kriteria'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: perbandinganKriteria.length,
                itemBuilder: (context, index) {
                  final kriteria1 = perbandinganKriteria[index]["kriteria1"];
                  final kriteria2 = perbandinganKriteria[index]["kriteria2"];
                  final nilai =
                      perbandinganKriteria[index]["nilai_perbandingan"];
                  final color = index % 2 == 0
                      ? Colors.grey[300]
                      : Colors.grey[
                          200]; // Warna background abu-abu dan putih keabu-abuan bergantian

                  return Card(
                    color: color,
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text('Perbandingan $kriteria1 dan $kriteria2',
                              style: TextStyle(fontSize: 16.0, color: Colors.black)),
                          SizedBox(height: 8.0),
                          DropdownButton<double>(
                            value: nilai,
                            onChanged: (newValue) {
                              setState(() {
                                perbandinganKriteria[index]["nilai_perbandingan"] = newValue;
                              });
                            },
                            items: [
                            DropdownMenuItem<double>(
                              value: 1.0,
                              child: Text('1 (Sama penting)',
                                  style: TextStyle(
                                      fontSize: 16.0, color: Colors.black)),
                            ),
                            DropdownMenuItem<double>(
                              value: 2.0,
                              child: Text('2 (Mendekati sedikit lebih penting)',
                                  style: TextStyle(
                                      fontSize: 16.0, color: Colors.black)),
                            ),
                            DropdownMenuItem<double>(
                              value: 3.0,
                              child: Text('3 (Sedikit lebih penting)',
                                  style: TextStyle(
                                      fontSize: 16.0, color: Colors.black)),
                            ),
                            DropdownMenuItem<double>(
                              value: 4.0,
                              child: Text('4 (Mendekati lebih penting)',
                                  style: TextStyle(
                                      fontSize: 16.0, color: Colors.black)),
                            ),
                            DropdownMenuItem<double>(
                              value: 5.0,
                              child: Text('5 (Lebih penting)',
                                  style: TextStyle(
                                      fontSize: 16.0, color: Colors.black)),
                            ),
                          ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                simpanPerbandinganToApi();
              },
              child: Text('Simpan', style: TextStyle(fontSize: 16.0)),
            ),
          ],
        ),
      ),
    );
  }
}
