import 'package:dartz/dartz.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:todolist/data/datasource/task/task_datasource_offline.dart';
import 'package:todolist/data/models/task_model.dart';
import 'package:todolist/domain/entities/task_entity.dart';
import 'package:todolist/domain/repositories/task/task_repository.dart';
import 'package:todolist/infra/failure/failure.dart';

@Injectable(as: ITaskRepository)
class TaskRepositoryImpl implements ITaskRepository {
  final ITaskDataSource _taskDataSource;

  TaskRepositoryImpl({required ITaskDataSource taskDataSource})
      : _taskDataSource = taskDataSource;

  @override
  Future<Either<Failure, TaskEntity>> createTask(TaskModel task) async {
    try {
      final response = await _taskDataSource.createTask(task);
      return Right(response);
    } on HiveError {
      return Left(AppFailure(msg: 'Erro ao tentar armazenar nova tarefa'));
    } catch (e) {
      return Left(AppFailure(msg: 'Erro desconhecido'));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteTask(String id) async {
    try {
      final response = await _taskDataSource.deleteTask(id);
      return Right(response);
    } catch (e) {
      return Left(AppFailure(msg: 'Erro desconhecido'));
    }
  }

  @override
  Future<Either<Failure, List<TaskEntity>>> getTasks() async {
    try {
      final response = await _taskDataSource.getTasks();
      return Right(response);
    } on HiveError {
      return Left(AppFailure(msg: 'Erro ao tentar buscar tarefas'));
    } catch (e) {
      return Left(AppFailure(msg: 'Erro desconhecido'));
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> updateTask(TaskEntity task) async {
    try {
      final response = await _taskDataSource.updateTask(task);
      return Right(response);
    } on HiveError {
      return Left(AppFailure(msg: 'Erro ao tentar atualizar tarefa'));
    } catch (e) {
      return Left(AppFailure(msg: 'Erro desconhecido'));
    }
  }
}
