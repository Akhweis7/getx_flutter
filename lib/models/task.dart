import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:getx/models/subtask.dart';

class Task {
  Task({required this.title, List<Subtask>? subtasks})
    : subtasks = subtasks ?? <Subtask>[];

  String title;
  final List<Subtask> subtasks;

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subtasks': subtasks.map((s) => s.toMap()).toList(),
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    final rawsubtasks = (map['subtasks'] as List<dynamic>?) ?? const [];
    return Task(
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

  static Future<List<Task>> fetchFromApi(
    String url, {
    Map<String, String>? headers,
    http.Client? client,
  }) async {
    final httpclient = client ?? http.Client();
    try {
      final response = await httpclient.get(Uri.parse(url), headers: headers);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw HttpException(
          'GET $url failed with status ${response.statusCode}',
        );
      }
      final decoded = jsonDecode(response.body);
      if (decoded is List) {
        return decoded
            .whereType<Map>()
            .map((m) => Task.fromMap(Map<String, dynamic>.from(m)))
            .toList();
      }
      if (decoded is Map && decoded['tasks'] is List) {
        return (decoded['tasks'] as List)
            .whereType<Map>()
            .map((m) => Task.fromMap(Map<String, dynamic>.from(m)))
            .toList();
      }
      throw const FormatException(
        'Unexpected response format: expected a JSON array or { "tasks": [...] }',
      );
    } finally {
      if (client == null) {
        httpclient.close();
      }
    }
  }

  static const List<String> _sampletitles = [
    'Backlog',
    'To Do',
    'In Progress',
    'Code Review',
    'Testing',
    'Blocked',
    'Done',
    'Released',
    'Ideas',
    'Archive',
  ];

  static List<Task> sampleList({int? seed}) {
    final random = Random(seed);
    return List<Task>.generate(_sampletitles.length, (index) {
      final subtaskcount = random.nextInt(12) + 1;
      final subtasks = List<Subtask>.generate(
        subtaskcount,
        (i) => Subtask(title: '${_sampletitles[index]} item ${i + 1}'),
      );
      return Task(title: _sampletitles[index], subtasks: subtasks);
    });
  }
}

class HttpException implements Exception {
  const HttpException(this.message);
  final String message;
  @override
  String toString() => 'HttpException: $message';
}
