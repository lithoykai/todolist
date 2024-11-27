import 'package:flutter/material.dart';
import 'package:todolist/di/di.dart';
import 'package:todolist/domain/entities/task_entity.dart';
import 'package:todolist/infra/theme/theme_constants.dart';
import 'package:todolist/presentation/pages/controller/task_controller.dart';
import 'package:todolist/presentation/pages/task/form/task_page_form.dart';

class TaskPage extends StatefulWidget {
  TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final controller = getIt<TaskController>();
  late TaskEntity task;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    TaskEntity entity =
        ModalRoute.of(context)!.settings.arguments as TaskEntity;
    setState(() {
      task = entity;
    });
  }

  void automaticSave(TaskEntity newTask) {
    setState(() {
      task = newTask;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => controller.updateTask(task).then(
                  (value) => Navigator.of(context).pop(),
                ),
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: ThemeConstants.mediumPadding),
              child: Text('Salvamento automatico!'),
            ),
          ],
        ),
        body: TaskPageForm(
          task: task,
          onSave: automaticSave,
        ));
  }
}
