import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:todolist/data/datasource/task/task_datasource_proxy.dart';
import 'package:todolist/data/datasource/user/auth_remote_datasource.dart';
import 'package:todolist/data/repositories/auth_repository_impl.dart';
import 'package:todolist/domain/repositories/user/auth_repository.dart';

import '../../../fixture/auth_fixture.dart';
import 'auth_repository_test.mocks.dart';

@GenerateMocks([AuthRemoteDatasource, TaskDataSourceProxy])
void main() {
  late AuthRemoteDatasource datasource;
  late AuthRepository repository;
  late TaskDataSourceProxy proxy;

  setUp(() {
    datasource = MockAuthRemoteDatasource();
    proxy = MockTaskDataSourceProxy();
    repository = AuthRepositoryImpl(datasource: datasource, poxy: proxy);
  });

  group('getUser', () {
    test('should return a user', () async {
      final _fixture = fakeUserEntity;
      when(datasource.getUser()).thenAnswer((_) async => _fixture);
      final result = await repository.getUser();
      expect(result, isA<Right>());
    });

    test('should return a failure', () async {
      when(datasource.getUser()).thenThrow(Exception());
      final result = await repository.getUser();
      expect(result, isA<Left>());
    });
  });

  group('login test', () {
    test('should return a user', () async {
      //TODO: testar o switchDataSource também
      final _fixture = fakeUserEntity;
      when(datasource.login(fakeAuthDTO)).thenAnswer((_) async => _fixture);
      when(proxy.switchDataSource(true)).thenAnswer((_) async => null);
      final result = await repository.login(fakeAuthDTO);
      expect(result, isA<Right>());
    });

    test('should return a failure', () async {
      when(datasource.login(fakeAuthDTO)).thenThrow(Exception());
      final result = await repository.login(fakeAuthDTO);
      expect(result, isA<Left>());
    });
  });

  group('signUp test', () {
    test('should return a user', () async {
      final _fixture = fakeUserEntity;
      when(datasource.signUp(fakeAuthDTO)).thenAnswer((_) async => _fixture);
      when(proxy.switchDataSource(true)).thenAnswer((_) async => null);
      final result = await repository.signUp(fakeAuthDTO);
      expect(result, isA<Right>());
    });

    test('should return a failure', () async {
      when(datasource.signUp(fakeAuthDTO)).thenThrow(Exception());
      final result = await repository.signUp(fakeAuthDTO);
      expect(result, isA<Left>());
    });
  });
}
