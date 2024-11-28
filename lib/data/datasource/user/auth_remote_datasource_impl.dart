import 'package:injectable/injectable.dart';
import 'package:todolist/data/datasource/clients/hive/hive_service.dart';
import 'package:todolist/data/datasource/clients/http/http_service.dart';
import 'package:todolist/data/datasource/user/auth_remote_datasource.dart';
import 'package:todolist/data/models/auth/auth_dto.dart';
import 'package:todolist/data/models/user/user_model.dart';
import 'package:todolist/domain/entities/user/user_entity.dart';

@Injectable(as: AuthRemoteDatasource)
class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  HttpService _http;
  HiveService _hive;
  AuthRemoteDatasourceImpl(
      {required HttpService http, required HiveService hive})
      : _http = http,
        _hive = hive;

  @override
  Future<UserEntity> login(AuthDTO auth) async {
    try {
      final response = await _http.login(auth);
      UserEntity user = UserModel.fromJson(response.data).toEntity();
      await _hive.saveItem('user', 'token', user);
      return user;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserEntity> signUp(AuthDTO auth) async {
    try {
      final response = await _http.register(auth);
      UserEntity user = UserModel.fromJson(response.data).toEntity();
      await _hive.saveItem('user', 'token', user);
      return user;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserEntity> getUser() async {
    try {
      UserEntity user = await _hive.getItem('user', 'token');
      return user;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> logout() {
    try {
      final response = _hive.deleteItem('user', 'token');
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
