import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:todolist/domain/entities/task_entity.dart';
import 'package:todolist/domain/repositories/task/task_repository.dart';
import 'package:todolist/domain/usecase/task/get_tasks.dart';
import 'package:todolist/infra/failure/failure.dart';

import '../../../fixture/task_fixture.dart';
import 'create_task_test.mocks.dart';

void main() {
  late ITaskRepository repository;
  late GetTasksUseCase getTasksUseCase;

  setUp(() {
    repository = MockITaskRepository();
    getTasksUseCase = GetTasksUseCase(repository: repository);
  });

  group('Get Task test', () {
    test('Should get a list of tasks', () async {
      final _fixture = fakeTaskEntityList;

      when(repository.getTasks()).thenAnswer((_) async => Right(_fixture));
      final _response = await getTasksUseCase.getTasks();
      final _result = _response.fold((l) => l, (r) => r);
      verify(repository.getTasks()).called(1);

      expect(_result, _fixture);
      expect(_result, isA<List<TaskEntity>>());
      expect(_response.isRight(), true);
    });

    test('Should return a empty list', () async {
      when(repository.getTasks())
          .thenAnswer((_) async => const Right(<TaskEntity>[]));
      final _response = await getTasksUseCase.getTasks();
      final _result = _response.fold((l) => l, (r) => r);
      verify(repository.getTasks()).called(1);

      expect(_result, []);
      expect(_result, isA<List<TaskEntity>>());
      expect(_response.isRight(), true);
    });

    test('Should return a error when I try get a list', () async {
      when(repository.getTasks())
          .thenAnswer((_) async => Left(AppFailure(msg: 'Error')));
      final _response = await getTasksUseCase.getTasks();
      final _result = _response.fold((l) => l, (r) => r);
      verify(repository.getTasks()).called(1);

      expect(_result, isA<Failure>());
      expect(_response.isRight(), false);
    });
  });
}
