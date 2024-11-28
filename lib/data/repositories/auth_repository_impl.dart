import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:todolist/data/datasource/user/auth_remote_datasource.dart';
import 'package:todolist/data/models/auth/auth_dto.dart';
import 'package:todolist/domain/entities/user/user_entity.dart';
import 'package:todolist/domain/repositories/user/auth_repository.dart';
import 'package:todolist/infra/failure/failure.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _datasource;

  AuthRepositoryImpl({required AuthRemoteDatasource datasource})
      : _datasource = datasource;

  @override
  Future<Either<Failure, UserEntity>> getUser() async {
    try {
      final user = await _datasource.getUser();
      return Right(user);
    } catch (e) {
      return Left(
          AuthFailure(msg: 'Ocorreu um erro ao tentar buscar usuário.'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> login(AuthDTO auth) async {
    try {
      final user = await _datasource.login(auth);
      return Right(user);
    } on DioException {
      return Left(AuthFailure(msg: 'Ocorreu um erro no servidor.'));
    } catch (e) {
      return Left(AuthFailure(msg: 'Ocorreu um erro ao tentar fazer login.'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signUp(AuthDTO auth) async {
    try {
      final user = await _datasource.login(auth);
      return Right(user);
    } on DioException {
      return Left(AuthFailure(msg: 'Ocorreu um erro no servidor.'));
    } catch (e) {
      return Left(AuthFailure(
          msg: 'Ocorreu um erro desconhecido ao tentar realizar o cadastro.'));
    }
  }
}
