import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(MaterialApp(
    home: RegisterPage(),
  ));
}

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  void _register(BuildContext context) async {
    final String apiUrl = 'http://192.168.239.65:5000/register';

    String nama = namaController.text;
    String username = usernameController.text;
    String password = passwordController.text;

    Map<String, dynamic> requestBody = {
      'nama': nama,
      'username': username,
      'password': password,
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      // Registrasi berhasil
      Fluttertoast.showToast(msg: 'Registrasi berhasil!');
      Navigator.pop(context); // Kembali ke halaman sebelumnya setelah registrasi berhasil
    } else {
      // Registrasi gagal
      Fluttertoast.showToast(msg: 'Registrasi gagal. Coba lagi.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: namaController,
              decoration: InputDecoration(
                labelText: 'Nama',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Konfirmasi Password',
              ),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                String nama = namaController.text;
                String username = usernameController.text;
                String password = passwordController.text;
                String confirmPassword = confirmPasswordController.text;

                if (nama.isEmpty || username.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
                  Fluttertoast.showToast(msg: 'Semua data harus diisi.');
                } else if (password != confirmPassword) {
                  Fluttertoast.showToast(msg: 'Password tidak sama.');
                } else {
                  _register(context);
                }
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
