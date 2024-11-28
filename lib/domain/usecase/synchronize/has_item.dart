import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:todolist/data/repositories/synchronize_repository.dart';
import 'package:todolist/infra/failure/failure.dart';

@injectable
class HasItemUseCase {
  final SynchronizeRepository _synchronizeRepository;

  HasItemUseCase({required SynchronizeRepository synchronizeRepository})
      : _synchronizeRepository = synchronizeRepository;
  Future<Either<Failure, bool>> call() async {
    return await _synchronizeRepository.hasItem();
  }
}
