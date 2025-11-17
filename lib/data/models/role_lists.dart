class RoleLists {
  final String id;
  final String name;
  final String date;
  final String city;
  final String telegram;
  final String idCard;
  final String? uni;
  final String? phone;
  final String? email;
  final String? age;
  final String? gender;
  final String? zone;

  RoleLists({
    required this.id,
    required this.name,
    required this.date,
    required this.city,
    required this.telegram,
    required this.idCard,
    this.uni,
    this.phone,
    this.email,
    this.age,
    this.gender,
    this.zone,
  });

  // تحويل من JSON إلى كائن Dart
  factory RoleLists.fromJson(Map<String, dynamic> json) {
    return RoleLists(
        id: json['_id']?.toString() ?? json['id'] ?? '',
        name: json['name'] ?? '',
        date: json['role_req_date'] ?? json['Date'] ?? '',
        city: json['city'] ?? '',
        telegram: json['telegram'] ?? '',
        idCard: json['id_card'] ?? '',
        uni: json['uni'],
        phone: json['phone'],
        email: json['email'],
        age: json['age']?.toString(),
        gender: json['gender'],
        zone: json['zone']);
  }

  // تحويل من كائن Dart إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'Date': date,
      'city': city,
      'telegram': telegram,
      'id_card': idCard,
      'uni': uni,
      'phone': phone,
      'email': email,
      'age': age,
      'gender': gender,
      'zone': zone,
    };
  }

  static List<RoleLists> fromJsonList(List jsonList) {
    return jsonList.map((json) => RoleLists.fromJson(json)).toList();
  }
}
