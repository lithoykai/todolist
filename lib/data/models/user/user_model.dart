import 'package:todolist/data/models/user/user_model_mapper.dart';
import 'package:todolist/domain/entities/user/user_entity.dart';

class UserModel {
  String id;
  String email;
  String token;
  DateTime expiryDate;

  UserModel({
    required this.id,
    required this.email,
    required this.token,
    required this.expiryDate,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      $UserModelFromJson(json);
  Map<String, dynamic> toJson() => $UserModelToJson(this);
  factory UserModel.fromEntity(UserEntity entity) =>
      $UserModelFromEntity(entity);
  UserEntity toEntity() => $UserModelToEntity(this);
}
