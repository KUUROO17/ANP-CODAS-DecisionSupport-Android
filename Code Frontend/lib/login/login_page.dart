import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:belajar_api/user/HomeUser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'register_page.dart';
import 'package:belajar_api/admin/HomeAdmin.dart';
import 'package:belajar_api/HomePage.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _login(BuildContext context) async {
    final String apiUrl = 'http://192.168.239.65:5000/login';
    final Map<String, String> data = {
      'username': usernameController.text,
      'password': passwordController.text,
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      int userId = responseData['id_user'];
      String nama = responseData['nama'];
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setInt("user_id", userId);
      preferences.setString("nama", nama);
      int rule = responseData['rule'];
      Fluttertoast.showToast(msg: 'Login berhasil');
      // Jika login berhasil, pindah ke halaman HomeUser dan kirim userId sebagai argumen
      if (rule == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeAdmin()),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeUser(selectedIndex: 0)),
        );
      }
    } else if (response.statusCode == 401) {
      Fluttertoast.showToast(msg: 'Password salah');
    } else if (response.statusCode == 404) {
      Fluttertoast.showToast(msg: 'Username tidak ditemukan');
    } else {
      Fluttertoast.showToast(msg: 'Terjadi kesalahan saat login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Navigasi ke halaman HomePage.dart
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                _login(context);
              },
              child: Text('Login'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Pindah ke halaman RegisterPage ketika tombol Register ditekan
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RegisterPage()));
              },
              child: Text('Register'),
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
    // Ganti 'nilaiUserId' dengan nilai ID user yang benar dari respons API login
    return MaterialApp(
      title: 'My App',
      home: LoginPage(),
      routes: {
        '/home': (context) => HomeUser(selectedIndex: 0),
        '/register': (context) => RegisterPage(),
      },
    );
  }
}
