import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todolist/di/di.dart';
import 'package:todolist/presentation/pages/controller/task_controller.dart';

class ButtonNavigator extends StatelessWidget {
  const ButtonNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = getIt<TaskController>();
    return ListenableBuilder(
        listenable: controller,
        builder: (context, child) {
          return Row(
            children: [
              ElevatedButton(
                onPressed: () => controller.changeNavigator(0),
                child: const Text('Pendentes'),
              ),
              ElevatedButton(
                onPressed: () => controller.changeNavigator(1),
                child: const Text('Concluidas'),
              ),
            ],
          );
        });
  }
}
