import 'package:todolist/data/models/task_model.dart';
import 'package:todolist/domain/entities/task_entity.dart';

abstract interface class ITaskDataSource {
  Future<List<TaskEntity>> getTasks();
  Future<TaskEntity> createTask(TaskModel task);
  Future<TaskEntity> updateTask(TaskModel task);
  Future<String> deleteTask(String id);
}
