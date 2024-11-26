import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:todolist/domain/entities/task_entity.dart';
import 'package:todolist/domain/repositories/task/task_repository.dart';
import 'package:todolist/infra/failure/failure.dart';

@injectable
class UpdateTaskUseCase {
  final ITaskRepository _repository;

  UpdateTaskUseCase({required ITaskRepository repository})
      : _repository = repository;

  Future<Either<Failure, TaskEntity>> call(TaskEntity task) async {
    return await _repository.updateTask(task);
  }
}
