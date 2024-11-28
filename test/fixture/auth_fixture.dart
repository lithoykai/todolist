import 'package:todolist/data/models/auth/auth_dto.dart';
import 'package:todolist/data/models/user/user_model.dart';
import 'package:todolist/domain/entities/user/user_entity.dart';

Map<String, dynamic> authHttpReponse = {
  "id": "idQualquer",
  "email": "user@user.com",
  "createdAt": "Wed Nov 27 15:41:19 BRT 2024",
  "role": "USER",
  "token": "TOKEN",
  "expiryDate": 720
};

UserModel fakeUserModel = UserModel.fromJson(authHttpReponse);
UserEntity fakeUserEntity = fakeUserModel.toEntity();

AuthDTO fakeAuthDTO = AuthDTO(email: "user@user.com", password: "123456");
