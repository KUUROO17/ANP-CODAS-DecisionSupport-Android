import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(
    home: NilaiScorePage(),
  ));
}

class NilaiScorePage extends StatefulWidget {
  @override
  _NilaiScorePageState createState() => _NilaiScorePageState();
}

class _NilaiScorePageState extends State<NilaiScorePage> {
  Future<List<dynamic>>? _dataAlternatifFuture;

  @override
  void initState() {
    super.initState();
    _dataAlternatifFuture = getDataAlternatifFromApi();
  }

  Future<List<dynamic>> getDataAlternatifFromApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    final response = await http.get(
      Uri.parse('http://192.168.239.65:5000/data-alternatif-hasil/$userId'),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      return responseData['data'];
    } else {
      throw Exception('Gagal memuat data alternatif');
    }
  }

  Future<Map<String, dynamic>> getDataByCodeFromApi(String code) async {
    final response = await http.get(
      Uri.parse('http://192.168.239.65:5000/data-alternatif-kode/$code'),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      return responseData['data'][0]; // Assuming there's only one item in the list
    } else {
      throw Exception('Gagal memuat data berdasarkan kode');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<dynamic>>(
          future: _dataAlternatifFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Gagal memuat data alternatif'));
            } else {
              List<dynamic> dataAlternatif = snapshot.data ?? [];

              // Sort the data based on 'value' in descending order
              dataAlternatif.sort((a, b) => b['value'].compareTo(a['value']));

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('Nama')),
                    DataColumn(label: Text('Alamat')),
                    DataColumn(label: Text('Value'), numeric: true),
                    DataColumn(label: Text('Ranking')),
                  ],
                  rows: dataAlternatif.map((data) {
                    final String idAlternatif = data['id_alternatif'];
                    final double value = data['value'];
                    final int index = dataAlternatif.indexOf(data);

                    return DataRow(cells: [
                      DataCell(FutureBuilder<Map<String, dynamic>>(
                        future: getDataByCodeFromApi(idAlternatif),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Text('Gagal memuat data');
                          } else {
                            final Map<String, dynamic> additionalData = snapshot.data ?? {};
                            final String nama = additionalData['nama'] ?? '-';
                            return Text(nama);
                          }
                        },
                      )),
                      DataCell(FutureBuilder<Map<String, dynamic>>(
                        future: getDataByCodeFromApi(idAlternatif),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Text('Gagal memuat data');
                          } else {
                            final Map<String, dynamic> additionalData = snapshot.data ?? {};
                            final String alamat = additionalData['alamat'] ?? '-';
                            return Text(alamat);
                          }
                        },
                      )),
                      DataCell(Text(value.toString())),
                      DataCell(Text('Ranking ${index + 1}')),
                    ]);
                  }).toList(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
