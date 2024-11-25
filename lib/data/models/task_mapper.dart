import 'package:todolist/data/models/task_model.dart';
import 'package:todolist/domain/entities/task_entity.dart';

TaskModel $TaskModelFromEntity(TaskEntity entity) {
  return TaskModel(
    id: entity.id,
    name: entity.name,
    description: entity.description,
    priority: entity.priority,
    date: entity.date,
    isDone: entity.isDone,
  );
}

TaskEntity $TaskModelToEntity(TaskModel model) {
  return TaskEntity(
    id: model.id,
    name: model.name,
    description: model.description,
    priority: model.priority,
    date: model.date,
    isDone: model.isDone,
  );
}

TaskModel $TaskModelfromJson(Map<String, dynamic> json) {
  return TaskModel(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    priority: json['priority'],
    date: DateTime.parse(json['date']),
    isDone: json['isDone'],
  );
}

Map<String, dynamic> $TaskModelToJson(TaskModel instance) {
  return {
    'id': instance.id,
    'name': instance.name,
    'description': instance.description,
    'priority': instance.priority,
    'date': instance.date.toIso8601String(),
    'isDone': instance.isDone,
  };
}
