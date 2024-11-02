import 'package:flutter/material.dart';
import 'ProfilePage.dart';
import 'Result.dart';
import 'bottom_navigation.dart';
import 'HomeDataAlternatif.dart';
import 'perhitungan.dart';
import 'HomePageUser.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeUser(selectedIndex: 3), // Atur selectedIndex sesuai kebutuhan
    );
  }
}

class HomeUser extends StatefulWidget {
  final int selectedIndex;

  HomeUser({required this.selectedIndex});

  @override
  _HomeUserState createState() => _HomeUserState();
}


class _HomeUserState extends State<HomeUser> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.selectedIndex;
  }

  final List<Widget> _pages = [
    HomePageUserPerkenalan(),
    HomeDataAlternatif(),
    DataPerAlternatifPage(),
    NilaiScorePage(), 
    ProfilePage(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'lib/assets/logo3.png', // Ubah sesuai path gambar Anda
              height: 60, // Ubah ukuran gambar sesuai keinginan
            ),
            SizedBox(width: 0), // Spasi antara logo dan judul
            Text(
              'MITA TEMPAT',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
        automaticallyImplyLeading: false, // Hilangkan tombol kembali
      ),
    ),
    body: _pages[_currentIndex],
    bottomNavigationBar: BottomNavigation(
      currentIndex: _currentIndex,
      onTabTapped: _onTabTapped,
    ),
  );
}

}
