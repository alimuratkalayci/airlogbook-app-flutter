import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../theme/theme.dart';

class HobbsInTextField extends StatelessWidget {
  final TextEditingController controller;

  const HobbsInTextField({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
      ],
      controller: controller,
      decoration: _customInputDecoration('Hobbs In'),
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16.0,
      ),
      validator: (value) {
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
