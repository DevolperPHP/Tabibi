import 'package:intl/intl.dart';

class DoctorCase {
  final String id;
  final String name;
  final String userId;
  final bool hasBP;
  final bool isDiabetic;
  final bool toothRemoved;
  final bool hasTF;
  final String image;
  final String diagnose;
  final String note;
  final String status;
  final DateTime date;
  final int sortedDate;

  DoctorCase({
    required this.id,
    required this.name,
    required this.userId,
    required this.hasBP,
    required this.isDiabetic,
    required this.toothRemoved,
    required this.hasTF,
    required this.image,
    required this.diagnose,
    required this.note,
    required this.status,
    required this.date,
    required this.sortedDate,
  });

  factory DoctorCase.fromJson(Map<String, dynamic> json) {
    return DoctorCase(
      id: json['_id'],
      name: json['name'],
      userId: json['userId'],
      diagnose: json['diagnose'] ?? 'غير مشخص',
      hasBP: json['bp'] == 'yes',
      isDiabetic: json['diabetic'] == 'yes',
      toothRemoved: json['toothRemoved'] == 'yes',
      hasTF: json['tf'] == 'yes',
      image: json['image'],
      note: json['note'],
      status: json['status'],
      date: _parseDate(json['Date']),
      sortedDate:
          _parseInt(json['sortedDate'] ?? json['startSortedDate'] ?? '1'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'userId': userId,
      'bp': hasBP ? 'yes' : 'no',
      'diabetic': isDiabetic ? 'yes' : 'no',
      'toothRemoved': toothRemoved ? 'yes' : 'no',
      'tf': hasTF ? 'yes' : 'no',
      'image': image,
      'note': note,
      'status': status,
      'Date': DateFormat('dd/MM/yyyy').format(date),
      'sortedDate': sortedDate,
    };
  }

  static DateTime _parseDate(String dateString) {
    try {
      return DateFormat('dd/MM/yyyy').parse(dateString);
    } catch (e) {
      throw FormatException('Invalid date format: $dateString');
    }
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    throw FormatException('Invalid integer format: $value');
  }

  static List<DoctorCase> fromJsonList(List jsonList) {
    return jsonList.map((json) => DoctorCase.fromJson(json)).toList();
  }
}
