import 'package:todolist/data/models/user/user_model.dart';
import 'package:todolist/domain/entities/user/user_entity.dart';

UserModel $UserModelFromEntity(UserEntity entity) {
  return UserModel(
    id: entity.id,
    email: entity.email,
    token: entity.token,
    expiryDate: entity.expiryDate,
  );
}

UserEntity $UserModelToEntity(UserModel model) {
  return UserEntity(
    id: model.id,
    email: model.email,
    token: model.token,
    expiryDate: model.expiryDate,
  );
}

UserModel $UserModelFromJson(Map<String, dynamic> json) {
  return UserModel(
    id: json['id'],
    email: json['email'],
    token: json['token'],
    expiryDate: DateTime.now().add(Duration(hours: json['expiryDate'])),
  );
}

Map<String, dynamic> $UserModelToJson(UserModel model) {
  return {
    'id': model.id,
    'email': model.email,
    'token': model.token,
    'expiryDate': model.expiryDate.toIso8601String(),
  };
}
