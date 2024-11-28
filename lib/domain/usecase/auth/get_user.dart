import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:todolist/domain/entities/user/user_entity.dart';
import 'package:todolist/domain/repositories/user/auth_repository.dart';
import 'package:todolist/infra/failure/failure.dart';

@injectable
class GetUserUseCase {
  final AuthRepository _authRepository;

  GetUserUseCase({required AuthRepository authRepository})
      : _authRepository = authRepository;

  Future<Either<Failure, UserEntity>> call() async {
    return await _authRepository.getUser();
  }
}
