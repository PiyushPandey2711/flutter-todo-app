import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/sort_type.dart';
import 'package:todo_app/providers/task_provider.dart';
import 'package:todo_app/screens/create_task_screen.dart';
import 'package:todo_app/widgets/task_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Task Manager'),

        actions: [
          Consumer<TaskProvider>(
            builder: (context, provider, child) {
              return DropdownButton<SortType>(
                value: provider.currentSort,

                underline: const SizedBox(),

                items: SortType.values.map((sortType) {
                  return DropdownMenuItem(
                    value: sortType,

                    child: Text(sortType.name),
                  );
                }).toList(),

                onChanged: (value) {
                  if (value != null) {
                    provider.changeSort(value);
                  }
                },
              );
            },
          ),
        ],
      ),

      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          if (taskProvider.tasks.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Icon(Icons.task_alt, size: 80),

                  SizedBox(height: 16),

                  Text('No Tasks Available'),
                ],
              ),
            );
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),

                child: DropdownButtonFormField<String?>(
                  value: taskProvider.selectedTag,

                  decoration: const InputDecoration(
                    labelText: 'Filter By Tag',
                    border: OutlineInputBorder(),
                  ),

                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('All Tags'),
                    ),

                    ...[
                      'Work',
                      'Personal',
                      'Health',
                      'Learning',
                      'Shopping',
                    ].map((tag) {
                      return DropdownMenuItem(value: tag, child: Text(tag));
                    }),
                  ],

                  onChanged: (value) {
                    taskProvider.changeTagFilter(value);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),

                child: Row(
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text('Incomplete'),

                        value: taskProvider.showIncompleteOnly,

                        onChanged: (value) {
                          taskProvider.toggleIncompleteFilter(value ?? false);
                        },
                      ),
                    ),

                    Expanded(
                      child: CheckboxListTile(
                        title: const Text('High Priority'),

                        value: taskProvider.showHighPriorityOnly,

                        onChanged: (value) {
                          taskProvider.toggleHighPriorityFilter(value ?? false);
                        },
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: ListView.builder(
                  itemCount: taskProvider.sortedTasks.length,

                  itemBuilder: (context, index) {
                    final task = taskProvider.sortedTasks[index];

                    return TaskCard(
                      task: task,

                      onToggleComplete: () {
                        Provider.of<TaskProvider>(
                          context,
                          listen: false,
                        ).toggleTaskCompletion(task);
                      },

                      onDelete: () {
                        showDialog(
                          context: context,

                          builder: (dialogContext) {
                            return AlertDialog(
                              title: const Text('Delete Task'),

                              content: const Text(
                                'Are you sure you want to delete this task?',
                              ),

                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(dialogContext);
                                  },

                                  child: const Text('Cancel'),
                                ),

                                ElevatedButton(
                                  onPressed: () {
                                    Provider.of<TaskProvider>(
                                      context,
                                      listen: false,
                                    ).deleteTask(task);

                                    Navigator.pop(dialogContext);
                                  },

                                  child: const Text('Delete'),
                                ),
                              ],
                            );
                          },
                        );
                      },

                      onEdit: () {
                        Navigator.push(
                          context,

                          MaterialPageRoute(
                            builder: (context) => CreateTaskScreen(task: task),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateTaskScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
