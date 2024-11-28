import 'package:todolist/data/models/auth/auth_dto.dart';
import 'package:todolist/domain/entities/user/user_entity.dart';

abstract class AuthRemoteDatasource {
  Future<UserEntity> login(AuthDTO auth);
  Future<UserEntity> signUp(AuthDTO auth);
  Future<UserEntity> getUser();
}
