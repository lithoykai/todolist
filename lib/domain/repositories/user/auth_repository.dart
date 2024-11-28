import 'package:dartz/dartz.dart';
import 'package:todolist/data/models/auth/auth_dto.dart';
import 'package:todolist/domain/entities/user/user_entity.dart';
import 'package:todolist/infra/failure/failure.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, UserEntity>> login(AuthDTO auth);
  Future<Either<Failure, UserEntity>> signUp(AuthDTO auth);
  Future<Either<Failure, UserEntity>> getUser();
  Future<Either<Failure, bool>> logout();
}
