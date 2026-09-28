import 'package:flutter/material.dart';
import 'package:todo_app/models/priority.dart';
import 'package:todo_app/models/sort_type.dart';
import 'package:todo_app/models/task.dart';

class TaskProvider extends ChangeNotifier {
  final List<Task> _tasks = [];

  SortType _currentSort = SortType.newest;

  List<Task> get tasks => _tasks;

  SortType get currentSort => _currentSort;

  String? _selectedTag;

  bool _showIncompleteOnly = false;

  bool _showHighPriorityOnly = false;

  void addTask(Task task) {
    _tasks.insert(0, task);

    notifyListeners();
  }

  void toggleTaskCompletion(Task task) {
    task.completed = !task.completed;

    notifyListeners();
  }

  void deleteTask(Task task) {
    _tasks.remove(task);

    notifyListeners();
  }

  void updateTask(Task oldTask, Task updatedTask) {
    int index = _tasks.indexOf(oldTask);

    if (index != -1) {
      _tasks[index] = updatedTask;

      notifyListeners();
    }
  }

  void changeSort(SortType sortType) {
    _currentSort = sortType;

    notifyListeners();
  }

  List<Task> get sortedTasks {
    List<Task> sorted = List.from(_tasks);

    if (_showIncompleteOnly) {
      sorted = sorted.where((task) {
        return !task.completed;
      }).toList();
    }

    if (_showHighPriorityOnly) {
      sorted = sorted.where((task) {
        return task.priority == Priority.high;
      }).toList();
    }

    if (_selectedTag != null) {
      sorted = sorted.where((task) {
        return task.tags.contains(_selectedTag);
      }).toList();
    }

    switch (_currentSort) {
      case SortType.newest:
        return sorted;

      case SortType.alphabetical:
        sorted.sort((a, b) {
          return a.title.toLowerCase().compareTo(b.title.toLowerCase());
        });

        return sorted;

      case SortType.priority:
        sorted.sort((a, b) {
          return getPriorityValue(b.priority)
              .compareTo(getPriorityValue(a.priority));
        });

        return sorted;
    }
  }

  int getPriorityValue(Priority priority) {
    switch (priority) {
      case Priority.high:
        return 3;

      case Priority.medium:
        return 2;

      case Priority.low:
        return 1;
    }
  }

  String? get selectedTag => _selectedTag;

  bool get showIncompleteOnly => _showIncompleteOnly;

  bool get showHighPriorityOnly => _showHighPriorityOnly;

  void changeTagFilter(String? tag) {
    _selectedTag = tag;

    notifyListeners();
  }

  void toggleIncompleteFilter(bool value) {
    _showIncompleteOnly = value;

    notifyListeners();
  }

  void toggleHighPriorityFilter(bool value) {
    _showHighPriorityOnly = value;

    notifyListeners();
  }
}
