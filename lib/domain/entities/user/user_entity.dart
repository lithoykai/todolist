import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'user_entity.g.dart';

@HiveType(typeId: 2)
class UserEntity extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String email;
  @HiveField(2)
  String _token;
  @HiveField(3)
  final DateTime expiryDate;

  UserEntity({
    required this.id,
    required this.email,
    required this.expiryDate,
    String? token,
  }) : _token = token ?? '';

  String get token => _token;
  set token(String value) => _token = value;

  @override
  List<Object?> get props => [id, email, _token, expiryDate];
}
