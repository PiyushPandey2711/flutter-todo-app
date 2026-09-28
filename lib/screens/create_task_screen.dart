import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/priority.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/providers/task_provider.dart';

class CreateTaskScreen extends StatefulWidget {
  final Task? task;

  const CreateTaskScreen({super.key, this.task});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final _titleController = TextEditingController();

  final _descriptionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final List<String> availableTags = [
    'Work',

    'Personal',

    'Health',

    'Learning',

    'Shopping',
  ];
  List<String> selectedTags = [];

  Priority _selectedPriority = Priority.medium;

  @override
  void initState() {
    super.initState();

    if (widget.task != null) {
      _titleController.text = widget.task!.title;

      _descriptionController.text = widget.task!.description;

      _selectedPriority = widget.task!.priority;

      selectedTags = List.from(widget.task!.tags);
    }
  }

  @override
  dispose() {
    _titleController.dispose();

    _descriptionController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Create Task' : 'Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,

                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),

                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Title is required';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,

                maxLines: 4,

                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<Priority>(
                value: _selectedPriority,

                decoration: const InputDecoration(
                  labelText: 'Priority',
                  border: OutlineInputBorder(),
                ),

                items: Priority.values.map((priority) {
                  return DropdownMenuItem(
                    value: priority,

                    child: Text(priority.name.toUpperCase()),
                  );
                }).toList(),

                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedPriority = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),

              const Text(
                'Tags',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              Wrap(
                spacing: 8,

                children: availableTags.map((tag) {
                  return FilterChip(
                    label: Text(tag),

                    selected: selectedTags.contains(tag),

                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          selectedTags.add(tag);
                        } else {
                          selectedTags.remove(tag);
                        }
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,

                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final task = Task(
                        title: _titleController.text,

                        description: _descriptionController.text,

                        priority: _selectedPriority,

                        completed: widget.task?.completed ?? false,

                        createdAt: widget.task?.createdAt ?? DateTime.now(),

                        tags: selectedTags,
                      );

                      final provider = Provider.of<TaskProvider>(
                        context,
                        listen: false,
                      );

                      if (widget.task == null) {
                        provider.addTask(task);
                      } else {
                        provider.updateTask(widget.task!, task);
                      }

                      Navigator.pop(context);
                    }
                  },

                  child: const Text('Save Task'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
