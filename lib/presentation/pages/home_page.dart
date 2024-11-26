import 'package:flutter/material.dart';
import 'package:todolist/di/di.dart';
import 'package:todolist/presentation/pages/controller/task_controller.dart';
import 'package:todolist/presentation/pages/home/widgets/button_navigator.dart';
import 'package:todolist/presentation/pages/home/widgets/task_form.dart';

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

  openBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: const TaskForm(),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listas de Tarefas'),
      ),
      body: const SingleChildScrollView(
        child: Column(children: [
          ButtonNavigator(),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openBottomSheet(context),
        shape: const CircleBorder(),
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.tertiary,
        ),
      ),
    );
  }
}
