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
    try {
      print('🧩 [Post] Parsing individual post: ${json["_id"] ?? "unknown"}');
      
      final post = Post(
        id: json["_id"] ?? '',
        title: json["title"] ?? '',
        description: json["des"] ?? '',
        image: json["image"] ?? '',
        user: json["user"] ?? '',
        sortDate: _parseSortDate(json["sortDate"]),
        date: _parseDate(json["Date"]),
      );
      
      print('✅ [Post] Successfully parsed post: ${post.title}');
      return post;
    } catch (e) {
      print('❌ [Post] Error parsing individual post: $e');
      print('🔍 [Post] Raw JSON data: $json');
      rethrow; // Re-throw to be caught by fromJsonList
    }
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

  static DateTime _parseSortDate(dynamic sortDate) {
    try {
      if (sortDate == null || sortDate.toString().isEmpty) {
        return DateTime.now();
      }
      
      // Try to parse as milliseconds first
      if (sortDate is String && sortDate.isNotEmpty) {
        final intValue = int.tryParse(sortDate);
        if (intValue != null) {
          return DateTime.fromMillisecondsSinceEpoch(intValue);
        }
      }
      
      // If it's already a number
      if (sortDate is num) {
        return DateTime.fromMillisecondsSinceEpoch(sortDate.toInt());
      }
      
      // Default to current time if parsing fails
      return DateTime.now();
    } catch (e) {
      print('⚠️  Error parsing sortDate: $sortDate, using current time');
      return DateTime.now();
    }
  }

  static DateTime _parseDate(String? dateString) {
    try {
      if (dateString == null || dateString.isEmpty) {
        return DateTime.now();
      }
      
      List<String> parts = dateString.split("/");
      if (parts.length == 3) {
        return DateTime(
          int.parse(parts[2]), 
          int.parse(parts[1]), 
          int.parse(parts[0])
        );
      }
      
      return DateTime.now();
    } catch (e) {
      print('⚠️  Error parsing date: $dateString, using current time');
      return DateTime.now();
    }
  }

  static List<Post> fromJsonList(List? jsonList) {
    try {
      print('📋 [Post] Starting to parse list of posts...');
      print('🔍 [Post] Input list type: ${jsonList?.runtimeType}');
      print('📊 [Post] Input list length: ${jsonList?.length ?? 0}');
      
      if (jsonList == null || jsonList.isEmpty) {
        print('📝 [Post] Post list is empty or null, returning empty list');
        return [];
      }
      
      final List<Post> posts = [];
      int successful = 0;
      int failed = 0;
      
      for (int i = 0; i < jsonList.length; i++) {
        try {
          final json = jsonList[i];
          print('🔄 [Post] Processing item $i/${jsonList.length}');
          
          if (json == null) {
            print('⚠️  [Post] Item $i is null, skipping');
            failed++;
            continue;
          }
          
          final post = Post.fromJson(json as Map<String, dynamic>);
          posts.add(post);
          successful++;
          print('✅ [Post] Successfully processed item $i');
        } catch (e) {
          print('⚠️  [Post] Error parsing item $i: $e, skipping');
          failed++;
        }
      }
      
      print('📈 [Post] Parsing completed: $successful successful, $failed failed');
      print('✅ [Post] Returning ${posts.length} valid posts');
      return posts;
    } catch (e) {
      print('❌ [Post] Critical error parsing post list: $e');
      print('🔍 [Post] Error stack: ${e.toString()}');
      return [];
    }
  }
}
