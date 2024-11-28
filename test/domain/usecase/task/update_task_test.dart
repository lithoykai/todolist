import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:todolist/domain/entities/task_entity.dart';
import 'package:todolist/domain/repositories/task/task_repository.dart';
import 'package:todolist/domain/usecase/task/update_task.dart';
import 'package:todolist/infra/failure/failure.dart';

import '../../../fixture/task_fixture.dart';
import 'create_task_test.mocks.dart';

void main() {
  late ITaskRepository repository;
  late UpdateTaskUseCase updateTaskUseCase;

  setUp(() {
    repository = MockITaskRepository();
    updateTaskUseCase = UpdateTaskUseCase(repository: repository);
  });

  group('Update Task test', () {
    test('Should update a task', () async {
      final _fixture = fakeTaskEntity;

      when(repository.updateTask(_fixture))
          .thenAnswer((_) async => Right(_fixture));
      final _response = await updateTaskUseCase.call(_fixture);
      final _result = _response.fold((l) => l, (r) => r);
      verify(repository.updateTask(_fixture)).called(1);

      expect(_result, _fixture);
      expect(_result, isA<TaskEntity>());
      expect(_response.isRight(), true);
    });

    test('Should return a error when I try update a task', () async {
      final _fixture = fakeTaskEntity;
      when(repository.updateTask(_fixture))
          .thenAnswer((_) async => Left(AppFailure(msg: 'Error')));
      final _response = await updateTaskUseCase.call(_fixture);
      final _result = _response.fold((l) => l, (r) => r);
      verify(repository.updateTask(_fixture)).called(1);

      expect(_result, isA<Failure>());
      expect(_response.isRight(), false);
    });
  });
}
