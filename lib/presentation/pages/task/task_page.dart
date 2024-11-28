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
  TaskEntity? task;
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (task == null) {
      final entity = ModalRoute.of(context)!.settings.arguments as TaskEntity;
      setState(() {
        task = entity;
        isLoading = false;
      });
    }
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
            onPressed: () => controller.updateTask(task!).then((value) {
              if (mounted) {
                Navigator.of(context).pop();
              }
            }),
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: ThemeConstants.mediumPadding),
              child: Text('Salvamento automatico!'),
            ),
          ],
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : PopScope(
                canPop: true,
                onPopInvokedWithResult: (didPop, result) async {
                  if (didPop) {
                    await controller.updateTask(task!);
                    return;
                  }
                },
                child: TaskPageForm(
                  task: task!,
                  onSave: automaticSave,
                ),
              ));
  }
}
