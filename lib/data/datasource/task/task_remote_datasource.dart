import 'package:todolist/data/datasource/clients/hive/hive_service.dart';
import 'package:todolist/data/datasource/clients/http/http_service.dart';
import 'package:todolist/data/datasource/task/task_datasource.dart';
import 'package:todolist/data/models/task_model.dart';
import 'package:todolist/domain/entities/task_entity.dart';
import 'package:todolist/domain/entities/user/user_entity.dart';

class TaskRemoteDatasource implements ITaskDataSource {
  HttpService _http;
  HiveService _hive;
  TaskRemoteDatasource({required HttpService http, required HiveService hive})
      : _http = http,
        _hive = hive;

  @override
  Future<TaskEntity> createTask(TaskModel task) async {
    try {
      final response = await _http.post('task/create', task.toJson());
      final result = TaskModel.fromJson(response.data).toEntity();
      return result;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> deleteTask(String id) async {
    try {
      final response = await _http.delete('task/$id');
      return response.statusCode == 200;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<TaskEntity>> getTasks() async {
    try {
      UserEntity user = await _hive.getItem('user', 'token');
      final response = await _http.getMethod('task/user/${user.id}');
      final result = response.data as List;
      return result.map((e) => TaskModel.fromJson(e).toEntity()).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<TaskEntity> updateTask(TaskEntity task) async {
    try {
      TaskModel model = TaskModel.fromEntity(task);
      final response =
          await _http.put('task/update/${task.id}', model.toJson());
      final result = TaskModel.fromJson(response.data).toEntity();
      return result;
    } catch (e) {
      rethrow;
    }
  }
}
