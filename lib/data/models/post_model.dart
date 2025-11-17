class Post {
  final String id;
  final String title;
  final String description;
  final String image;
  final String user;
  final DateTime sortDate;
  final DateTime date;

  Post({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.user,
    required this.sortDate,
    required this.date,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json["_id"],
      title: json["title"],
      description: json["des"],
      image: json["image"],
      user: json["user"],
      sortDate:
          DateTime.fromMillisecondsSinceEpoch(int.parse(json["sortDate"])),
      date: _parseDate(json["Date"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "title": title,
      "des": description,
      "image": image,
      "user": user,
      "sortDate": sortDate.millisecondsSinceEpoch.toString(),
      "Date": "${date.day}/${date.month}/${date.year}",
    };
  }

  static DateTime _parseDate(String dateString) {
    List<String> parts = dateString.split("/");
    return DateTime(
        int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
  }

  static List<Post> fromJsonList(List jsonList) {
    return jsonList.map((json) => Post.fromJson(json)).toList();
  }
}
