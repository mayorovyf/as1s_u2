import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/teacher.dart';
import '../models/student.dart';

class TeacherApiService {
  // Замените baseUrl на адрес вашего backend-сервера
  static const String baseUrl = "http://176.123.167.16:8080";

  // Логин учителя – endpoint /login_user2
  static Future<String?> loginTeacher(String username, String password) async {
    final url = Uri.parse("$baseUrl/login_user2");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"username": username, "password": password}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['api_key'];
      } else {
        print("Ошибка логина учителя: ${response.body}");
      }
    } catch (e) {
      print("Ошибка при запросе логина учителя: $e");
    }
    return null;
  }

  // Получение данных учителя – endpoint /user2_data
  static Future<Teacher?> fetchTeacherData(String apiKey) async {
    final url = Uri.parse("$baseUrl/user2_data");
    try {
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json", "X-API-Key": apiKey},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Teacher.fromJson(data);
      } else {
        print("Ошибка получения данных учителя: ${response.body}");
      }
    } catch (e) {
      print("Ошибка при запросе данных учителя: $e");
    }
    return null;
  }

  // Получение списка учеников – endpoint /get_class_users (POST запрос)
  static Future<List<Student>?> getStudents(String apiKey) async {
    final url = Uri.parse("$baseUrl/get_class_users");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json", "X-API-Key": apiKey},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['users'] != null) {
          List studentsJson = data['users'];
          return studentsJson.map((json) => Student.fromJson(json)).toList();
        }
      } else {
        print("Ошибка получения списка учеников: ${response.body}");
      }
    } catch (e) {
      print("Ошибка при получении списка учеников: $e");
    }
    return null;
  }

  // Добавление ученика в класс – endpoint /add_student
  static Future<bool> addStudent(String apiKey, String studentUsername) async {
    final url = Uri.parse("$baseUrl/add_student");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json", "X-API-Key": apiKey},
        body: jsonEncode({"username": studentUsername}),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        print("Ошибка добавления ученика: ${response.body}");
      }
    } catch (e) {
      print("Ошибка при запросе добавления ученика: $e");
    }
    return false;
  }

  // Обновление QR кода ученика – endpoint /update_qr
  static Future<bool> updateStudentQR(String apiKey, String studentUsername) async {
    final url = Uri.parse("$baseUrl/update_qr");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json", "X-API-Key": apiKey},
        body: jsonEncode({"username": studentUsername}),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        print("Ошибка обновления QR кода ученика: ${response.body}");
      }
    } catch (e) {
      print("Ошибка при запросе обновления QR кода ученика: $e");
    }
    return false;
  }
}