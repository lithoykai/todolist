import 'package:flutter/material.dart';
import 'package:todolist/di/di.dart';
import 'package:todolist/presentation/pages/controller/task_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = getIt<TaskController>();
  @override
  void initState() {
    controller.getTasks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: Container(),
    );
  }
}
