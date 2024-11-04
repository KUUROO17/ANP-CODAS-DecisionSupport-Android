import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum Status { Min, Max }

class AddDataPage extends StatefulWidget {
  @override
  _AddDataPageState createState() => _AddDataPageState();
}

class _AddDataPageState extends State<AddDataPage> {
  TextEditingController _kodeController = TextEditingController();
  TextEditingController _namaController = TextEditingController();
  Status _selectedStatus = Status.Min;

  void _addData() {
    if (_kodeController.text.isEmpty ||
        _namaController.text.isEmpty ||
        _selectedStatus == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Harap lengkapi semua kolom sebelum menyimpan data'),
        ),
      );
      return; // Hentikan proses tambah data jika ada kolom yang kosong
    }

    String status = _selectedStatus == Status.Min ? 'Min' : 'Max';

    String url = 'http://192.168.239.65:5000/data-kriteria';
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    Map<String, dynamic> data = {
      "kode": _kodeController.text,
      "nama": _namaController.text,
      "status": status,
    };

    http.post(Uri.parse(url), headers: headers, body: jsonEncode(data))
        .then((response) {
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Data berhasil ditambah'),
          ),
        );
        Navigator.pop(context, true); // Berhasil tambah data, kembali ke halaman sebelumnya
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menambahkan data'),
          ),
        );
      }
    }).catchError((error) {
      print('Error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan saat menambahkan data'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Data'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _kodeController,
              decoration: InputDecoration(labelText: 'Kode'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _namaController,
              decoration: InputDecoration(labelText: 'Nama Kriteria'),
            ),
            SizedBox(height: 16.0),
            Text('Status'),
            DropdownButton<Status>(
              value: _selectedStatus,
              onChanged: (Status? newValue) {
                setState(() {
                  _selectedStatus = newValue!;
                });
              },
              items: Status.values.map((Status status) {
                return DropdownMenuItem<Status>(
                  value: status,
                  child: Text(status == Status.Min ? 'Min' : 'Max'),
                );
              }).toList(),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _addData,
              child: Text('Tambah Data'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AddDataPage(),
  ));
}
