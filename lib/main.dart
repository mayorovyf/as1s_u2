import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/teacher_auth_provider.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TeacherAuthProvider()),
      ],
      child: TeacherApp(),
    ),
  );
}

class TeacherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Teacher App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}