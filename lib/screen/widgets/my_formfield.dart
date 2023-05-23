import 'package:flutter/material.dart';

class MyFormFiled extends StatelessWidget {
  String? hint;
  TextInputType? inputType;
  final String? Function(String?) validator;
  TextEditingController controller;

  MyFormFiled({
    super.key,
    required this.hint,
    this.inputType,
    required this.validator,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: inputType == null ? TextInputType.text : inputType,
      controller: controller,
      decoration: InputDecoration(
        labelText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      validator: validator,
    );
  }
}
