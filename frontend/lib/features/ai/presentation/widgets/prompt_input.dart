import 'package:flutter/material.dart';

class PromptInput extends StatelessWidget {
  const PromptInput({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
      ),
      validator: (val) {
        if (val == null || val.isEmpty) {
          return 'This field is required';
        }
        return null;
      },
    );
  }
}
