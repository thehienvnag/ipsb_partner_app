import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimePicker extends StatelessWidget {
  final String label;
  final Function(DateTime?) onSubmitted;
  final String formatPattern;
  final String? previousDate;
  final String? Function(DateTime?)? validator;
  final String? value;
  const DateTimePicker({
    Key? key,
    required this.label,
    required this.onSubmitted,
    this.formatPattern = 'dd-MM-yyyy (hh:mm)',
    this.previousDate,
    this.validator,
    this.value,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return DateTimeField(
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: Icon(Icons.calendar_today),
        filled: true,
        fillColor: Color(0xffF9F7F7),
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black12),
        ),
      ),
      format: DateFormat(formatPattern),
      onShowPicker: (context, currentValue) async {
        DateTime now = DateTime.now();
        final date = await showDatePicker(
            context: context,
            firstDate: now,
            initialDate: currentValue ?? now,
            lastDate: DateTime.now().add(Duration(days: 365 * 10)));
        if (date != null) {
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(
              currentValue ?? now,
            ),
            builder: (context, child) => MediaQuery(
              data:
                  MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
              child: child!,
            ),
          );
          return DateTimeField.combine(date, time);
        } else {
          return currentValue;
        }
      },
      onFieldSubmitted: onSubmitted,
      onChanged: onSubmitted,
      validator: validator,
      initialValue: value != null ? DateTime.parse(value!) : null,
    );
  }
}
