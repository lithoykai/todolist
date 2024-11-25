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

      when(_hiveService.saveItem("tasks", _fakeTaskEntity))
          .thenAnswer((_) async => _fakeTaskEntity);
      final response = await datasource.createTask(fakeTaskModel);

      verify(_hiveService.saveItem("tasks", _fakeTaskEntity)).called(1);

      expect(response.id, _fakeTaskEntity.id);
      expect(response, isA<TaskEntity>());
    });
  });
}
