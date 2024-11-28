import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:todolist/data/datasource/clients/hive/hive_service.dart';
import 'package:todolist/data/datasource/clients/http/http_service.dart';
import 'package:todolist/data/datasource/user/auth_remote_datasource.dart';
import 'package:todolist/data/datasource/user/auth_remote_datasource_impl.dart';
import 'package:todolist/domain/entities/user/user_entity.dart';

import '../../../fixture/auth_fixture.dart';
import 'auth_remote_datasource_test.mocks.dart';

@GenerateMocks([HttpService, HiveService])
void main() {
  late HttpService httpService;
  late HiveService hiveService;
  late AuthRemoteDatasource datasource;

  setUp(() {
    httpService = MockHttpService();
    hiveService = MockHiveService();
    datasource = AuthRemoteDatasourceImpl(http: httpService, hive: hiveService);
  });

  group('authentication test', () {
    test('should login', () async {
      final _fixture = fakeAuthDTO;
      final _entity = fakeUserEntity;
      when(httpService.login(_fixture)).thenAnswer((_) async =>
          Response(requestOptions: RequestOptions(), data: authHttpReponse));
      when(hiveService.saveItem('user', 'token', _entity))
          .thenAnswer((_) async {});
      final response = await datasource.login(_fixture);
      verify(httpService.login(_fixture)).called(1);
      expect(response, isA<UserEntity>());
    });
    test('should throw a exception when try login', () async {
      final _fixture = fakeAuthDTO;
      when(httpService.login(_fixture)).thenThrow(Exception());
      expect(() async => await datasource.login(_fixture),
          throwsA(isA<Exception>()));
    });

    test('should create a account', () async {
      final _fixture = fakeAuthDTO;
      final _entity = fakeUserEntity;
      when(httpService.register(_fixture)).thenAnswer((_) async =>
          Response(requestOptions: RequestOptions(), data: authHttpReponse));
      when(hiveService.saveItem('user', 'token', _entity))
          .thenAnswer((_) async {});
      final response = await datasource.signUp(_fixture);
      verify(httpService.register(_fixture)).called(1);
      expect(response, isA<UserEntity>());
    });

    test('should throw a server failure when create a account', () async {
      final _fixture = fakeAuthDTO;
      when(httpService.register(_fixture))
          .thenThrow(DioException(requestOptions: RequestOptions()));

      expect(() async => await datasource.signUp(_fixture),
          throwsA(isA<DioException>()));
    });
    test('should return a user data', () async {
      final _entity = fakeUserEntity;
      when(hiveService.getItem('user', 'token'))
          .thenAnswer((_) async => _entity);
      final response = await datasource.getUser();
      verify(hiveService.getItem('user', 'token')).called(1);
      expect(response, isA<UserEntity>());
    });
    test('should delete user data', () async {
      when(hiveService.deleteItem('user', 'token'))
          .thenAnswer((_) async => true);
      final response = await datasource.logout();
      verify(hiveService.deleteItem('user', 'token')).called(1);
      expect(response, true);
    });
  });
}
