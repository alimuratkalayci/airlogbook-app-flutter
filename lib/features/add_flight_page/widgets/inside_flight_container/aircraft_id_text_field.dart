import 'package:flutter/material.dart';
import '../../../../theme/theme.dart';

class AircraftIdTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;

  const AircraftIdTextField({
    Key? key,
    required this.controller,
    required this.labelText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: _customInputDecoration(labelText),
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16.0,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $labelText';
        }
        return null;
      },
    );
  }

  InputDecoration _customInputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: const TextStyle(
        color: AppTheme.TextColorWhite,
      ),
      hintText: 'Enter $labelText',
      hintStyle: const TextStyle(
        color: AppTheme.TextColorWhite,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(
          color: AppTheme.TextColorWhite,
          width: 2.0,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(
          color: AppTheme.TextColorWhite,
          width: 2.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(
          color: AppTheme.Green,
          width: 2.0,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
    );
  }
}
