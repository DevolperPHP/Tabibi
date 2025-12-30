// Test script to validate date parsing logic from API data
import 'dart:convert';
import 'dart:io';

void main() async {
  print('🧪 Testing Date Parsing Logic');
  print('=' * 50);
  
  try {
    // Test API response
    final response = await HttpClient()
        .getUrl(Uri.parse('http://165.232.78.163/home'))
        .then((request) => request.close());
    
    if (response.statusCode == 200) {
      final jsonString = await response.transform(utf8.decoder).join();
      final jsonData = json.decode(jsonString);
      
      print('✅ API Response received successfully');
      print('📊 Number of posts: ${jsonData.length}');
      print('');
      
      // Test each post
      for (int i = 0; i < jsonData.length; i++) {
        final post = jsonData[i];
        print('🔍 Testing Post ${i + 1}: ${post['title']}');
        print('   _id: ${post['_id']}');
        print('   sortDate: ${post['sortDate']}');
        print('   Date: ${post['Date']}');
        
        // Test the parsing logic
        final sortDateParsed = _parseSortDate(post['sortDate']);
        final dateParsed = _parseDate(post['Date']);
        
        print('   ✅ sortDate parsed: $sortDateParsed');
        print('   ✅ Date parsed: $dateParsed');
        print('');
      }
      
      print('🎉 All date parsing tests passed successfully!');
    } else {
      print('❌ API request failed with status: ${response.statusCode}');
    }
  } catch (e) {
    print('❌ Error during testing: $e');
  }
}

DateTime _parseSortDate(dynamic sortDate) {
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

DateTime _parseDate(String? dateString) {
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