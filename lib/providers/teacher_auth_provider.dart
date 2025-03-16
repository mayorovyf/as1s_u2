import 'package:flutter/material.dart';
import '../models/teacher.dart';
import '../models/student.dart';
import '../services/teacher_api_service.dart';

class TeacherAuthProvider with ChangeNotifier {
  Teacher? _teacher;
  String _apiKey = '';
  List<Student> _students = [];

  Teacher? get teacher => _teacher;
  List<Student> get students => _students;
  bool get isAuthenticated => _apiKey.isNotEmpty;

  // Функция логина: получает API ключ, затем данные учителя и список учеников
  Future<bool> login(String username, String password) async {
    try {
      String? apiKey = await TeacherApiService.loginTeacher(username, password);
      if (apiKey != null && apiKey.isNotEmpty) {
        _apiKey = apiKey;
        Teacher? fetchedTeacher = await TeacherApiService.fetchTeacherData(_apiKey);
        if (fetchedTeacher != null) {
          _teacher = fetchedTeacher;
          await fetchStudents();
          notifyListeners();
          return true;
        }
      }
    } catch (e) {
      print("Ошибка при логине учителя: $e");
    }
    return false;
  }

  // Обновление данных учителя
  Future<void> refreshTeacherData() async {
    if (_apiKey.isNotEmpty) {
      Teacher? fetchedTeacher = await TeacherApiService.fetchTeacherData(_apiKey);
      if (fetchedTeacher != null) {
        _teacher = fetchedTeacher;
        notifyListeners();
      }
    }
  }

  // Получение списка учеников для класса учителя
  Future<void> fetchStudents() async {
    if (_apiKey.isNotEmpty) {
      List<Student>? fetchedStudents = await TeacherApiService.getStudents(_apiKey);
      if (fetchedStudents != null) {
        _students = fetchedStudents;
        notifyListeners();
      }
    }
  }

  // Добавление ученика по логину
  Future<bool> addStudent(String studentUsername) async {
    if (_apiKey.isEmpty) return false;
    bool result = await TeacherApiService.addStudent(_apiKey, studentUsername);
    if (result) {
      await fetchStudents();
    }
    return result;
  }

  // Обновление QR кода ученика
  Future<bool> updateStudentQR(String studentUsername) async {
    if (_apiKey.isEmpty) return false;
    bool result = await TeacherApiService.updateStudentQR(_apiKey, studentUsername);
    if (result) {
      await fetchStudents();
    }
    return result;
  }

  void logout() {
    _teacher = null;
    _apiKey = '';
    _students = [];
    notifyListeners();
  }
}