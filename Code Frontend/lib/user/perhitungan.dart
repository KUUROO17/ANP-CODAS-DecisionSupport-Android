import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DataPerAlternatifPage extends StatefulWidget {
  @override
  _DataPerAlternatifPageState createState() => _DataPerAlternatifPageState();
}

class _DataPerAlternatifPageState extends State<DataPerAlternatifPage> {
  Future<Map<String, dynamic>>? _dataPerAlternatifFuture;

  @override
  void initState() {
    super.initState();
    _dataPerAlternatifFuture = getDataPerAlternatifFromApi();
  }

  Future<Map<String, dynamic>> getDataPerAlternatifFromApi() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id');
      final response = await http.get(
          Uri.parse('http://192.168.239.65:5000/data_per_alternatif/$userId'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print(response.body);
        print('Gagal memuat data per alternatif');
        throw Exception('Gagal memuat data per alternatif');
      }
    } catch (error) {
      print('Error: $error');
      throw Exception('Gagal memuat data per alternatif');
    }
  }

  Widget buildDataView(Map<String, dynamic>? dataPerAlternatif) {
    if (dataPerAlternatif != null) {
      return ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
                'Matriks Normalisasi: Hasil normalisasi nilai keputusan pada matriks keputusan, mengubah nilai menjadi skala 0 hingga 1.'),
          ),
          buildSection('Matriks Normalisasi',
              dataPerAlternatif['matriks_normalisasi'] ?? []),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
                'Matriks Negatif: Matriks dengan nilai terkecil dari setiap kolom matriks normalisasi. Digunakan untuk menentukan alternatif terbaik.'),
          ),
          buildSection(
              'Matriks Negatif', dataPerAlternatif['matriks_negatif'] ?? []),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
                'Taxicap: Jarak antara alternatif dengan solusi ideal positif dan negatif, dihitung menggunakan metode taksi.'),
          ),
          buildSection('Taxicap', dataPerAlternatif['taxicap'] ?? []),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
                'Euclidian: Jarak antara alternatif dengan solusi ideal positif dan negatif, dihitung menggunakan metode Euclidean.'),
          ),
          buildSection('Euclidian', dataPerAlternatif['euclidian'] ?? []),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
                'Matriks Relativ Assesment: Hasil perbandingan relatif antara alternatif berdasarkan nilai Taxicap dan Euclidian. Digunakan untuk menentukan skor akhir alternatif.'),
          ),
          buildSection('Matriks Relativ Assesment',
              dataPerAlternatif['matriks_relativ_assesment'] ?? []),
          // buildSection('Nilai Score', dataPerAlternatif['nilai score'] ?? []),
        ],
      );
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  Widget buildSection(String title, List<dynamic> data) {
    return Card(
      elevation: 3,
      child: ExpansionTile(
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: data.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(data[index].toString()),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<Map<String, dynamic>>(
          future: _dataPerAlternatifFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _dataPerAlternatifFuture =
                          getDataPerAlternatifFromApi(); // Reload data jika terjadi error
                    });
                  },
                  child: Text('Reload'),
                ),
              );
            } else {
              return buildDataView(snapshot.data);
            }
          },
        ),
      ),
    );
  }
}
