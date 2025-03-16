import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'profile_tab.dart';
import 'students_tab.dart';
import '../providers/teacher_auth_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    ProfileTab(),
    StudentsTab(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _logout() {
    Provider.of<TeacherAuthProvider>(context, listen: false).logout();
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0 ? "Профиль" : "Ученики"),
        actions: _selectedIndex == 0
            ? [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          )
        ]
            : null,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Профиль",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: "Ученики",
          ),
        ],
      ),
    );
  }
}