import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'task_entity.g.dart';

@HiveType(typeId: 0)
// ignore: must_be_immutable
class TaskEntity extends Equatable with ChangeNotifier {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String? description;
  @HiveField(3)
  final PriorityStatus priority;
  @HiveField(4)
  final DateTime? date;
  @HiveField(5)
  bool isDone;

  TaskEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.date,
    required this.isDone,
  });

  @override
  List<Object?> get props => [id, title, description, priority, date, isDone];

  void toggleDone() {
    isDone = !isDone;
    notifyListeners();
  }
}

@HiveType(typeId: 1)
enum PriorityStatus {
  @HiveField(0)
  low,
  @HiveField(1)
  medium,
  @HiveField(2)
  high
}

extension PriorityStatusExtension on PriorityStatus {
  String get name {
    switch (this) {
      case PriorityStatus.low:
        return 'Baixa';
      case PriorityStatus.medium:
        return 'Média';
      case PriorityStatus.high:
        return 'Alta';
    }
  }
}
