import 'package:todolist/data/models/task_model.dart';
import 'package:todolist/domain/entities/task_entity.dart';

TaskModel fakeTaskModel = TaskModel(
    id: 'fakeId',
    title: 'fakeName',
    description: 'Hello, this is a fake description',
    priority: PriorityStatus.low,
    date: DateTime.now(),
    isDone: false);

TaskEntity fakeTaskEntity = TaskEntity(
    id: 'fakeId',
    title: 'fakeName',
    description: 'Hello, this is a fake description',
    priority: PriorityStatus.low,
    date: DateTime.now(),
    isDone: false);
TaskEntity fakeTaskEntityEdited = TaskEntity(
    id: 'fakeId',
    title: 'new fake editName',
    description: 'Hello, this is a fake description',
    priority: PriorityStatus.high,
    date: DateTime.now(),
    isDone: false);
TaskEntity fakeTaskEntityTwo = TaskEntity(
    id: 'fakeId2',
    title: 'fakeName',
    description: 'Hello, this is a fake description',
    priority: PriorityStatus.low,
    date: DateTime.now(),
    isDone: false);

List<TaskModel> fakeTaskModelList = [
  fakeTaskModel,
  fakeTaskModel,
  fakeTaskModel
];
List<TaskEntity> fakeTaskEntityList = [
  fakeTaskEntity,
  fakeTaskEntityTwo,
  fakeTaskEntity
];
