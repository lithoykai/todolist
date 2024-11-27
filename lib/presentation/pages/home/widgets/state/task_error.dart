import 'package:flutter/material.dart';
import 'package:todolist/di/di.dart';
import 'package:todolist/infra/theme/theme_constants.dart';
import 'package:todolist/presentation/pages/controller/task_controller.dart';

class TaskErrorWidget extends StatelessWidget {
  const TaskErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = getIt<TaskController>();
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 200,
            child: Image.asset('assets/images/error.png'),
          ),
          const SizedBox(height: ThemeConstants.padding),
          const Text('Ops! Parece que aconteceu um erro!'),
          ElevatedButton(
              onPressed: () => controller.getTasks(),
              child: const Text('Tentar novamente'))
        ],
      ),
    );
  }
}
