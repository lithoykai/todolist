import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:todolist/data/datasource/clients/hive/hive_service.dart';
import 'package:todolist/data/models/auth/auth_dto.dart';
import 'package:todolist/domain/entities/user/user_entity.dart';
import 'package:todolist/infra/routers/endpoints.dart';

@injectable
class HttpService {
  final Dio _dio;
  final HiveService _hiveService;

  HttpService({required Dio dio, required HiveService hiveService})
      : _dio = dio,
        _hiveService = hiveService;

  Future<Response> _authorizedRequest(
      Future<Response> Function() request) async {
    final token = await _getToken();
    _dio.options.headers['content-Type'] = 'application/json';
    _dio.options.headers['authorization'] = token;
    return request();
  }

  Future<String> _getToken() async {
    UserEntity user = await _hiveService.getItem('user', 'token');
    return user.token;
  }

  Future<Response> login(AuthDTO request) async {
    try {
      var response = await _dio.post('${Endpoints.BASE_URL}/auth/login',
          data: request.toJson());
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> register(AuthDTO request) async {
    try {
      const _endpoint = '${Endpoints.BASE_URL}/auth/register';
      return await _dio.post(_endpoint, data: jsonEncode(request.toJson()));
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> post(String endpoint, Map<String, dynamic> data) async {
    return _authorizedRequest(() async {
      return _dio.post('${Endpoints.BASE_URL}/$endpoint',
          data: jsonEncode(data));
    });
  }

  Future<Response> put(String endpoint, Map<String, dynamic> data) async {
    return _authorizedRequest(() async {
      return _dio.put('${Endpoints.BASE_URL}/$endpoint',
          data: jsonEncode(data));
    });
  }

  Future<Response> delete(String endpoint) async {
    return _authorizedRequest(() async {
      return _dio.delete('${Endpoints.BASE_URL}/$endpoint');
    });
  }

  Future<Response> getMethod(String endpoint) async {
    return _authorizedRequest(() async {
      return _dio.get('${Endpoints.BASE_URL}/$endpoint');
    });
  }
}
