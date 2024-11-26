import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:todolist/domain/repositories/task/task_repository.dart';
import 'package:todolist/infra/failure/failure.dart';

@injectable
class DeleteTaskUseCase {
  final ITaskRepository _taskRepository;

  DeleteTaskUseCase(this._taskRepository);

  Future<Either<Failure, bool>> call(String id) async {
    return _taskRepository.deleteTask(id);
  }
}
