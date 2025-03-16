class Student {
  final String firstName;
  final String middleName;
  final String lastName;
  final String username;
  final String studentClass; // соответствует полю "class" из JSON
  final String classID;
  final String qr;
  final DateTime lastUsedAt;
  final bool used;
  final bool inBuilding;
  final String apiKey;
  final List<DateTime> times;

  Student({
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.username,
    required this.studentClass,
    required this.classID,
    required this.qr,
    required this.lastUsedAt,
    required this.used,
    required this.inBuilding,
    required this.apiKey,
    required this.times,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    DateTime parsedLastUsedAt;
    try {
      parsedLastUsedAt = DateTime.parse(json['last_used_at'].toString());
    } catch (e) {
      parsedLastUsedAt = DateTime.now();
    }
    List<DateTime> timesList = [];
    if (json['times'] != null && json['times'] is List) {
      timesList = (json['times'] as List).map((item) {
        try {
          return DateTime.parse(item.toString());
        } catch (e) {
          return DateTime.now();
        }
      }).toList();
    }
    return Student(
      firstName: json['first_name'] ?? '',
      middleName: json['middle_name'] ?? '',
      lastName: json['last_name'] ?? '',
      username: json['username'] ?? '',
      studentClass: json['class'] ?? '',
      classID: json['class_id'] ?? '',
      qr: json['qr'] ?? '',
      lastUsedAt: parsedLastUsedAt,
      used: json['used'] ?? false,
      inBuilding: json['in_building'] ?? false,
      apiKey: json['api_key'] ?? '',
      times: timesList,
    );
  }
}