import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'task_entity.g.dart';

@HiveType(typeId: 0)
class TaskEntity extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final PriorityStatus priority;
  @HiveField(4)
  final DateTime date;
  @HiveField(5)
  final bool isDone;

  const TaskEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.priority,
    required this.date,
    required this.isDone,
  });

  @override
  List<Object?> get props => [id, name, description, priority, date, isDone];
}

enum PriorityStatus { low, medium, high }