import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:todolist/data/datasource/task/task_datasource_proxy.dart';
import 'package:todolist/data/datasource/user/auth_remote_datasource.dart';
import 'package:todolist/data/models/auth/auth_dto.dart';
import 'package:todolist/domain/entities/user/user_entity.dart';
import 'package:todolist/domain/repositories/user/auth_repository.dart';
import 'package:todolist/infra/failure/failure.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _datasource;
  final TaskDataSourceProxy _poxy;

  AuthRepositoryImpl(
      {required AuthRemoteDatasource datasource,
      required TaskDataSourceProxy poxy})
      : _datasource = datasource,
        _poxy = poxy;

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
      _poxy.switchDataSource(true);
      return Right(user);
    } on DioException catch (e) {
      if (e.response?.data['message'] == null) {
        return Left(AuthFailure(msg: 'Ocorreu um erro no servidor.'));
      }
      return Left(AuthFailure(msg: e.response?.data['message']));
    } catch (e) {
      return Left(AppFailure(msg: 'Ocorreu um erro ao tentar fazer login.'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signUp(AuthDTO auth) async {
    try {
      final user = await _datasource.signUp(auth);
      _poxy.switchDataSource(true);
      return Right(user);
    } on DioException catch (e) {
      if (e.response?.data['message'] == null) {
        return Left(AuthFailure(msg: 'Ocorreu um erro no servidor.'));
      }
      return Left(AuthFailure(msg: e.response?.data['message']));
    } catch (e) {
      return Left(AppFailure(
          msg: 'Ocorreu um erro desconhecido ao tentar realizar o cadastro.'));
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      final response = await _datasource.logout();
      _poxy.switchDataSource(false);
      return Right(response);
    } catch (e) {
      return Left(AuthFailure(msg: 'Ocorreu um erro ao tentar fazer logout.'));
    }
  }
}
