import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:todolist/domain/entities/task_entity.dart';
import 'package:todolist/domain/repositories/task/task_repository.dart';
import 'package:todolist/infra/failure/failure.dart';

@injectable
class GetTasksUseCase {
  final ITaskRepository _repository;

  GetTasksUseCase({required ITaskRepository repository})
      : _repository = repository;

  Future<Either<Failure, List<TaskEntity>>> getTasks() async {
    return await _repository.getTasks();
  }
}
