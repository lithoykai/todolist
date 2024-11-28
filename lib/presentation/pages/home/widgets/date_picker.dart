import 'package:flutter/material.dart';

class DatePickerWidget extends StatelessWidget {
  final DateTime firstData;
  final DateTime lastDate;
  final DateTime selectedDate;
  final Function(DateTime) onChangeDate;

  const DatePickerWidget({
    Key? key,
    required this.selectedDate,
    required this.onChangeDate,
    required this.firstData,
    required this.lastDate,
  }) : super(key: key);

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

      onChangeDate(pickedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _showDatePicker(context, firstData, lastDate),
      icon: Icon(
        Icons.calendar_month_rounded,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
