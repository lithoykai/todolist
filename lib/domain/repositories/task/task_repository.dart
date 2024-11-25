import 'package:dartz/dartz.dart';
import 'package:todolist/data/models/task_model.dart';
import 'package:todolist/domain/entities/task_entity.dart';
import 'package:todolist/infra/failure/failure.dart';

abstract interface class ITaskRepository {
  Future<Either<Failure, List<TaskEntity>>> getTasks();
  Future<Either<Failure, TaskEntity>> createTask(TaskModel task);
  Future<Either<Failure, TaskEntity>> updateTask(TaskModel task);
  Future<Either<Failure, String>> deleteTask(String id);
}
