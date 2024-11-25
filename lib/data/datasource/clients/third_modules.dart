import 'package:hive/hive.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@module
abstract class RegisterModule {
  @factoryMethod
  Dio dio() => dio();

  @factoryMethod
  HiveInterface hive() => Hive;
}
