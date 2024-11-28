import 'package:todolist/data/models/task_model.dart';
import 'package:todolist/domain/entities/task_entity.dart';

TaskModel fakeTaskModel = TaskModel(
    id: 'fakeId',
    title: 'fakeName',
    description: 'Hello, this is a fake description',
    priority: PriorityStatus.low,
    date: DateTime(2024, 11, 28, 12),
    isDone: false);
TaskModel fakeTaskModelTwo = TaskModel(
    id: 'fakeId2',
    title: 'fakeName',
    description: 'Hello, this is a fake description',
    priority: PriorityStatus.low,
    date: DateTime(2024, 11, 28, 12),
    isDone: false);

TaskEntity fakeTaskEntity = TaskEntity(
    id: 'fakeId',
    title: 'fakeName',
    description: 'Hello, this is a fake description',
    priority: PriorityStatus.low,
    date: DateTime(2024, 11, 28, 12),
    isDone: false);
TaskEntity fakeTaskEntityTwo = TaskEntity(
    id: 'fakeId2',
    title: 'fakeName',
    description: 'Hello, this is a fake description',
    priority: PriorityStatus.low,
    date: DateTime(2024, 11, 28, 12),
    isDone: false);

List<Map<String, dynamic>> fakeListTaskJson = [
  {
    "id": "fakeId",
    "title": "fakeName",
    "description": "Hello, this is a fake description",
    "priority": 0,
    "date": "2024-11-28T12:00:00.000",
    "isDone": false
  },
  {
    "id": "fakeId2",
    "title": "fakeName",
    "description": "Hello, this is a fake description",
    "priority": 0,
    "date": "2024-11-28T12:00:00.000",
    "isDone": false
  }
];

List<TaskModel> fakeTaskModelList = [
  fakeTaskModel,
  fakeTaskModelTwo,
];

List<TaskEntity> fakeTaskEntityListResponse = [
  fakeTaskModel.toEntity(),
  fakeTaskModelTwo.toEntity(),
];

TaskEntity fakeTaskEntityEdited = TaskEntity(
    id: 'fakeId',
    title: 'new fake editName',
    description: 'Hello, this is a fake description',
    priority: PriorityStatus.high,
    date: DateTime(2024, 11, 28, 12),
    isDone: false);

List<TaskEntity> fakeTaskEntityList = [
  fakeTaskEntity,
  fakeTaskEntityTwo,
];
