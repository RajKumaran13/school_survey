import 'package:flutter/material.dart';

class MultiSelectFormField extends StatelessWidget {
  final String title;
  final List<String> options;
  final List<String> selectedValues;
  final Function(List<String>) onChanged;
  final String? Function(List<String>?)? validator;

  const MultiSelectFormField({
    Key? key,
    required this.title,
    required this.options,
    required this.selectedValues,
    required this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormField<List<String>>(
      validator: validator,
      initialValue: selectedValues,
      builder: (formFieldState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: formFieldState.hasError 
                    ? Colors.red
                    : null,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              children: options.map((option) {
                return FilterChip(
                  label: Text(option),
                  selected: selectedValues.contains(option),
                  onSelected: (selected) {
                    List<String> newValues = List.from(selectedValues);
                    if (selected) {
                      newValues.add(option);
                    } else {
                      newValues.remove(option);
                    }
                    onChanged(newValues);
                    formFieldState.didChange(newValues);
                  },
                );
              }).toList(),
            ),
            if (formFieldState.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  formFieldState.errorText!,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}


