import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/teacher_auth_provider.dart';
import '../models/student.dart';

class StudentsTab extends StatelessWidget {
  // Функция форматирования даты и времени
  String formatDateTime(DateTime dt) {
    return DateFormat("dd.MM.yyyy HH:mm").format(dt);
  }

  // Функция, возвращающая 5 последних посещений в перевёрнутом порядке (самый последний сверху)
  List<DateTime> _getLastFiveVisits(List<DateTime> times) {
    List<DateTime> lastFive;
    if (times.length <= 5) {
      lastFive = List.from(times);
    } else {
      lastFive = times.sublist(times.length - 5);
    }
    return lastFive.reversed.toList();
  }

  // Функция вычисления последнего посещения на основе истории посещений.
  // Если история пуста, используется значение student.lastUsedAt.
  DateTime getLatestVisit(Student student) {
    if (student.times.isNotEmpty) {
      return student.times.reduce((a, b) => a.isAfter(b) ? a : b);
    } else {
      return student.lastUsedAt;
    }
  }

  @override
  Widget build(BuildContext context) {
    final teacherProvider = Provider.of<TeacherAuthProvider>(context);
    List<Student> students = teacherProvider.students;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddStudentDialog(context, teacherProvider);
        },
        child: Icon(Icons.add),
        tooltip: "Добавить ученика",
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await teacherProvider.fetchStudents();
        },
        child: students.isEmpty
            ? ListView(
          children: [
            SizedBox(height: 100),
            Center(child: Text("Ученики не найдены")),
          ],
        )
            : ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: students.length,
          itemBuilder: (context, index) {
            Student student = students[index];
            DateTime latestVisit = getLatestVisit(student);
            return Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                onTap: () {
                  _showStudentDetails(context, student, teacherProvider);
                },
                title: Text(
                  "${student.lastName} ${student.firstName} ${student.middleName}",
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Логин: ${student.username}"),
                    Text("Класс: ${student.studentClass}"),
                    Text("QR код: " +
                        (student.used ? "использован" : "не использован")),
                    Text("Последнее посещение: ${formatDateTime(latestVisit)}"),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.qr_code, color: Colors.blue),
                  onPressed: () async {
                    bool res = await teacherProvider.updateStudentQR(student.username);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(res ? "QR код обновлён" : "Ошибка обновления QR"),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showAddStudentDialog(context, teacherProvider) {
    final _formKey = GlobalKey<FormState>();
    String studentUsername = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Добавить ученика"),
          content: Form(
            key: _formKey,
            child: TextFormField(
              decoration: InputDecoration(
                labelText: "Логин ученика",
                border: OutlineInputBorder(),
              ),
              onSaved: (value) {
                studentUsername = value!.trim();
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Введите логин ученика";
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              child: Text("Отмена"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text("Добавить"),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  bool success = await teacherProvider.addStudent(studentUsername);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(success ? "Ученик добавлен" : "Ошибка добавления ученика"),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  // Функция показа BottomSheet с полными данными ученика
  void _showStudentDetails(BuildContext context, Student student, teacherProvider) {
    DateTime latestVisit = getLatestVisit(student);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // позволяет растягивать BottomSheet
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.5,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          builder: (BuildContext context, ScrollController scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // "Хэндлер" для перемещения BottomSheet
                    Center(
                      child: Container(
                        width: 50,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "${student.lastName} ${student.firstName} ${student.middleName}",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.person),
                      title: Text("Логин"),
                      subtitle: Text(student.username),
                    ),
                    ListTile(
                      leading: Icon(Icons.class_),
                      title: Text("Класс"),
                      subtitle: Text(student.studentClass),
                    ),
                    ListTile(
                      leading: Icon(Icons.access_time),
                      title: Text("Последнее посещение"),
                      subtitle: Text(formatDateTime(latestVisit)),
                    ),
                    if (student.times.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "История посещений (последние 5):",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4),
                            ..._getLastFiveVisits(student.times)
                                .map((time) => Text(formatDateTime(time))),
                          ],
                        ),
                      ),
                    SizedBox(height: 16),
                    Center(
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.refresh),
                        label: Text("Обновить QR код"),
                        onPressed: () async {
                          bool res = await teacherProvider.updateStudentQR(student.username);
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(res ? "QR код обновлён" : "Ошибка обновления QR"),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}