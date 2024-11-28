import 'package:todolist/data/datasource/task/task_datasource.dart';
import 'package:todolist/data/datasource/task/task_datasource_offline.dart';
import 'package:todolist/data/datasource/task/task_remote_datasource.dart';
import 'package:todolist/data/models/task_model.dart';
import 'package:todolist/di/di.dart';
import 'package:todolist/domain/entities/task_entity.dart';

class TaskDataSourceProxy implements ITaskDataSource {
  late ITaskDataSource _currentDataSource;

  TaskDataSourceProxy({required ITaskDataSource dataSource}) {
    _currentDataSource = dataSource;
  }

  void switchDataSource(bool online) {
    if (online) {
      _currentDataSource = getIt<TaskRemoteDatasource>();
    } else {
      _currentDataSource = getIt<TaskDatasourceOffline>();
    }
  }

  @override
  Future<TaskEntity> createTask(TaskModel task) {
    return _currentDataSource.createTask(task);
  }

  @override
  Future<bool> deleteTask(String id) {
    return _currentDataSource.deleteTask(id);
  }

  @override
  Future<List<TaskEntity>> getTasks() {
    return _currentDataSource.getTasks();
  }

  @override
  Future<TaskEntity> updateTask(TaskEntity task) {
    return _currentDataSource.updateTask(task);
  }
}
