import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/teacher_auth_provider.dart';

class ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<TeacherAuthProvider>(context);
    final teacher = authProvider.teacher;

    return RefreshIndicator(
      onRefresh: () async {
        await authProvider.refreshTeacherData();
      },
      child: teacher == null
          ? ListView(
        children: [
          SizedBox(height: 100),
          Center(child: Text("Нет данных учителя")),
        ],
      )
          : ListView(
        padding: EdgeInsets.all(16),
        children: [
          Center(
            child: Text(
              "${teacher.lastName} ${teacher.firstName} ${teacher.middleName}",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 16),
          Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              leading: Icon(Icons.person),
              title: Text(teacher.username),
              subtitle: Text("Класс: ${teacher.teacherClass}"),
            ),
          ),
        ],
      ),
    );
  }
}