import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:todolist/data/models/auth/auth_dto.dart';
import 'package:todolist/domain/entities/user/user_entity.dart';
import 'package:todolist/domain/repositories/user/auth_repository.dart';
import 'package:todolist/infra/failure/failure.dart';

@injectable
class LoginUseCase {
  final AuthRepository _authRepository;

  LoginUseCase(this._authRepository);

  Future<Either<Failure, UserEntity>> call(AuthDTO auth) async {
    return await _authRepository.login(auth);
  }
}
