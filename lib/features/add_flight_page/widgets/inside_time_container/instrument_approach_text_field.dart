import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../theme/theme.dart';

class InstrumentApproachTextField extends StatelessWidget {
  final TextEditingController controller;
  const InstrumentApproachTextField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
      ],
      controller: controller,
      style: TextStyle(color: Colors.white),
      decoration:
      _customInputDecoration('Instrument Approach')
          .copyWith(
        suffixIcon: IconButton(
          icon: Icon(
            Icons.add,
            color: Colors.green,
            size: 30,
          ),
          onPressed: () {
            int currentValue = int.tryParse(
                controller
                    .text) ??
                0;
            controller.text =
                (currentValue + 1).toString();
          },
        ),
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
