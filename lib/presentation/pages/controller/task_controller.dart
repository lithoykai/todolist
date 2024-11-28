import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:injectable/injectable.dart';
import 'package:todolist/data/models/task_model.dart';
import 'package:todolist/domain/entities/task_entity.dart';
import 'package:todolist/domain/usecase/task/delete_task.dart';
import 'package:todolist/domain/usecase/task/get_tasks.dart';
import 'package:todolist/domain/usecase/task/create_task.dart';
import 'package:todolist/domain/usecase/task/update_task.dart';
import 'package:todolist/infra/failure/failure.dart';

@singleton
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
  TaskStatus status = TaskStatusIdle();
  List<TaskEntity> get filteredTasks => _tasks.where((task) {
        if (priorityFilter != 0) {
          return task.isDone == (pageStatusNavigator == 1) &&
              task.priority.index == priorityFilter - 1;
        } else {
          return task.isDone == (pageStatusNavigator == 1);
        }
      }).toList()
        ..sort((a, b) {
          if (priorityFilter != 0) {
            return a.priority.index.compareTo(b.priority.index);
          }
          return b.priority.index.compareTo(a.priority.index);
        });
  int pageStatusNavigator = 0;
  int priorityFilter = 0;
  bool isDonePage = false;

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

  void filterPriority(int priority) {
    priorityFilter = priority;
    notifyListeners();
  }

  Future<void> getTasks() async {
    status = TaskStatusLoading();
    notifyListeners();

    final result = await _getTasksUseCase.getTasks();
    result.fold(
      (failure) {
        if (failure is AppFailure) {
          status = TaskStatusError(failure.toString());
        } else {
          status = TaskStatusError('Erro desconhecido');
        }
        notifyListeners();
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

  Future<void> updateTask(TaskEntity entity) async {
    status = TaskStatusLoading();
    final response = await _updateTaskUseCase.call(entity);
    response.fold((l) {
      if (l is AppFailure) {
        status = TaskStatusError(l.toString());
      } else {
        status = TaskStatusError('Erro desconhecido');
      }
    }, (r) {
      final index = _tasks.indexWhere((element) => element.id == entity.id);
      _tasks[index] = r;
      status = TaskStatusIdle();
    });

    notifyListeners();
  }

  void toggleDone(TaskEntity task) {
    final index = _tasks.indexWhere((element) => element.id == task.id);
    _tasks[index].toggleDone();
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
