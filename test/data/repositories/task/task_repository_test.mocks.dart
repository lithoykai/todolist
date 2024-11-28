// Mocks generated by Mockito 5.4.4 from annotations
// in todolist/test/data/repositories/task/task_repository_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:mockito/mockito.dart' as _i1;
import 'package:todolist/data/datasource/task/task_datasource.dart' as _i3;
import 'package:todolist/data/models/task_model.dart' as _i5;
import 'package:todolist/domain/entities/task_entity.dart' as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeTaskEntity_0 extends _i1.SmartFake implements _i2.TaskEntity {
  _FakeTaskEntity_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [ITaskDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockITaskDataSource extends _i1.Mock implements _i3.ITaskDataSource {
  MockITaskDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<List<_i2.TaskEntity>> getTasks() => (super.noSuchMethod(
        Invocation.method(
          #getTasks,
          [],
        ),
        returnValue: _i4.Future<List<_i2.TaskEntity>>.value(<_i2.TaskEntity>[]),
      ) as _i4.Future<List<_i2.TaskEntity>>);

  @override
  _i4.Future<_i2.TaskEntity> createTask(_i5.TaskModel? task) =>
      (super.noSuchMethod(
        Invocation.method(
          #createTask,
          [task],
        ),
        returnValue: _i4.Future<_i2.TaskEntity>.value(_FakeTaskEntity_0(
          this,
          Invocation.method(
            #createTask,
            [task],
          ),
        )),
      ) as _i4.Future<_i2.TaskEntity>);

  @override
  _i4.Future<_i2.TaskEntity> updateTask(_i2.TaskEntity? task) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateTask,
          [task],
        ),
        returnValue: _i4.Future<_i2.TaskEntity>.value(_FakeTaskEntity_0(
          this,
          Invocation.method(
            #updateTask,
            [task],
          ),
        )),
      ) as _i4.Future<_i2.TaskEntity>);

  @override
  _i4.Future<bool> deleteTask(String? id) => (super.noSuchMethod(
        Invocation.method(
          #deleteTask,
          [id],
        ),
        returnValue: _i4.Future<bool>.value(false),
      ) as _i4.Future<bool>);
}
