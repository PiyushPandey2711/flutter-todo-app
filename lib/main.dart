import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/task_provider.dart';
import 'package:todo_app/screens/home_screen.dart';

void main() {
  runApp(const SmartTaskManagerApp());
}

class SmartTaskManagerApp extends StatelessWidget {
  const SmartTaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Smart Task Manager',
        home: HomeScreen(),
      ),
    );
  }
}
