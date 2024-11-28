import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:todolist/data/repositories/synchronize_repository.dart';
import 'package:todolist/domain/entities/task_entity.dart';
import 'package:todolist/infra/failure/failure.dart';

@injectable
class SynchronizeUsecase {
  final SynchronizeRepository _synchronizeRepository;

  SynchronizeUsecase({required SynchronizeRepository synchronizeRepository})
      : _synchronizeRepository = synchronizeRepository;
  Future<Either<Failure, List<TaskEntity>>> call() async {
    return await _synchronizeRepository.synchronize();
  }
}
