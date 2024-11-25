import 'package:flutter/material.dart';
import 'package:todolist/data/datasource/clients/hive/hive_service.dart';
import 'package:todolist/data/datasource/task/task_datasource_offline.dart';
import 'package:todolist/data/models/task_model.dart';
import 'package:todolist/domain/entities/task_entity.dart';

class TaskDataSourceImpl implements ITaskDataSource {
  HiveService _hiveService;

  TaskDataSourceImpl({required HiveService hiveService})
      : _hiveService = hiveService;

  @override
  Future<TaskEntity> createTask(TaskModel task) async {
    try {
      final taskEntity = task.toEntity();
      await _hiveService.saveItem("tasks", taskEntity);
      return taskEntity;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> deleteTask(String id) {
    // TODO: implement deleteTask
    throw UnimplementedError();
  }

  @override
  Future<List<TaskEntity>> getTasks() {
    // TODO: implement getTasks
    throw UnimplementedError();
  }

  @override
  Future<TaskEntity> updateTask(TaskModel task) {
    // TODO: implement updateTask
    throw UnimplementedError();
  }
}
