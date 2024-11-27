import 'package:todolist/data/models/task_model.dart';
import 'package:todolist/domain/entities/task_entity.dart';

TaskModel $TaskModelFromEntity(TaskEntity entity) {
  return TaskModel(
    id: entity.id,
    title: entity.title,
    description: entity.description,
    priority: entity.priority,
    date: entity.date,
    isDone: entity.isDone,
  );
}

TaskEntity $TaskModelToEntity(TaskModel model) {
  return TaskEntity(
    id: model.id,
    title: model.title,
    description: model.description,
    priority: model.priority,
    date: model.date,
    isDone: model.isDone,
  );
}

TaskModel $TaskModelfromJson(Map<String, dynamic> json) {
  return TaskModel(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    priority: PriorityStatus.values[json['priority']],
    date: json['date'] != null ? DateTime.parse(json['date']) : null,
    isDone: json['isDone'] ?? false,
  );
}

Map<String, dynamic> $TaskModelToJson(TaskModel instance) {
  return {
    'id': instance.id,
    'title': instance.title,
    'description': instance.description,
    'priority': instance.priority.index,
    'date': instance.date?.toIso8601String() ?? '',
    'isDone': instance.isDone,
  };
}
