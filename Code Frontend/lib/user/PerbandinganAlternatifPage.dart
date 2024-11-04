import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'HomeUser.dart';

class Kriteria {
  final String kode;
  final String nama;
  final String status;

  Kriteria({
    required this.kode,
    required this.nama,
    required this.status,
  });

  factory Kriteria.fromJson(Map<String, dynamic> json) {
    return Kriteria(
      kode: json['kode'],
      nama: json['nama'],
      status: json['status'],
    );
  }
}

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

Future<List<Kriteria>> fetchKriteria() async {
  final response =
      await http.get(Uri.parse('http://192.168.239.65:5000/data-kriteria'));

  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body)['data'];
    List<Kriteria> kriteriaList =
        data.map((json) => Kriteria.fromJson(json)).toList();
    return kriteriaList;
  } else {
    throw Exception('Failed to load kriteria');
  }
}

Future<bool> cekDataAlternatif(String selectedAlternatif) async {
  final response = await http.get(
    Uri.parse('http://192.168.239.65:5000/lihat-penilaian'),
  );

  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body)['data'];
    for (var item in data) {
      if (item['id_alternatif'] == selectedAlternatif) {
        return true; // Data alternatif sudah ada di API
      }
    }
    return false; // Data alternatif belum ada di API
  } else {
    throw Exception('Failed to fetch data from API');
  }
}

Future<List<Alternatif>> fetchAlternatif() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final userId = prefs.getInt('user_id');
  final response = await http
      .get(Uri.parse('http://192.168.239.65:5000/data-alternatif/$userId'));

  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body)['data'];
    List<Alternatif> alternatifList =
        data.map((json) => Alternatif.fromJson(json)).toList();
    return alternatifList;
  } else {
    throw Exception('Failed to load alternatif');
  }
}

Future<void> sendNilaiPerbandingan(
    BuildContext context,
    Map<String, dynamic> nilaiPerbandingan,
    String selectedAlternatif,
    List<Kriteria> kriteriaList) async {
  try {
    // Cek apakah alternatif sudah ada di API
    bool alternatifExists = await cekDataAlternatif(selectedAlternatif);
    if (alternatifExists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data alternatif sudah ada dan tidak bisa di isi lagi'),
        ),
      );
      return; // Jika sudah ada, hentikan proses pengiriman
    }

    // Ubah data nilaiPerbandingan menjadi JSON string
    String jsonNilaiPerbandingan = jsonEncode(nilaiPerbandingan);

    // Lakukan proses pengiriman nilai perbandingan ke server
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    final response = await http.post(
      Uri.parse('http://192.168.239.65:5000/penilaian'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'id_user': userId,
        'id_alternatif': selectedAlternatif,
        'nilai': jsonNilaiPerbandingan,
      }),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data perbandingan berhasil disimpan'),
        ),
      );
      print('Nilai perbandingan berhasil dikirim ke server');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Terjadi kesalahan saat mengirim nilai perbandingan ke server'),
        ),
      );
      print(response.body);
      print('Terjadi kesalahan saat mengirim nilai perbandingan ke server');
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Terjadi kesalahan saat menghubungi server: $e'),
      ),
    );
    print('Terjadi kesalahan saat menghubungi server: $e');
  }
}

class NilaiPerbandinganPage extends StatefulWidget {
  @override
  _NilaiPerbandinganPageState createState() => _NilaiPerbandinganPageState();
}

class KriteriaData {
  final double value;
  final String text;

  KriteriaData({required this.value, required this.text});
}

class _NilaiPerbandinganPageState extends State<NilaiPerbandinganPage> {
  String selectedAlternatif = '';
  Map<String, double> nilaiPerbandingan = {};

  List<Kriteria> kriteriaList = [];
  List<Alternatif> alternatifList =
      []; // List untuk menyimpan data alternatif dari API

  final List<KriteriaData> kriteriaValueList = [
    KriteriaData(value: 1.0, text: "1"),
    KriteriaData(value: 2.0, text: "2"),
    KriteriaData(value: 3.0, text: "3"),
    KriteriaData(value: 4.0, text: "4"),
    KriteriaData(value: 5.0, text: "5"),
  ];

  @override
  void initState() {
    super.initState();
    fetchKriteriaData();
    fetchAlternatifData();
  }

  Future<void> fetchKriteriaData() async {
    try {
      List<Kriteria> fetchedKriteria = await fetchKriteria();
      setState(() {
        kriteriaList = fetchedKriteria;
      });
    } catch (e) {
      print('Error fetching kriteria data: $e');
      // Handle error jika gagal mengambil data dari API
    }
  }

  Future<void> fetchAlternatifData() async {
    try {
      List<Alternatif> fetchedAlternatif = await fetchAlternatif();
      setState(() {
        alternatifList = fetchedAlternatif;
      });
    } catch (e) {
      print('Error fetching alternatif data: $e');
      // Handle error jika gagal mengambil data dari API
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nilai Perbandingan'),
      ),
      body: Container(
        color: Colors.grey[100],
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 2,
              shadowColor: Colors.grey[400],
              color: Colors.grey[300],
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Pengertian nilai Kriteria\n',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    DropdownButton<String>(
                      hint: Text('Pilih Kriteria'),
                      items: [
                        'Kepadatan Penduduk',
                        'Keamanan dan Kenyamanan',
                        'Aksesibilitas dan Visibilitas',
                        'Infrastruktur dan Usaha Sekitar',
                        'Pertumbuhan Ekonomi Sekitar',
                      ].map((String kriteria) {
                        return DropdownMenuItem<String>(
                          value: kriteria,
                          child: Text(kriteria),
                        );
                      }).toList(),
                      onChanged: (String? selectedKriteria) {
                        if (selectedKriteria != null) {
                          _showKriteriaPengertian(selectedKriteria,
                              getPengertianKriteria(selectedKriteria));
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 2,
              shadowColor: Colors.grey[400],
              color: Colors.grey[300],
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Pilih Alternatif',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16.0),
                    DropdownButton<String>(
                      value: selectedAlternatif.isEmpty
                          ? null
                          : selectedAlternatif,
                      hint: Text('Pilih Alternatif'),
                      items: alternatifList.map((alternatif) {
                        return DropdownMenuItem<String>(
                          value: alternatif.kode,
                          child: Text(alternatif.nama),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedAlternatif = newValue ?? '';
                          // Reset nilai perbandingan untuk kriteria saat alternatif berubah
                          nilaiPerbandingan.clear();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: kriteriaList.length,
                itemBuilder: (context, index) {
                  final kriteria = kriteriaList[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 2,
                    shadowColor: Colors.grey[400],
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            kriteria.nama,
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8.0),
                          DropdownButton<dynamic>(
                            value: nilaiPerbandingan[kriteria.kode],
                            hint: Text('Pilih Nilai Perbandingan'),
                            items: kriteriaValueList.map((nilai) {
                              return DropdownMenuItem<dynamic>(
                                value: nilai.value,
                                child: Text(nilai.text),
                              );
                            }).toList(),
                            onChanged: (dynamic newValue) {
                              setState(() {
                                nilaiPerbandingan[kriteria.kode] =
                                    newValue ?? '';
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                bool allCriteriaFilled = true;
                for (var kriteria in kriteriaList) {
                  if (!nilaiPerbandingan.containsKey(kriteria.kode)) {
                    allCriteriaFilled = false;
                    break;
                  }
                }

                if (!allCriteriaFilled) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('Isi semua nilai kriteria pada alternatif.'),
                    ),
                  );
                  return;
                }

                sendNilaiPerbandingan(context, nilaiPerbandingan,
                    selectedAlternatif, kriteriaList);
              },
              child: Text('Simpan Nilai Perbandingan'),
            ),
            ElevatedButton(
              onPressed: () async {
          
                bool allAlternatifFilled = true;
                for (var alternatif in alternatifList) {
                  if (!await cekDataAlternatif(alternatif.kode)) {
                    allAlternatifFilled = false;
                    break;
                  }
                }

                if (!allAlternatifFilled) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('Isi semua nilai perbandingan pada alternatif.'),
                    ),
                  );
                  return;
                }

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeUser(selectedIndex: 3),
                  ),
                );
              },
              child: Text('Lihat Nilai Score'),
            )
          ],
        ),
      ),
    );
  }

  // Fungsi untuk mendapatkan pengertian kriteria berdasarkan nama kriteria
  String getPengertianKriteria(String kriteria) {
    switch (kriteria) {
      case "Kepadatan Penduduk":
        return "Kepadatan Penduduk:\n• Kepadatan rendah (1 - 70 orang per 500M) = Nilai 1\n• Kepadatan sedang (71 - 200 orang per 500M) = Nilai 2\n• Kepadatan menengah (201 - 400 orang per 500M) = Nilai 3\n• Kepadatan tinggi (401 - 600 orang per 500M) = Nilai 4\n• Kepadatan sangat tinggi (Lebih dari 600 orang per 500M) = Nilai 5";
      case "Keamanan dan Kenyamanan":
        return "Keamanan dan Kenyamanan:\n• Sangat aman dan nyaman = Nilai 5\n• Aman dan cukup nyaman = Nilai 4\n• Cukup aman dan nyaman = Nilai 3\n• Kurang aman dan kurang nyaman = Nilai 2\n• Tidak aman dan tidak nyaman = Nilai 1";
      case "Aksesibilitas dan Visibilitas":
        return "Aksesibilitas dan Visibilitas:\n• Sangat mudah dijangkau dan terlihat = Nilai 5\n• Mudah dijangkau dan terlihat = Nilai 4\n• Cukup mudah dijangkau dan terlihat = Nilai 3\n• Agak sulit dijangkau dan terlihat = Nilai 2\n• Sulit dijangkau dan tidak terlihat dengan baik = Nilai 1";
      case "Infrastruktur dan Usaha Sekitar":
        return "Infrastruktur dan Usaha Sekitar:\n• Fasilitas dan teknologi modern, serta keberadaan bisnis yang mendukung = Nilai 5\n• Fasilitas dan teknologi cukup lengkap, serta keberadaan beberapa bisnis yang mendukung = Nilai 4\n• Fasilitas dan teknologi yang cukup, serta keberadaan beberapa bisnis di sekitar = Nilai 3\n• Fasilitas dan teknologi yang kurang memadai, serta keberadaan beberapa bisnis di sekitar = Nilai 2\n• Fasilitas dan teknologi yang kurang memadai, serta minimnya usaha di sekitar = Nilai 1";
      case "Pertumbuhan Ekonomi Sekitar":
        return "Pertumbuhan Ekonomi Sekitar:\n• Pertumbuhan ekonomi tinggi = Nilai 5\n• Pertumbuhan ekonomi cukup baik = Nilai 4\n• Pertumbuhan ekonomi sedang = Nilai 3\n• Pertumbuhan ekonomi kurang baik = Nilai 2\n• Pertumbuhan ekonomi rendah = Nilai 1";
      default:
        return "";
    }
  }

  // Fungsi untuk menampilkan pop-up dengan pengertian kriteria
  void _showKriteriaPengertian(String judul, String pengertian) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(judul),
          content: Text(pengertian),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Tutup'),
            ),
          ],
        );
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: NilaiPerbandinganPage(),
  ));
}
