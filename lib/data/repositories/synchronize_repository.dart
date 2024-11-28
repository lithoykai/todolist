import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:todolist/data/datasource/synchronize/synchronize_datasource.dart';
import 'package:todolist/domain/entities/task_entity.dart';
import 'package:todolist/infra/failure/failure.dart';

@injectable
class SynchronizeRepository {
  final SynchronizeDatasource _dataSource;

  SynchronizeRepository({required SynchronizeDatasource dataSource})
      : _dataSource = dataSource;

  Future<Either<Failure, List<TaskEntity>>> synchronize() async {
    try {
      final data = await _dataSource.synchronize();
      return Right(data);
    } catch (e) {
      return Left(AppFailure(msg: 'Erro ao tentar sincronizar tarefas'));
    }
  }

  Future<Either<Failure, bool>> hasItem() async {
    try {
      final data = await _dataSource.hasItensOffline();
      return Right(data);
    } catch (e) {
      return Left(AppFailure(msg: 'Erro ao tentar verificar tarefas'));
    }
  }
}
