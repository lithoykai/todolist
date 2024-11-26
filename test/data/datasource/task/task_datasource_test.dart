import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:todolist/data/datasource/clients/hive/hive_service.dart';
import 'package:todolist/data/datasource/task/task_datasource_impl.dart';
import 'package:todolist/data/datasource/task/task_datasource_offline.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:todolist/domain/entities/task_entity.dart';

import '../../../fixture/task_fixture.dart';
import 'task_datasource_test.mocks.dart';

@GenerateMocks([HiveService, Box<TaskEntity>])
void main() {
  late HiveService _hiveService;
  late Box<TaskEntity> box;
  late ITaskDataSource datasource;

  setUp(() {
    _hiveService = MockHiveService();
    box = MockBox();
    datasource = TaskDataSourceImpl(hiveService: _hiveService);
  });

  group('DataSource Tests', () {
    test('Should create a task', () async {
      final _fakeModel = fakeTaskModel;
      final _fakeTaskEntity = fakeTaskModel.toEntity();

      when(_hiveService.saveItem("tasks", _fakeTaskEntity.id, _fakeTaskEntity))
          .thenAnswer((_) async => _fakeTaskEntity);
      final response = await datasource.createTask(fakeTaskModel);

      verify(_hiveService.saveItem(
              "tasks", _fakeTaskEntity.id, _fakeTaskEntity))
          .called(1);

      expect(response.id, _fakeTaskEntity.id);
      expect(response, isA<TaskEntity>());
    });

    test('Should return a error when try create a task', () async {
      final _fakeModel = fakeTaskModel;
      final _fakeTaskEntity = fakeTaskModel.toEntity();

      when(_hiveService.saveItem("tasks", _fakeTaskEntity.id, _fakeTaskEntity))
          .thenThrow(HiveError("Error"));

      expect(() async => await datasource.createTask(_fakeModel),
          throwsA(isA<HiveError>()));
    });
    test('Should get a to-do list', () async {
      final _fakeList = fakeTaskEntityList;

      when(_hiveService.getAllItems("tasks"))
          .thenAnswer((_) async => _fakeList);
      final response = await datasource.getTasks();

      verify(_hiveService.getAllItems("tasks")).called(1);
      expect(response.length, _fakeList.length);
      expect(response, isA<List<TaskEntity>>());
    });

    test('Should return a empty list', () async {
      final _fakeList = fakeTaskEntityList;

      when(_hiveService.getAllItems("tasks"))
          .thenAnswer((_) async => <TaskEntity>[]);
      final response = await datasource.getTasks();

      verify(_hiveService.getAllItems("tasks")).called(1);
      expect(response.length, 0);
      expect(response, isA<List<TaskEntity>>());
    });

    test('Should return a error when try get a to-do list', () async {
      final _fakeModel = fakeTaskModel;
      final _fakeTaskEntity = fakeTaskModel.toEntity();

      when(_hiveService.getAllItems("tasks")).thenThrow(HiveError("Error"));

      expect(
          () async => await datasource.getTasks(), throwsA(isA<HiveError>()));
    });
    test('Should return a Exception when try get a to-do list', () async {
      final _fakeModel = fakeTaskModel;
      final _fakeTaskEntity = fakeTaskModel.toEntity();

      when(_hiveService.getAllItems("tasks")).thenThrow(Exception());

      expect(
          () async => await datasource.getTasks(), throwsA(isA<Exception>()));
    });
    test('Should delete a task from the list', () async {
      final _fakeList = fakeTaskEntityList;
      final _fakeTaskEntity = fakeTaskEntityTwo;

      when(_hiveService.deleteItem("tasks", _fakeTaskEntity.id))
          .thenAnswer((_) async => true);

      final response = await datasource.deleteTask(_fakeTaskEntity.id);
      verify(_hiveService.deleteItem("tasks", _fakeTaskEntity.id)).called(1);
      expect(response, true);
    });
    test('Should throw error when I try delete a task from the list', () async {
      final _fakeList = fakeTaskEntityList;
      final _fakeTaskEntity = fakeTaskEntityTwo;

      when(_hiveService.deleteItem("tasks", _fakeTaskEntity.id))
          .thenThrow(HiveError("Error"));

      expect(() async => await datasource.deleteTask(_fakeTaskEntity.id),
          throwsA(isA<HiveError>()));
    });
    test('Should edit a task', () async {
      final _firstFakeEntity = fakeTaskEntity;
      final _fakeTaskEntity = fakeTaskEntityEdited;

      when(_hiveService.updateItem(
              "tasks", _firstFakeEntity.id, _fakeTaskEntity))
          .thenAnswer((_) async => _fakeTaskEntity);

      final response = await datasource.updateTask(_fakeTaskEntity);
      verify(_hiveService.updateItem(
          "tasks", _fakeTaskEntity.id, _fakeTaskEntity));
      expect(response, _fakeTaskEntity);
    });
    test('Should throw error when edit a task', () async {
      final _firstFakeEntity = fakeTaskEntity;
      final _fakeTaskEntity = fakeTaskEntityEdited;

      when(_hiveService.updateItem(
              "tasks", _fakeTaskEntity.id, _fakeTaskEntity))
          .thenThrow(HiveError("Error"));

      expect(() async => await datasource.updateTask(_fakeTaskEntity),
          throwsA(isA<HiveError>()));
    });
  });
}
