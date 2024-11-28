import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:todolist/domain/repositories/task/task_repository.dart';
import 'package:todolist/domain/usecase/task/delete_task.dart';
import 'package:todolist/infra/failure/failure.dart';

import '../../../fixture/task_fixture.dart';
import 'create_task_test.mocks.dart';

void main() {
  late ITaskRepository repository;
  late DeleteTaskUseCase deleteTaskUseCase;

  setUp(() {
    repository = MockITaskRepository();
    deleteTaskUseCase = DeleteTaskUseCase(repository);
  });

  group('Delete Task test', () {
    test('Should delete a task', () async {
      final _fixture = fakeTaskEntity;

      when(repository.deleteTask(_fixture.id))
          .thenAnswer((_) async => const Right(true));
      final _response = await deleteTaskUseCase.call(_fixture.id);
      final _result = _response.fold((l) => l, (r) => r);
      verify(repository.deleteTask(_fixture.id)).called(1);

      expect(_result, true);
      expect(_result, isA<bool>());
      expect(_response.isRight(), true);
    });

    test('Should return a error when I try delete a task', () async {
      final _fixture = fakeTaskEntity;
      when(repository.deleteTask(_fixture.id))
          .thenAnswer((_) async => Left(AppFailure(msg: 'Error')));
      final _response = await deleteTaskUseCase.call(_fixture.id);
      final _result = _response.fold((l) => l, (r) => r);
      verify(repository.deleteTask(_fixture.id)).called(1);

      expect(_result, isA<Failure>());
      expect(_response.isRight(), false);
    });
  });
}
