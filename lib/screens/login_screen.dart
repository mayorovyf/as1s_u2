import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/teacher_auth_provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';
  bool _isLoading = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Вход для учителя"),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Логин",
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (value) {
                    _username = value!.trim();
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Введите логин";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Пароль",
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  onSaved: (value) {
                    _password = value!.trim();
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Введите пароль";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                if (_errorMessage != null)
                  Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                SizedBox(height: 16),
                _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: _login,
                  child: Text("Войти"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _login() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final authProvider =
    Provider.of<TeacherAuthProvider>(context, listen: false);
    bool success = await authProvider.login(_username, _password);

    setState(() {
      _isLoading = false;
    });

    if (success) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      setState(() {
        _errorMessage = "Ошибка входа. Проверьте логин и пароль.";
      });
    }
  }
}
