import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Alternatif {
  final String kode;
  final String nama;
  final String alamat;

  Alternatif({
    required this.kode,
    required this.nama,
    required this.alamat,
  });

  factory Alternatif.fromJson(Map<String, dynamic> json) {
    return Alternatif(
      kode: json['kode'],
      nama: json['nama'],
      alamat: json['alamat'],
    );
  }
}

 // Pastikan mengganti dengan path yang benar

class EditDataAlternatifPage extends StatefulWidget {
  final Alternatif alternatif;

  EditDataAlternatifPage({required this.alternatif});

  @override
  _EditDataAlternatifPageState createState() => _EditDataAlternatifPageState();
}

class _EditDataAlternatifPageState extends State<EditDataAlternatifPage> {
  TextEditingController _kodeController = TextEditingController();
  TextEditingController _namaController = TextEditingController();
  TextEditingController _alamatController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _kodeController.text = widget.alternatif.kode;
    _namaController.text = widget.alternatif.nama;
    _alamatController.text = widget.alternatif.alamat;
  }

  Future<void> _editData() async {
    String url = 'http://192.168.239.65:5000/data-alternatif/${widget.alternatif.kode}';
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    Map<String, dynamic> data = {
      "kode": _kodeController.text,
      "nama": _namaController.text,
      "alamat": _alamatController.text,
    };

    try {
      final response = await http.put(Uri.parse(url),
          headers: headers, body: jsonEncode(data));

      if (response.statusCode == 200) {
        // Data berhasil diubah di database
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Data berhasil diubah'),
          ),
        );
        // Kirim data alternatif yang telah diubah kembali ke halaman sebelumnya
        Navigator.pop(context, Alternatif(
          kode: _kodeController.text,
          nama: _namaController.text,
          alamat: _alamatController.text,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengubah data'),
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
        title: Text('Edit Data Alternatif'),
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
              onPressed: _editData,
              child: Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
