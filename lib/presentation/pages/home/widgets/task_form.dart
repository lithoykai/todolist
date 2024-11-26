import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todolist/data/models/task_model.dart';
import 'package:todolist/di/di.dart';
import 'package:todolist/infra/theme/theme_constants.dart';
import 'package:todolist/presentation/pages/controller/task_controller.dart';
import 'package:todolist/presentation/pages/home/widgets/date_picker.dart';

class TaskForm extends StatefulWidget {
  const TaskForm({super.key});

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final taskController = getIt<TaskController>();

  int priority = 0;
  Map<String, dynamic> _taskForm = {
    'priority': 0,
  };
  DateTime selectedDate = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  final FocusNode titleFocus = FocusNode();
  final FocusNode descriptionFocus = FocusNode();

  @override
  void dispose() {
    titleFocus.dispose();
    descriptionFocus.dispose();
    super.dispose();
  }

  changePriority(int value) {
    setState(() {
      priority = value;
      _taskForm['priority'] = value;
    });
  }

  String getRandString(int len) {
    var random = Random.secure();
    var values = List<int>.generate(len, (i) => random.nextInt(255));
    return base64UrlEncode(values);
  }

  onSubmited() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }

    _taskForm['id'] = getRandString(15);
    TaskModel model = TaskModel.fromJson(_taskForm);

    try {
      await taskController.createTask(model);
      if (taskController.status is TaskStatusError) {
        _showAlert((taskController.status as TaskStatusError).message);
      } else {
        if (mounted) {
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      _showAlert('Erro inesperado: $e');
    }
  }

  void _showAlert(String message) {
    showAdaptiveDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(message),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK"))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(ThemeConstants.padding),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(ThemeConstants.mediumPadding),
          topRight: Radius.circular(ThemeConstants.mediumPadding),
        ),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              focusNode: titleFocus,
              decoration: InputDecoration(
                filled: true,
                fillColor: Theme.of(context).colorScheme.onPrimary,
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(
                    Radius.circular(ThemeConstants.halfPadding),
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(
                    Radius.circular(ThemeConstants.halfPadding),
                  ),
                ),
                hintText: 'Digite o título da task',
                hintStyle: const TextStyle(
                  color: Colors.black26,
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Digite o título da task';
                }
                return null;
              },
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(descriptionFocus);
              },
              onSaved: (value) {
                _taskForm['title'] = value;
              },
            ),
            const SizedBox(height: ThemeConstants.padding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text('Prioridade: '),
                    const SizedBox(
                      width: ThemeConstants.halfPadding,
                    ),
                    GestureDetector(
                      onTap: () => changePriority(0),
                      child: Container(
                        height: 24,
                        width: 24,
                        decoration: BoxDecoration(
                            color: priority == 0
                                ? Colors.green.shade500
                                : Colors.green.shade200,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: priority == 0
                                  ? Colors.black26
                                  : Colors.transparent,
                            )),
                      ),
                    ),
                    const SizedBox(
                      width: ThemeConstants.halfPadding,
                    ),
                    GestureDetector(
                      onTap: () => changePriority(1),
                      child: Container(
                        height: 24,
                        width: 24,
                        decoration: BoxDecoration(
                            color: priority == 1
                                ? Colors.yellow.shade500
                                : Colors.yellow.shade200,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: priority == 1
                                  ? Colors.black26
                                  : Colors.transparent,
                            )),
                      ),
                    ),
                    const SizedBox(
                      width: ThemeConstants.halfPadding,
                    ),
                    GestureDetector(
                      onTap: () => changePriority(2),
                      child: Container(
                        height: 24,
                        width: 24,
                        decoration: BoxDecoration(
                            color: priority == 2
                                ? Colors.red.shade500
                                : Colors.red.shade200,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: priority == 2
                                  ? Colors.black26
                                  : Colors.transparent,
                            )),
                      ),
                    ),
                    DatePickerWidget(
                      selectedDate: selectedDate,
                      onChangeDate: (DateTime value) {
                        setState(() {
                          selectedDate = value;
                          _taskForm['date'] = value.toIso8601String();
                        });
                      },
                      firstData: DateTime.now(),
                      lastDate: DateTime(2026),
                    ),
                    Text(
                      DateFormat.d().format(selectedDate),
                    ),
                  ],
                ),
                ListenableBuilder(
                    listenable: taskController,
                    builder: (context, child) {
                      return ClipOval(
                        child: Material(
                          color: Theme.of(context).colorScheme.primary,
                          child: InkWell(
                            splashColor: Colors.white24,
                            onTap: onSubmited,
                            child: SizedBox(
                              width: 50,
                              height: 50,
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                            ),
                          ),
                        ),
                      );
                    })
              ],
            ),
          ],
        ),
      ),
    );
  }
}
