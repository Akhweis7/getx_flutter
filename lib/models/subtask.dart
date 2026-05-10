/// Subtask model.
///
/// Represents a single item inside a kanban column ([Task]).
/// Carries the title, the username of the creator, and the creation date.
/// Provides JSON / Map (de)serialization so subtasks can be persisted or
/// transferred over the network.
library;

import 'dart:convert';

class Subtask {
  Subtask({required this.title, String? username, DateTime? date})
    : username = username ?? '',
      date = date ?? DateTime.now();

  String title;
  String username;
  DateTime date;

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'username': username,
      'date': date.toIso8601String(),
    };
  }

  factory Subtask.fromMap(Map<String, dynamic> map) {
    final rawdate = map['date'];
    DateTime? parseddate;
    if (rawdate is String && rawdate.isNotEmpty) {
      parseddate = DateTime.tryParse(rawdate);
    } else if (rawdate is DateTime) {
      parseddate = rawdate;
    }
    return Subtask(
      title: (map['title'] ?? '').toString(),
      username: (map['username'] ?? '').toString(),
      date: parseddate,
    );
  }

  String toJson() => jsonEncode(toMap());

  factory Subtask.fromJson(String source) =>
      Subtask.fromMap(jsonDecode(source) as Map<String, dynamic>);
}
