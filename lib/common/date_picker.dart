import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerFormField extends StatelessWidget {
  final String labelText;
  final DateTime initialDate;
  final Function(DateTime) onDateSelected;
  final String? Function(DateTime?)? validator;

  const DatePickerFormField({
    Key? key,
    required this.labelText,
    required this.initialDate,
    required this.onDateSelected,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormField<DateTime>(
      validator: validator,
      initialValue: initialDate,
      builder: (formFieldState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: labelText,
                border: const OutlineInputBorder(),
                suffixIcon: const Icon(Icons.calendar_today),
                errorText: formFieldState.hasError 
                    ? formFieldState.errorText 
                    : null,
              ),
              controller: TextEditingController(
                text: DateFormat('yyyy-MM-dd').format(initialDate),
              ),
              readOnly: true,
              onTap: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: initialDate,
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (selectedDate != null) {
                  onDateSelected(selectedDate);
                  formFieldState.didChange(selectedDate);
                }
              },
            ),
          ],
        );
      },
    );
  }
}