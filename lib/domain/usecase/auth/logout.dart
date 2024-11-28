import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:todolist/domain/repositories/user/auth_repository.dart';
import 'package:todolist/infra/failure/failure.dart';

@injectable
class LogoutUsecase {
  final AuthRepository _authRepository;

  LogoutUsecase(this._authRepository);

  Future<Either<Failure, bool>> call() async {
    return await _authRepository.logout();
  }
}
