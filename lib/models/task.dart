import 'dart:convert';
import 'package:getx/models/subtask.dart';

class Task {
  Task({this.id = '', required this.title, List<Subtask>? subtasks})
      : subtasks = subtasks ?? <Subtask>[];

  String id;
  String title;
  final List<Subtask> subtasks;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subtasks': subtasks.map((s) => s.toMap()).toList(),
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    final rawsubtasks = (map['subtasks'] as List<dynamic>?) ?? const [];
    return Task(
      id: (map['id'] ?? '').toString(),
      title: (map['title'] ?? '').toString(),
      subtasks: rawsubtasks
          .whereType<Map>()
          .map((m) => Subtask.fromMap(Map<String, dynamic>.from(m)))
          .toList(),
    );
  }

  String toJson() => jsonEncode(toMap());

  factory Task.fromJson(String source) =>
      Task.fromMap(jsonDecode(source) as Map<String, dynamic>);
}
