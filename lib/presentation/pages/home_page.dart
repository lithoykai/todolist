import 'package:flutter/material.dart';
import 'package:todolist/di/di.dart';
import 'package:todolist/domain/entities/task_entity.dart';
import 'package:todolist/infra/routers/app_routers.dart';
import 'package:todolist/infra/theme/theme_constants.dart';
import 'package:todolist/presentation/pages/controller/task_controller.dart';
import 'package:todolist/presentation/pages/home/widgets/button_navigator.dart';
import 'package:todolist/presentation/pages/home/widgets/state/empty_list.dart';
import 'package:todolist/presentation/pages/home/widgets/state/task_error.dart';
import 'package:todolist/presentation/pages/home/widgets/task_form.dart';
import 'package:todolist/presentation/pages/home/widgets/task_tile.dart';

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
      floatingActionButton: FloatingActionButton(
        onPressed: () => openBottomSheet(context),
        shape: const CircleBorder(),
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.tertiary,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: ThemeConstants.padding),
          child: Column(children: [
            const ButtonNavigator(),
            const SizedBox(
              height: ThemeConstants.padding,
            ),
            ListenableBuilder(
                listenable: controller,
                builder: (ctx, child) {
                  if (controller.status is TaskStatusLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (controller.status is TaskStatusError) {
                    return const TaskErrorWidget();
                  } else if (controller.filteredTasks.isEmpty) {
                    return const EmptyList();
                  } else if (controller.priorityFilter != 0 &&
                      controller.filteredTasks.isEmpty) {
                    return Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: ThemeConstants.halfPadding),
                        child: Text(
                            'Filtrado por prioridade: ${PriorityStatus.values[controller.priorityFilter - 1].name}'),
                      ),
                      const EmptyList()
                    ]);
                  }
                  return Column(
                    children: [
                      controller.priorityFilter != 0
                          ? Padding(
                              padding: const EdgeInsets.only(
                                  bottom: ThemeConstants.halfPadding),
                              child: Text(
                                  'Filtrado por prioridade: ${PriorityStatus.values[controller.priorityFilter - 1].name}'),
                            )
                          : const SizedBox(),
                      ListView.separated(
                          separatorBuilder: (ctx, index) => const SizedBox(
                                height: 10,
                              ),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.filteredTasks.length,
                          itemBuilder: (ctx, index) {
                            TaskEntity task = controller.filteredTasks[index];
                            return GestureDetector(
                              onTap: () => Navigator.of(context).pushNamed(
                                  AppRouters.TASKDETAIL,
                                  arguments: task),
                              child: TaskTileWidget(
                                task: task,
                                controller: controller,
                              ),
                            );
                          }),
                    ],
                  );
                }),
          ]),
        ),
      ),
    );
  }
}
