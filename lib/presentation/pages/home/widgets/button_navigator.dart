import 'package:flutter/material.dart';
import 'package:todolist/di/di.dart';
import 'package:todolist/infra/theme/theme_constants.dart';
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                    height: 35,
                    width: 110,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: controller.pageStatusNavigator == 0
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onPrimary,
                      ),
                      onPressed: () => controller.changeNavigator(0),
                      child: Text(
                        'Pendentes',
                        style: TextStyle(
                          fontSize: 12,
                          color: controller.pageStatusNavigator == 0
                              ? Theme.of(context).colorScheme.tertiary
                              : Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: ThemeConstants.padding),
                  SizedBox(
                    height: 35,
                    width: 110,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: controller.pageStatusNavigator == 1
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onPrimary,
                      ),
                      onPressed: () => controller.changeNavigator(1),
                      child: Text(
                        'Concluídas',
                        style: TextStyle(
                          fontSize: 12,
                          color: controller.pageStatusNavigator == 1
                              ? Theme.of(context).colorScheme.tertiary
                              : Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: DropdownButton(
                    autofocus: false,
                    icon: const Icon(Icons.sort_rounded),
                    underline: Container(),
                    items: const [
                      DropdownMenuItem(
                        value: 0,
                        child: Text('Todas'),
                      ),
                      DropdownMenuItem(
                        value: 3,
                        child: Text('Alta'),
                      ),
                      DropdownMenuItem(
                        value: 2,
                        child: Text('Média'),
                      ),
                      DropdownMenuItem(
                        value: 1,
                        child: Text('Baixa'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value == null) return;
                      controller.filterPriority(value);
                    }),
              )
            ],
          );
        });
  }
}
