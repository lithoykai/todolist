import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:todolist/data/models/auth/auth_dto.dart';
import 'package:todolist/domain/entities/user/user_entity.dart';
import 'package:todolist/domain/repositories/user/auth_repository.dart';
import 'package:todolist/infra/failure/failure.dart';

@injectable
class CreateAccountUseCase {
  final AuthRepository _authRepository;

  CreateAccountUseCase({required AuthRepository authRepository})
      : _authRepository = authRepository;

  Future<Either<Failure, UserEntity>> call(AuthDTO auth) async {
    return await _authRepository.signUp(auth);
  }
}
