import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'AlternatifHomePage.dart'; // Ganti dengan import halaman AlternatifHomePage.dart yang sesuai

class AddDataAlternatifPage extends StatefulWidget {
  AddDataAlternatifPage();

  @override
  _AddDataAlternatifPageState createState() => _AddDataAlternatifPageState();
}

class _AddDataAlternatifPageState extends State<AddDataAlternatifPage> {
  TextEditingController _kodeController = TextEditingController();
  TextEditingController _namaController = TextEditingController();
  TextEditingController _alamatController = TextEditingController();

  @override
  void dispose() {
    _kodeController.dispose();
    _namaController.dispose();
    _alamatController.dispose();
    super.dispose();
  }

  Future<void> _addData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String url =
        'http://192.168.239.65:5000/data-alternatif'; // Ganti dengan URL API Flask Anda
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final idUser = preferences.getInt('user_id');
    Map<String, dynamic> data = {
      "kode": _kodeController.text,
      "nama": _namaController.text,
      "alamat": _alamatController.text,
      "id_user": idUser,
    };

    try {
      final response = await http.post(Uri.parse(url),
          headers: headers, body: jsonEncode(data));

      if (response.statusCode == 201) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AlternatifHomePage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan saat menambahkan data'),
          ),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Data Alternatif'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
              decoration: InputDecoration(labelText: 'Nama'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _alamatController,
              decoration: InputDecoration(labelText: 'Alamat'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _addData,
              child: Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
