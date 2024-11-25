import 'package:todolist/data/models/task_mapper.dart';
import 'package:todolist/domain/entities/task_entity.dart';

class TaskModel {
  final String id;
  final String name;
  final String description;
  final PriorityStatus priority;
  final DateTime date;
  final bool isDone;

  TaskModel({
    required this.id,
    required this.name,
    required this.description,
    required this.priority,
    required this.date,
    required this.isDone,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) =>
      $TaskModelfromJson(json);
  Map<String, dynamic> toJson() => $TaskModelToJson(this);
  factory TaskModel.fromEntity(TaskEntity entity) =>
      $TaskModelFromEntity(entity);
  TaskEntity toEntity() => $TaskModelToEntity(this);
}
