import 'package:injectable/injectable.dart';
import 'package:todolist/data/datasource/clients/hive/hive_service.dart';
import 'package:todolist/data/datasource/clients/http/http_service.dart';
import 'package:todolist/data/models/task_model.dart';
import 'package:todolist/domain/entities/task_entity.dart';

@injectable
class SynchronizeDatasource {
  final HttpService _http;
  final HiveService _hive;
  SynchronizeDatasource({required HttpService http, required HiveService hive})
      : _http = http,
        _hive = hive;

  Future<List<TaskEntity>> synchronize() async {
    try {
      final tasks = await _hive.getAllItems<TaskEntity>('tasks');
      List<Map<String, dynamic>> models =
          tasks.map((e) => TaskModel.fromEntity(e).toJson()).toList();
      final response = await _http.postList('task/batch', models);
      await _hive.clearBox('tasks');
      final result = response.data as List;
      return result.map((e) => TaskModel.fromJson(e).toEntity()).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> hasItensOffline() async {
    try {
      final response = await _hive.getAllItems<TaskEntity>('tasks');
      return response.isNotEmpty;
    } catch (e) {
      rethrow;
    }
  }
}
