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
      title: 'Contoh Ambil Data dari API',
      home: ResultPage(),
    );
  }
}

class ResultPage extends StatefulWidget {
  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  List<Map<String, dynamic>> matrixData = [];

  @override
  void initState() {
    super.initState();
    getDataMatrixNormalized();
  }

  Future<void> getDataMatrixNormalized() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.239.65:5000/ambil_nilai_perbandingan'));
      final data = jsonDecode(response.body);
      final List<double> matrixNormalized = List<double>.from(data);
      final responseKriteria = await http.get(Uri.parse('http://192.168.239.65:5000/data-kriteria'));
      final dataKriteria = jsonDecode(responseKriteria.body);
      final List<Map<String, dynamic>> kriteriaNames = List<Map<String, dynamic>>.from(dataKriteria['data']);

      // Pastikan panjang matrixNormalized dan kriteriaNames sama
      if (matrixNormalized.length == kriteriaNames.length) {
        setState(() {
          for (int i = 0; i < matrixNormalized.length; i++) {
            matrixData.add({
              'nama_kriteria': kriteriaNames[i]['nama'],
              'nilai_perbandingan': matrixNormalized[i],
            });
          }
        });
      } else {
        print('Panjang data dari API tidak sama');
      }
    } catch (e) {
      print('Terjadi kesalahan saat mengambil data dari API: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Halaman Nilai Bobot'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 24,
          columns: [
            DataColumn(label: Text('Nama Kriteria')),
            DataColumn(label: Text('Nilai Bobot')),
          ],
          rows: matrixData.map((data) {
            return DataRow(cells: [
              DataCell(Text(data['nama_kriteria'])),
              DataCell(Text(data['nilai_perbandingan'].toString())),
            ]);
          }).toList(),
        ),
      ),
    );
  }
}
