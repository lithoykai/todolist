import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:todolist/domain/entities/task_entity.dart';
import 'package:todolist/domain/repositories/task/task_repository.dart';
import 'package:todolist/domain/usecase/task/create_task.dart';
import 'package:todolist/infra/failure/failure.dart';

import '../../../fixture/task_fixture.dart';
import 'create_task_test.mocks.dart';

@GenerateMocks([ITaskRepository])
void main() {
  late ITaskRepository repository;
  late CreateTaskUseCase createTaskUseCase;

  setUp(() {
    repository = MockITaskRepository();
    createTaskUseCase = CreateTaskUseCase(repository: repository);
  });

  group('Create a task tests', () {
    test('Should create a task', () async {
      final _fakeModel = fakeTaskModel;
      final _fakeTaskEntity = fakeTaskModel.toEntity();

      when(repository.createTask(_fakeModel))
          .thenAnswer((_) async => Right(_fakeTaskEntity));
      final _response = await createTaskUseCase(_fakeModel);
      final _result = _response.fold((l) => l, (r) => r);
      verify(repository.createTask(_fakeModel)).called(1);

      expect(_result, _fakeTaskEntity);
      expect(_result, isA<TaskEntity>());
      expect(_response.isRight(), true);
    });

    test('Should return a error when try create a task', () async {
      final _fakeModel = fakeTaskModel;

      when(repository.createTask(_fakeModel))
          .thenAnswer((_) async => Left(AppFailure(msg: 'Error')));

      final _response = await createTaskUseCase(_fakeModel);
      final _result = _response.fold((l) => l, (r) => r);

      verify(repository.createTask(_fakeModel)).called(1);
      expect(_response.isLeft(), true);
      expect(_result, isA<AppFailure>());
    });
  });
}
