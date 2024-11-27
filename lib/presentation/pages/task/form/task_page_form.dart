import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todolist/data/models/task_model.dart';
import 'package:todolist/domain/entities/task_entity.dart';
import 'package:todolist/infra/theme/theme_constants.dart';

class TaskPageForm extends StatefulWidget {
  TaskEntity task;
  void Function(TaskEntity)? onSave;
  TaskPageForm({super.key, required this.task, this.onSave});

  @override
  State<TaskPageForm> createState() => _TaskPageFormState();
}

class _TaskPageFormState extends State<TaskPageForm> {
  late DateTime selectedDate;
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> _formData = <String, dynamic>{};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      selectedDate = widget.task.date ?? DateTime.now();
      Map<String, dynamic> model = TaskModel.fromEntity(widget.task).toJson();
      _formData = model;
    });
  }

  _showDatePicker(
    BuildContext context,
    DateTime firstData,
    DateTime lastDate,
  ) {
    showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: firstData,
      lastDate: lastDate,
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }

      setState(() {
        selectedDate = pickedDate;
      });
    });
  }

  void save() {
    TaskEntity task = TaskModel.fromJson(_formData).toEntity();
    print(_formData);
    if (widget.onSave != null) {
      widget.onSave!(task);
    }
  }

  bool sameEntity() {
    print('FORM DATA: $_formData');
    return TaskModel.fromEntity(widget.task).toJson() == _formData;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: ThemeConstants.mediumPadding),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: 50,
                  child: DropdownButtonFormField(
                    padding: EdgeInsets.zero,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: ThemeConstants.padding),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.secondary,
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(ThemeConstants.mediumPadding)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    value: widget.task.priority,
                    items: PriorityStatus.values
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    height: 10,
                                    width: 10,
                                    decoration: BoxDecoration(
                                      color: priorityColor(e),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(
                                      width: ThemeConstants.halfPadding),
                                  Text(e.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium),
                                ],
                              ),
                            ))
                        .toList(),
                    onChanged: (value) {},
                  ),
                ),
                TextFormField(
                  initialValue: widget.task.title,
                  style: Theme.of(context).textTheme.titleLarge,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _formData['title'] = value;
                    });
                    save();
                  },
                ),
                TextFormField(
                  initialValue: widget.task.description ?? '',
                  style: Theme.of(context).textTheme.bodyLarge,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    hintStyle: TextStyle(
                      color: Colors.black26,
                    ),
                    hintText: 'Adicione uma descrição para sua tarefa...',
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                  minLines: 3,
                  maxLines: 10,
                  onChanged: (value) {
                    setState(() {
                      _formData['description'] = value;
                    });
                    save();
                  },
                ),
                Divider(
                  color: Theme.of(context).colorScheme.onPrimary.withAlpha(100),
                ),
                ListTile(
                  title: Row(
                    children: [
                      Icon(
                        Icons.date_range,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: ThemeConstants.halfPadding),
                      Text(
                        'Data prevista',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                    ],
                  ),
                  trailing: Text(
                    DateFormat('dd/MM/yyyy').format(selectedDate),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary),
                  ),
                  onTap: () =>
                      _showDatePicker(context, DateTime.now(), DateTime(2025)),
                ),
                Divider(
                  color: Theme.of(context).colorScheme.onPrimary.withAlpha(100),
                ),
                ListTile(
                  title: Row(
                    children: [
                      Icon(
                        Icons.pending,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: ThemeConstants.halfPadding),
                      Text(
                        'Status',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                    ],
                  ),
                  trailing: Text(
                    widget.task.isDone ? 'Concluída' : 'Pendente',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ),
                Divider(
                  color: Theme.of(context).colorScheme.onPrimary.withAlpha(100),
                ),
              ],
            ),
          )),
    );
  }

  Color priorityColor(PriorityStatus priority) {
    switch (priority) {
      case PriorityStatus.low:
        return Colors.green;
      case PriorityStatus.medium:
        return Colors.yellow;
      case PriorityStatus.high:
        return Colors.red;
    }
  }
}
