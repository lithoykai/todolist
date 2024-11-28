import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mockito/mockito.dart';
import 'package:todolist/data/datasource/clients/hive/hive_service.dart';
import 'package:todolist/data/datasource/clients/http/http_service.dart';
import 'package:todolist/data/datasource/synchronize/synchronize_datasource.dart';
import 'package:todolist/data/models/task_model.dart';
import 'package:todolist/domain/entities/task_entity.dart';

import '../../../fixture/task_fixture.dart';
import '../auth/auth_remote_datasource_test.mocks.dart';

void main() {
  late HiveService hive;
  late HttpService http;
  late SynchronizeDatasource datasource;

  setUp(() {
    hive = MockHiveService();
    http = MockHttpService();
    datasource = SynchronizeDatasource(hive: hive, http: http);
  });

  group('Synchronize data source test', () {
    test('Should return true if have offline items', () async {
      final _fixture = fakeTaskEntityList;
      when(hive.getAllItems<TaskEntity>('tasks'))
          .thenAnswer((_) async => _fixture);
      final response = await datasource.hasItensOffline();
      expect(response, true);
    });
    test('Should return false when there are no offline items', () async {
      when(hive.getAllItems<TaskEntity>('tasks')).thenAnswer((_) async => []);
      final response = await datasource.hasItensOffline();
      expect(response, false);
    });
    test('Should throw a erro when try get offline items', () async {
      when(hive.getAllItems<TaskEntity>('tasks')).thenThrow(HiveError('Error'));
      expect(() async => await datasource.hasItensOffline(),
          throwsA(isA<HiveError>()));
    });

    test('Should synchronize tasks', () async {
      final _fixture = fakeTaskEntityList;
      List<Map<String, dynamic>> _models =
          _fixture.map((e) => TaskModel.fromEntity(e).toJson()).toList();

      when(hive.getAllItems<TaskEntity>('tasks'))
          .thenAnswer((_) async => _fixture);
      when(http.postList('task/batch', _models)).thenAnswer((_) async =>
          Response(requestOptions: RequestOptions(), data: _models));
      when(hive.clearBox('tasks')).thenAnswer((_) async => {});
      final response = await datasource.synchronize();
      verify(hive.getAllItems<TaskEntity>('tasks')).called(1);
      verify(http.postList('task/batch', _models)).called(1);
      expect(response, fakeTaskEntityListResponse);
    });
  });
  test('Should generate error when trying to sync tasks', () async {
    final _fixture = fakeTaskEntityList;
    List<Map<String, dynamic>> _models =
        _fixture.map((e) => TaskModel.fromEntity(e).toJson()).toList();

    when(hive.getAllItems<TaskEntity>('tasks'))
        .thenAnswer((_) async => _fixture);
    when(http.postList('task/batch', _models))
        .thenThrow(DioException(requestOptions: RequestOptions()));
    expect(() async => await datasource.synchronize(),
        throwsA(isA<DioException>()));
  });
}
