// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskEntityAdapter extends TypeAdapter<TaskEntity> {
  @override
  final int typeId = 0;

  @override
  TaskEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskEntity(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String?,
      priority: fields[3] as PriorityStatus,
      date: fields[4] as DateTime?,
      isDone: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, TaskEntity obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.priority)
      ..writeByte(4)
      ..write(obj.date)
      ..writeByte(5)
      ..write(obj.isDone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PriorityStatusAdapter extends TypeAdapter<PriorityStatus> {
  @override
  final int typeId = 1;

  @override
  PriorityStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PriorityStatus.low;
      case 1:
        return PriorityStatus.medium;
      case 2:
        return PriorityStatus.high;
      default:
        return PriorityStatus.low;
    }
  }

  @override
  void write(BinaryWriter writer, PriorityStatus obj) {
    switch (obj) {
      case PriorityStatus.low:
        writer.writeByte(0);
        break;
      case PriorityStatus.medium:
        writer.writeByte(1);
        break;
      case PriorityStatus.high:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PriorityStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
