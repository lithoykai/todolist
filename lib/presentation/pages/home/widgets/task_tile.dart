import 'package:flutter/material.dart';
import 'package:todolist/domain/entities/task_entity.dart';
import 'package:todolist/infra/theme/theme_constants.dart';
import 'package:todolist/presentation/pages/controller/task_controller.dart';

class TaskTileWidget extends StatelessWidget {
  TaskController controller;
  TaskEntity task;

  TaskTileWidget({super.key, required this.task, required this.controller});

  @override
  Widget build(BuildContext context) {
    _deleteAlert(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Excluir tarefa'),
            content: const Text('Deseja realmente excluir essa tarefa?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Não'),
              ),
              TextButton(
                onPressed: () {
                  controller.deleteTask(task);
                  Navigator.of(context).pop();
                },
                child: const Text('Sim'),
              ),
            ],
          );
        },
      );
    }

    return SizedBox(
      height: 70,
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: priorityColor(task.priority).withAlpha(150),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
            ),
            width: 15,
            height: 70,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: ThemeConstants.halfPadding,
                  vertical: ThemeConstants.halfPadding),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(ThemeConstants.halfPadding),
                    bottomRight: Radius.circular(ThemeConstants.halfPadding)),
                color: Theme.of(context).colorScheme.secondary,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        isSelected: task.isDone,
                        icon: const Icon(Icons.radio_button_off_outlined),
                        selectedIcon: const Icon(Icons.check_circle),
                        onPressed: () => controller.toggleDone(task),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.title.length > 25
                                ? '${task.title.substring(0, 20)}...'
                                : task.title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              decoration: task.isDone
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          const Text(
                            'Ver detalhes',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => _deleteAlert(context),
                    icon: Icon(Icons.delete_outline,
                        color: Theme.of(context).colorScheme.error),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color priorityColor(PriorityStatus priority) {
    switch (priority) {
      case PriorityStatus.low:
        return Colors.green;
      case PriorityStatus.medium:
        return Colors.yellow;
      case PriorityStatus.high:
        return Colors.red;
    }
  }
}
