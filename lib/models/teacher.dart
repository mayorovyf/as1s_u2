class Teacher {
  final String firstName;
  final String middleName;
  final String lastName;
  final String username;
  final String teacherClass; // соответствует полю "class" из JSON
  final String classID;
  final String qr;
  final bool used;
  final bool inBuilding;
  final String apiKey;

  Teacher({
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.username,
    required this.teacherClass,
    required this.classID,
    required this.qr,
    required this.used,
    required this.inBuilding,
    required this.apiKey,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      firstName: json['first_name'] ?? '',
      middleName: json['middle_name'] ?? '',
      lastName: json['last_name'] ?? '',
      username: json['username'] ?? '',
      teacherClass: json['class'] ?? '',
      classID: json['class_id'] ?? '',
      qr: json['qr'] ?? '',
      used: json['used'] ?? false,
      inBuilding: json['in_building'] ?? false,
      apiKey: json['api_key'] ?? '',
    );
  }
}