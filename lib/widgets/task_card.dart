import 'package:flutter/material.dart';
import 'package:todo_app/models/priority.dart';
import 'package:todo_app/models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onToggleComplete;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const TaskCard({
    super.key,
    required this.task,
    required this.onToggleComplete,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: task.completed ? Colors.green.shade50 : null,

      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              task.title,

              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,

                decoration: task.completed ? TextDecoration.lineThrough : null,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              task.description,

              style: TextStyle(
                decoration: task.completed ? TextDecoration.lineThrough : null,
              ),
            ),

            const SizedBox(height: 8),

            Wrap(
              spacing: 6,

              children: task.tags.map((tag) {
                return Chip(label: Text(tag));
              }).toList(),
            ),

            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: getPriorityColor().withOpacity(0.15),
                  ),

                  child: Text(
                    task.priority.name.toUpperCase(),

                    style: TextStyle(
                      color: getPriorityColor(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Row(
                  children: [
                    IconButton(
                      onPressed: onEdit,

                      icon: const Icon(Icons.edit, color: Colors.blue),
                    ),
                    IconButton(
                      onPressed: onDelete,

                      icon: const Icon(Icons.delete, color: Colors.red),
                    ),

                    Checkbox(
                      value: task.completed,

                      onChanged: (_) {
                        onToggleComplete();
                      },
                    ),

                    const Text('Complete'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color getPriorityColor() {
    switch (task.priority) {
      case Priority.high:
        return Colors.red;

      case Priority.medium:
        return Colors.orange;

      case Priority.low:
        return Colors.green;
    }
  }
}
