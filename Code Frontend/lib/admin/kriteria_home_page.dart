import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'add_data_page.dart';

class Album {
  final String kode;
  String nama;
  String status;

  Album({
    required this.kode,
    required this.nama,
    required this.status,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      kode: json['kode'],
      nama: json['nama'],
      status: json['status'],
    );
  }
}

Future<List<Album>> fetchAlbums() async {
  final response = await http.get(Uri.parse('http://192.168.239.65:5000/data-kriteria'));

  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body)['data'];
    List<Album> albums = data.map((json) => Album.fromJson(json)).toList();
    return albums;
  } else {
    throw Exception('Failed to load albums');
  }
}

class KriteriaHomePage extends StatefulWidget {
  const KriteriaHomePage({Key? key}) : super(key: key);

  @override
  _KriteriaHomePageState createState() => _KriteriaHomePageState();
}

class _KriteriaHomePageState extends State<KriteriaHomePage> {
  late Future<List<Album>> futureAlbums;
  late Timer _timer; // 1. Tambahkan variabel Timer

  @override
  void initState() {
    super.initState();
    futureAlbums = fetchAlbums();

    // 2. Buat dan atur Timer untuk memuat ulang data setiap 5 detik
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      _reloadData();
    });
  }

  @override
  void dispose() {
    // 3. Batalkan timer saat halaman tidak aktif lagi
    _timer.cancel();
    super.dispose();
  }
  void _editData(Album album) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditDataPage(album: album);
      },
    );
  }

  void _deleteData(Album album) {
    showDialog(
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
                await _deleteDataConfirmed(album); // Hapus data
                Navigator.of(context).pop(); // Tutup dialog
              },
              child: Text('Oke'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteDataConfirmed(Album album) async {
    String url = 'http://192.168.239.65:5000/data-kriteria/${album.kode}';
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
          // Perbarui tampilan dengan menghapus data dari futureAlbums
          futureAlbums = fetchAlbums();
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

  Future<void> _reloadData() async {
    setState(() {
      futureAlbums = fetchAlbums();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Kriteria'),
      ),
      body: RefreshIndicator(
        onRefresh: _reloadData,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'DATA KRITERIA :',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Album>>(
                future: futureAlbums,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        columnSpacing: 16.0,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                        ),
                        columns: const <DataColumn>[
                          DataColumn(label: Text('Kode')),
                          DataColumn(label: Text('Nama Kriteria')),
                          DataColumn(label: Text('Status')),
                          DataColumn(label: Text('Action')),
                        ],
                        rows: snapshot.data!.map((album) {
                          bool isEven = snapshot.data!.indexOf(album) % 2 == 0;
                          Color rowColor =
                              isEven ? Colors.grey[300]! : Colors.white;

                          return DataRow(
                            color:
                                MaterialStateColor.resolveWith((states) => rowColor),
                            cells: <DataCell>[
                              DataCell(Text(album.kode)),
                              DataCell(Text(album.nama)),
                              DataCell(Text(album.status)),
                              DataCell(Row(
                                children: <Widget>[
                                  Expanded(
                                    child: IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        _editData(album);
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        _deleteData(album);
                                      },
                                    ),
                                  ),
                                ],
                              )),
                            ],
                          );
                        }).toList(),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }

                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddDataPage()),
              );
            },
            child: Icon(Icons.add),
          ),
          SizedBox(height: 16.0),
          FloatingActionButton(
            onPressed: _reloadData,
            child: Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }
}

class EditDataPage extends StatefulWidget {
  final Album album;

  EditDataPage({required this.album});

  @override
  _EditDataPageState createState() => _EditDataPageState();
}

class _EditDataPageState extends State<EditDataPage> {
  late TextEditingController _namaController;
  String _selectedStatus = '';

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.album.nama);
    _selectedStatus = widget.album.status;
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
            decoration: InputDecoration(labelText: 'Nama Kriteria'),
          ),
          DropdownButton<String>(
            value: _selectedStatus,
            onChanged: (String? newValue) {
              setState(() {
                _selectedStatus = newValue!;
              });
            },
            items: <String>['Min', 'Max'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Batal'),
        ),
        TextButton(
          onPressed: () async {
            await _updateData();
            Navigator.of(context).pop();
          },
          child: Text('Simpan'),
        ),
      ],
    );
  }

  Future<void> _updateData() async {
    String url = 'http://192.168.239.65:5000/data-kriteria/${widget.album.kode}';
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    Map<String, dynamic> data = {
      'nama': _namaController.text,
      'status': _selectedStatus,
    };

    try {
      final response = await http.put(Uri.parse(url), headers: headers, body: jsonEncode(data));

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Data berhasil diperbarui'),
          ),
        );
      } else {
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

