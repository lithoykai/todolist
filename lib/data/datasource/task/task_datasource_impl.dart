import 'package:injectable/injectable.dart';
import 'package:todolist/data/datasource/clients/hive/hive_service.dart';
import 'package:todolist/data/datasource/task/task_datasource_offline.dart';
import 'package:todolist/data/models/task_model.dart';
import 'package:todolist/domain/entities/task_entity.dart';

@Injectable(as: ITaskDataSource)
class TaskDataSourceImpl implements ITaskDataSource {
  final HiveService _hiveService;

  TaskDataSourceImpl({required HiveService hiveService})
      : _hiveService = hiveService;

  @override
  Future<TaskEntity> createTask(TaskModel task) async {
    try {
      final taskEntity = task.toEntity();
      await _hiveService.saveItem("tasks", taskEntity.id, taskEntity);
      return taskEntity;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<TaskEntity>> getTasks() async {
    try {
      return await _hiveService.getAllItems<TaskEntity>("tasks");
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<TaskEntity> updateTask(TaskEntity task) async {
    try {
      await _hiveService.updateItem('tasks', task.id, task);
      return task;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> deleteTask(String id) async {
    try {
      final response = await _hiveService.deleteItem("tasks", id);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
