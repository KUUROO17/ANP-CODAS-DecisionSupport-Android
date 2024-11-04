import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../login/login_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class UserData {
  final String username;
  final String name;

  UserData({
    required this.username,
    required this.name,
  });
}

class _ProfilePageState extends State<ProfilePage> {
  Future<UserData>? _userDataFuture;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _userDataFuture = fetchUserData();
  }

  Future<UserData> fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    final response =
        await http.get(Uri.parse('http://192.168.239.65:5000/user/$userId'));
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body)['data'][0];
      return UserData(
        username: responseData['username'],
        name: responseData['nama'],
      );
    } else {
      throw Exception('Failed to load user data');
    }
  }

  void _logout() async {
    bool confirmLogout = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Logout'),
          content: Text('Apakah Anda yakin ingin keluar?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text('Keluar'),
            ),
          ],
        );
      },
    );

    if (confirmLogout == true) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('user_id');
      prefs.remove('token');

      UserData userData = await _userDataFuture!;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Terima kasih telah menggunakan aplikasi kami, ${userData.name}!',
          ),
        ),
      );
    }
  }

  void _showEditPopup(UserData userData) {
    _nameController.text = userData.name;
    _usernameController.text = userData.username;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ubah Data Profil'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nama'),
              ),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Nama Pengguna'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _saveUserData(userData);
              },
              child: Text('Simpan'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Batal'),
            ),
          ],
        );
      },
    );
  }

  void _saveUserData(UserData userData) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id');
      final String apiUrl = 'http://192.168.239.65:5000/user/$userId';

      final Map<String, dynamic> userDataChanges = {
        'name': _nameController.text,
        'username': _usernameController.text,
      };

      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(userDataChanges),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context);
        setState(() {
          _userDataFuture = fetchUserData();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Data profil berhasil diubah'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan saat mengubah data profil'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan saat menghubungi server'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<UserData>(
        future: _userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan saat memuat data'));
          } else {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        SizedBox(
                          width: 150,
                          height: 150,
                          child: CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage:
                                NetworkImage('https://picsum.photos/200/200'),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _showEditPopup(snapshot.data!);
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Nama: ${snapshot.data!.name}',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Username: ${snapshot.data!.username}',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.logout),
                          onPressed: () {
                            _logout();
                          },
                        ),
                        SizedBox(width: 20),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _showEditPopup(snapshot.data!);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ProfilePage(),
  ));
}
