import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:todolist/data/datasource/task/task_datasource_offline.dart';
import 'package:todolist/data/repositories/task_repository_impl.dart';
import 'package:todolist/domain/entities/task_entity.dart';
import 'package:todolist/domain/repositories/task/task_repository.dart';
import 'package:todolist/infra/failure/failure.dart';

import '../../../fixture/task_fixture.dart';
import 'task_repository_test.mocks.dart';

@GenerateMocks([ITaskDataSource])
void main() {
  late ITaskDataSource dataSource;
  late ITaskRepository repository;

  setUp(() {
    dataSource = MockITaskDataSource();
    repository = TaskRepositoryImpl(taskDataSource: dataSource);
  });

  group('Task Repository tests', () {
    test('Should create a task', () async {
      final _fixture = fakeTaskModel;
      when(dataSource.createTask(_fixture))
          .thenAnswer((_) async => _fixture.toEntity());

      final _response = await repository.createTask(_fixture);
      final _result = _response.fold((l) => l, (r) => r);
      verify(dataSource.createTask(_fixture)).called(1);
      expect(_result, isA<TaskEntity>());
      expect(_response.isRight(), true);
    });

    test('Should throw a error when I try create a task', () async {
      final _fixture = fakeTaskModel;
      when(dataSource.createTask(_fixture)).thenThrow(Exception());

      final _response = await repository.createTask(_fixture);
      final _result = _response.fold((l) => l, (r) => r);
      verify(dataSource.createTask(_fixture)).called(1);
      expect(_result, isA<AppFailure>());
      expect(_response.isLeft(), true);
    });

    test('Should get a to-do list', () async {
      final _fixture = fakeTaskEntityList;
      when(dataSource.getTasks()).thenAnswer((_) async => _fixture);

      final _response = await repository.getTasks();
      final _result = _response.fold((l) => l, (r) => r);
      verify(dataSource.getTasks()).called(1);
      expect(_result, isA<List<TaskEntity>>());
      expect(_response.isRight(), true);
    });

    test('Should return a empty to-do list', () async {
      when(dataSource.getTasks()).thenAnswer((_) async => []);
      final _response = await repository.getTasks();
      final _result = _response.fold((l) => l, (r) => r);
      verify(dataSource.getTasks()).called(1);
      expect(_result, []);
      expect(_response.isRight(), true);
    });

    test('Should throw a error when I try get all tasks', () async {
      final _fixture = fakeTaskModel;
      when(dataSource.getTasks()).thenThrow(Exception());

      final _response = await repository.getTasks();
      final _result = _response.fold((l) => l, (r) => r);
      verify(dataSource.getTasks()).called(1);
      expect(_result, isA<AppFailure>());
      expect(_response.isLeft(), true);
    });

    test('Should update a task', () async {
      final _fakeTaskEntity = fakeTaskEntity;
      when(dataSource.updateTask(_fakeTaskEntity))
          .thenAnswer((_) async => _fakeTaskEntity);

      final _response = await repository.updateTask(_fakeTaskEntity);
      final _result = _response.fold((l) => l, (r) => r);
      verify(dataSource.updateTask(_fakeTaskEntity)).called(1);
      expect(_response.isRight(), true);
    });

    test('Should throw a error when I try update a task', () async {
      final _fixture = fakeTaskEntity;
      when(dataSource.updateTask(_fixture)).thenThrow(HiveError('Error'));

      final _response = await repository.updateTask(_fixture);
      final _result = _response.fold((l) => l, (r) => r);
      verify(dataSource.updateTask(_fixture)).called(1);
      expect(_result, isA<AppFailure>());
      expect(_response.isLeft(), true);
    });
    test('Should delete a task', () async {
      final _fixture = fakeTaskEntity;
      when(dataSource.deleteTask(_fixture.id)).thenAnswer((_) async => true);

      final _response = await repository.deleteTask(_fixture.id);
      final _result = _response.fold((l) => l, (r) => r);
      verify(dataSource.deleteTask(_fixture.id)).called(1);
      expect(_response.isRight(), true);
    });

    test('Should throw a error when I try delete a task', () async {
      final _fixture = fakeTaskEntity;
      when(dataSource.deleteTask(_fixture.id)).thenThrow(HiveError('Error'));

      final _response = await repository.deleteTask(_fixture.id);
      final _result = _response.fold((l) => l, (r) => r);
      verify(dataSource.deleteTask(_fixture.id)).called(1);
      expect(_result, isA<AppFailure>());
      expect(_response.isLeft(), true);
    });
  });
}
