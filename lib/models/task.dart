import 'priority.dart';

class Task {
  String title;

  String description;

  Priority priority;

  bool completed;

  DateTime createdAt;

  List<String> tags = [];

  Task({
    required this.title,
    required this.description,
    required this.priority,
    this.completed = false,
    required this.tags,
    required this.createdAt,
  });
}
