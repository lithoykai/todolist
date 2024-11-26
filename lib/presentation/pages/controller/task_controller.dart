import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:todolist/data/models/task_model.dart';
import 'package:todolist/domain/entities/task_entity.dart';
import 'package:todolist/domain/usecase/task/delete_task.dart';
import 'package:todolist/domain/usecase/task/get_tasks.dart';
import 'package:todolist/domain/usecase/task/create_task.dart';
import 'package:todolist/domain/usecase/task/update_task.dart';
import 'package:todolist/infra/failure/failure.dart';

@injectable
class TaskController extends ChangeNotifier {
  final CreateTaskUseCase _createTaskUseCase;
  final GetTasksUseCase _getTasksUseCase;
  final UpdateTaskUseCase _updateTaskUseCase;
  final DeleteTaskUseCase _deleteTaskUseCase;

  TaskController({
    required GetTasksUseCase getTasksUseCase,
    required CreateTaskUseCase createTaskUseCase,
    required DeleteTaskUseCase deleteTaskUseCase,
    required UpdateTaskUseCase updateTaskUseCase,
  })  : _getTasksUseCase = getTasksUseCase,
        _createTaskUseCase = createTaskUseCase,
        _deleteTaskUseCase = deleteTaskUseCase,
        _updateTaskUseCase = updateTaskUseCase;

  List<TaskEntity> _tasks = List.of(<TaskEntity>[]);
  List<TaskEntity> get tasks => _tasks;
  TaskStatus status = TaskStatusIdle();
  int pageStatusNavigator = 0;

  void changeNavigator(int index) {
    pageStatusNavigator = index;
    notifyListeners();
  }

  void setTasks(List<TaskEntity> tasks) {
    _tasks = tasks;
    notifyListeners();
  }

  void addTask(TaskEntity task) {
    _tasks.add(task);
    notifyListeners();
  }

  Future<void> getTasks() async {
    status = TaskStatusLoading();
    final result = await _getTasksUseCase.getTasks();
    result.fold(
      (failure) {
        if (failure is AppFailure) {
          status = TaskStatusError(failure.toString());
        } else {
          status = TaskStatusError('Erro desconhecido');
        }
      },
      (tasks) {
        setTasks(tasks);
        status = TaskStatusIdle();
      },
    );
  }

  Future<void> createTask(TaskModel task) async {
    status = TaskStatusLoading();
    final result = await _createTaskUseCase.call(task);
    result.fold(
      (failure) {
        if (failure is AppFailure) {
          status = TaskStatusError(failure.toString());
        } else {
          status = TaskStatusError('Erro desconhecido');
        }
      },
      (task) {
        addTask(task);
        status = TaskStatusIdle();
      },
    );
  }

  Future<void> deleteTask(TaskEntity task) async {
    status = TaskStatusLoading();
    await _deleteTaskUseCase.call(task.id);
    _tasks.remove(task);
    status = TaskStatusIdle();
    notifyListeners();
  }

  Future<void> updateTask(TaskEntity model) async {
    status = TaskStatusLoading();
    final response = await _updateTaskUseCase.call(model);
    response.fold((l) {
      if (l is AppFailure) {
        status = TaskStatusError(l.toString());
      } else {
        status = TaskStatusError('Erro desconhecido');
      }
    }, (r) {
      final index = _tasks.indexWhere((element) => element.id == model.id);
      _tasks[index] = r;
      status = TaskStatusIdle();
    });

    notifyListeners();
  }
}

abstract class TaskStatus {}

class TaskStatusIdle extends TaskStatus {}

class TaskStatusLoading extends TaskStatus {}

class TaskStatusError extends TaskStatus {
  final String message;
  TaskStatusError(this.message);
}
