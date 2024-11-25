import 'package:todolist/data/models/task_model.dart';
import 'package:todolist/domain/entities/task_entity.dart';

TaskModel fakeTaskModel = TaskModel(
    id: 'fakeId',
    name: 'fakeName',
    description: 'Hello, this is a fake description',
    priority: PriorityStatus.low,
    date: DateTime.now(),
    isDone: false);

TaskEntity fakeTaskEntity = TaskEntity(
    id: 'fakeId',
    name: 'fakeName',
    description: 'Hello, this is a fake description',
    priority: PriorityStatus.low,
    date: DateTime.now(),
    isDone: false);
