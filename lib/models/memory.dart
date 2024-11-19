import 'package:http/http.dart' as http;
import 'dart:convert';

class Memory {
  final String id;
  final String title;
  final String description;
  final DateTime unlockDate;
  final String imagePath;
  final bool isLocked;

  Memory({
    required this.id,
    required this.title,
    required this.description,
    required this.unlockDate,
    required this.imagePath,
    required this.isLocked,
  });

  Future<DateTime> _fetchServerTime() async {
    final response = await http
        .get(Uri.parse('http://worldtimeapi.org/api/timezone/Etc/UTC'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return DateTime.parse(data['utc_datetime']);
    } else {
      throw Exception('Failed to fetch server time');
    }
  }

  /// Checks if the memory can be viewed by comparing the unlockDate with server time
  Future<bool> canView() async {
    try {
      DateTime serverTime = await _fetchServerTime();
      return serverTime.isAfter(unlockDate);
    } catch (error) {
      // Fallback to local time if server call fails
      return DateTime.now().isAfter(unlockDate);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'unlockDate': unlockDate.toIso8601String(),
      'imagePath': imagePath,
      'isLocked': isLocked,
    };
  }

  factory Memory.fromJson(Map<String, dynamic> json) {
    return Memory(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      unlockDate: DateTime.parse(json['unlockDate']),
      imagePath: json['imagePath'],
      isLocked: json['isLocked'],
    );
  }
}
