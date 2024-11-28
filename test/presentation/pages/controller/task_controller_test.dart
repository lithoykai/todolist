import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:todolist/domain/usecase/task/create_task.dart';
import 'package:todolist/domain/usecase/task/delete_task.dart';
import 'package:todolist/domain/usecase/task/get_tasks.dart';
import 'package:todolist/domain/usecase/task/update_task.dart';
import 'package:todolist/infra/failure/failure.dart';
import 'package:todolist/presentation/pages/controller/task_controller.dart';

import '../../../fixture/task_fixture.dart';
import 'task_controller_test.mocks.dart';

@GenerateMocks(
    [CreateTaskUseCase, GetTasksUseCase, UpdateTaskUseCase, DeleteTaskUseCase])
void main() {
  late MockGetTasksUseCase mockGetTasksUseCase;
  late MockCreateTaskUseCase mockCreateTaskUseCase;
  late MockUpdateTaskUseCase mockUpdateTaskUseCase;
  late MockDeleteTaskUseCase mockDeleteTaskUseCase;
  late TaskController controller;

  setUp(() {
    mockGetTasksUseCase = MockGetTasksUseCase();
    mockCreateTaskUseCase = MockCreateTaskUseCase();
    mockUpdateTaskUseCase = MockUpdateTaskUseCase();
    mockDeleteTaskUseCase = MockDeleteTaskUseCase();

    controller = TaskController(
      getTasksUseCase: mockGetTasksUseCase,
      createTaskUseCase: mockCreateTaskUseCase,
      updateTaskUseCase: mockUpdateTaskUseCase,
      deleteTaskUseCase: mockDeleteTaskUseCase,
    );
  });

  group('getTasks', () {
    test('should get tasks and update status to idle on success', () async {
      final _tasks = fakeTaskEntityList;
      when(mockGetTasksUseCase.getTasks())
          .thenAnswer((_) async => Right(_tasks));

      await controller.getTasks();

      expect(controller.status, isA<TaskStatusIdle>());
      expect(controller.filteredTasks, _tasks);
      verify(mockGetTasksUseCase.getTasks()).called(1);
    });

    test('should set status to error on failure case', () async {
      when(mockGetTasksUseCase.getTasks())
          .thenAnswer((_) async => Left(AppFailure(msg: 'Error')));

      await controller.getTasks();

      expect(controller.status, isA<TaskStatusError>());
      expect((controller.status as TaskStatusError).message, 'Error');
      verify(mockGetTasksUseCase.getTasks()).called(1);
    });
  });

  group('createTask', () {
    test('should add task and set status to idle on success', () async {
      final _taskModel = fakeTaskModel;
      final _task = _taskModel.toEntity();
      when(mockCreateTaskUseCase.call(_taskModel))
          .thenAnswer((_) async => Right(_task));

      await controller.createTask(_taskModel);

      expect(controller.status, isA<TaskStatusIdle>());
      expect(controller.filteredTasks.contains(_task), true);
      verify(mockCreateTaskUseCase.call(_taskModel)).called(1);
    });

    test('should set status to error on failure', () async {
      final _fixture = fakeTaskModel;
      when(mockCreateTaskUseCase.call(_fixture))
          .thenAnswer((_) async => Left(AppFailure(msg: 'Error')));

      await controller.createTask(fakeTaskModel);

      expect(controller.status, isA<TaskStatusError>());
      expect((controller.status as TaskStatusError).message, 'Error');
      verify(mockCreateTaskUseCase.call(_fixture)).called(1);
    });
  });

  group('deleteTask', () {
    test('should remove task and set status to idle', () async {
      final _task = fakeTaskEntity;
      controller.addTask(_task);

      when(mockDeleteTaskUseCase.call(_task.id))
          .thenAnswer((_) async => Right(true));

      await controller.deleteTask(_task);

      expect(controller.filteredTasks.contains(_task), false);
      expect(controller.status, isA<TaskStatusIdle>());
      verify(mockDeleteTaskUseCase.call(_task.id)).called(1);
    });
  });

  group('updateTask', () {
    test('should update task and set status to idle on success', () async {
      final _oldTask = fakeTaskEntity;
      final _updatedTask = fakeTaskEntityEdited;
      controller.addTask(_oldTask);

      when(mockUpdateTaskUseCase.call(_updatedTask))
          .thenAnswer((_) async => Right(_updatedTask));

      await controller.updateTask(_updatedTask);

      expect(controller.filteredTasks.contains(_updatedTask), true);
      expect(controller.status, isA<TaskStatusIdle>());
      verify(mockUpdateTaskUseCase.call(_updatedTask)).called(1);
    });

    test('should set status to error on failure', () async {
      final _task = fakeTaskEntity;
      when(mockUpdateTaskUseCase.call(_task))
          .thenAnswer((_) async => Left(AppFailure(msg: 'Error')));

      await controller.updateTask(_task);

      expect(controller.status, isA<TaskStatusError>());
      expect((controller.status as TaskStatusError).message, 'Error');
      verify(mockUpdateTaskUseCase.call(_task)).called(1);
    });
  });

  group('toggleDone', () {
    test('should toggle the isDone status of the task', () {
      final _task = fakeTaskEntity;
      controller.addTask(_task);
      controller.changeNavigator(1);
      when(mockUpdateTaskUseCase.call(_task))
          .thenAnswer((_) async => Right(_task));
      controller.toggleDone(_task);

      expect(controller.filteredTasks.contains(_task), true);
      expect(controller.filteredTasks.first.isDone, true);
    });
  });

  group('changeNavigator', () {
    test('should update page navigator and notify listeners', () {
      controller.changeNavigator(1);

      expect(controller.pageStatusNavigator, 1);
    });
  });
}
