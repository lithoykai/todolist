import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:todolist/data/models/task_model.dart';
import 'package:todolist/domain/entities/task_entity.dart';
import 'package:todolist/domain/repositories/task/task_repository.dart';
import 'package:todolist/infra/failure/failure.dart';

@injectable
class CreateTaskUseCase {
  final ITaskRepository _repository;

  CreateTaskUseCase({required ITaskRepository repository})
      : _repository = repository;

  Future<Either<Failure, TaskEntity>> call(TaskModel task) async {
    return await _repository.createTask(task);
  }
}
