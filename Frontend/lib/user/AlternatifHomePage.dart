import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'PerbandinganAlternatifPage.dart';

class Alternatif {
  final String kode;
  String nama;
  String alamat;

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

class AlternatifHomePage extends StatefulWidget {
  @override
  _AlternatifHomePageState createState() => _AlternatifHomePageState();
}

class _AlternatifHomePageState extends State<AlternatifHomePage> {
  late Future<List<Alternatif>> futureAlternatifs;

  @override
  void initState() {
    super.initState();
    // Ganti 'user_id' dengan user_id yang telah Anda simpan setelah proses login
    futureAlternatifs = fetchAlternatif();
  }

  Future<List<Alternatif>> fetchAlternatif() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    final response = await http
        .get(Uri.parse('http://192.168.239.65:5000/data-alternatif/$userId'));
    print(response.body);
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['data'];
      List<Alternatif> alternatifs =
          data.map((json) => Alternatif.fromJson(json)).toList();
      return alternatifs;
    } else {
      throw Exception('Gagal memuat data alternatif');
    }
  }

  void _editData(Alternatif alternatif) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditDataPopUp(alternatif: alternatif);
      },
    );
  }

  void _deleteData(Alternatif alternatif) {
    _confirmDelete(alternatif);
  }

  Future<void> _confirmDelete(Alternatif alternatif) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Hapus'),
          content: Text('Apakah Anda ingin menghapus data ini?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                await _deleteDataConfirmed(alternatif); // Hapus data
                Navigator.of(context).pop(); // Tutup dialog
              },
              child: Text('Oke'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteDataConfirmed(Alternatif alternatif) async {
    String url = 'http://192.168.239.65:5000/data-alternatif/${alternatif.kode}';
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.delete(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        // Data berhasil dihapus dari database
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Data berhasil dihapus'),
          ),
        );
        setState(() {
          // Perbarui tampilan dengan menghapus data dari futureAlternatifs
          futureAlternatifs = fetchAlternatif();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menghapus data'),
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
        title: const Text('MITA TEMPAT'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Data Tempat :',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Alternatif>>(
              future: futureAlternatifs,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      horizontalMargin: 16.0,
                      columnSpacing: 16.0,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                        ),
                      ),
                      columns: const <DataColumn>[
                        DataColumn(label: Text('Kode')),
                        DataColumn(label: Text('Nama')),
                        DataColumn(label: Text('Alamat')),
                        DataColumn(label: Text('Action')),
                      ],
                      rows: snapshot.data!.map((alternatif) {
                        bool isEven =
                            snapshot.data!.indexOf(alternatif) % 2 == 0;
                        Color rowColor =
                            isEven ? Colors.grey[300]! : Colors.white;

                        return DataRow(
                          color: MaterialStateColor.resolveWith(
                            (states) => rowColor,
                          ),
                          cells: <DataCell>[
                            DataCell(Text(alternatif.kode)),
                            DataCell(
                              Text(
                                alternatif.nama,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            DataCell(
                              Text(
                                alternatif.alamat,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            DataCell(
                              Row(
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      _editData(alternatif);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      _deleteData(alternatif);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return CircularProgressIndicator();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Tombol Tambah Data Tempat
          Container(
            width: 300,
            child: FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddDataAlternatifPage(),
                  ),
                );
              },
              icon: Icon(Icons.data_saver_on_rounded),
              label: Text('Tambah Data Tempat'),
            ),
          ),
          SizedBox(height: 10.0), // Jarak antara tombol

          // Tombol Refresh
          Container(
            width: 300,
            child: FloatingActionButton.extended(
              onPressed: () {
                setState(() {
                  futureAlternatifs = fetchAlternatif();
                });
              },
              icon: Icon(Icons.refresh),
              label: Text('Refresh'),
            ),
          ),
          SizedBox(height: 10.0), // Jarak antara tombol

          // Tombol Masukkan Nilai Perbandingan
          Container(
            width: 300,
            child: FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        NilaiPerbandinganPage(), // Ganti dengan halaman lain yang diinginkan
                  ),
                );
              },
              icon: Icon(Icons.balance_outlined),
              label: Text('Masukkan Nilai Perbandingan'),
            ),
          ),
        ],
      ),
    );
  }
}

class EditDataPopUp extends StatefulWidget {
  final Alternatif alternatif;

  EditDataPopUp({required this.alternatif});

  @override
  _EditDataPopUpState createState() => _EditDataPopUpState();
}

class _EditDataPopUpState extends State<EditDataPopUp> {
  late TextEditingController _namaController;
  late TextEditingController _alamatController;

  @override
  void initState() {
    super.initState();

    _namaController = TextEditingController(text: widget.alternatif.nama);
    _alamatController = TextEditingController(text: widget.alternatif.alamat);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Data'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _namaController,
            decoration: InputDecoration(labelText: 'Nama'),
          ),
          TextField(
            controller: _alamatController,
            decoration: InputDecoration(labelText: 'Alamat'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Tutup dialog
          },
          child: Text('Batal'),
        ),
        TextButton(
          onPressed: () async {
            await _updateData(); // Simpan perubahan
            Navigator.of(context).pop(); // Tutup dialog
          },
          child: Text('Simpan'),
        ),
      ],
    );
  }

  Future<void> _updateData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final userId = preferences
        .getInt('user_id'); // Ambil nilai 'user_id' dari SharedPreferences

    String url =
        'http://192.168.239.65:5000/data-alternatif/${widget.alternatif.kode}';
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    Map<String, dynamic> data = {
      'kode': widget.alternatif.kode,
      'nama': _namaController.text,
      'alamat': _alamatController.text,
      'user_id':
          userId, // Gunakan nilai 'user_id' dalam data yang akan diperbarui
    };

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        // Data berhasil diperbarui di database
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Data berhasil diperbarui'),
          ),
        );
        setState(() {
          // Perbarui tampilan dengan mengganti data nama dan alamat
          widget.alternatif.nama = _namaController.text;
          widget.alternatif.alamat = _alamatController.text;
        });
      } else {
        print(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memperbarui data'),
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
}

class AddDataAlternatifPage extends StatefulWidget {
  @override
  _AddDataAlternatifPageState createState() => _AddDataAlternatifPageState();
}

class _AddDataAlternatifPageState extends State<AddDataAlternatifPage> {
  TextEditingController _namaController = TextEditingController();
  TextEditingController _alamatController = TextEditingController();

  // Fungsi untuk menghasilkan UUID sebagai kode untuk data alternatif
  String generateUniqueId() {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    int random = Random().nextInt(10000);
    return '$timestamp$random';
  }

  Future<void> _addData() async {
    if (_namaController.text.isEmpty || _alamatController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Nama dan alamat tidak boleh kosong'),
        ),
      );
      return; // Hentikan proses jika ada input yang kosong
    }

    SharedPreferences preferences = await SharedPreferences.getInstance();
    final userId = preferences.getInt('user_id');
    String url = 'http://192.168.239.65:5000/data-alternatif';
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    Map<String, dynamic> data = {
      "kode": generateUniqueId(),
      "nama": _namaController.text,
      "alamat": _alamatController.text,
      "id_user": userId,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(data),
      );

      if (response.statusCode == 201) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AlternatifHomePage(),
          ),
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
        title: Text('Tambah Data Tempat'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Data Alternatif',
      home: AlternatifHomePage(),
    );
  }
}
