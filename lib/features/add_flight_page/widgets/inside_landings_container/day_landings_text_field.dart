import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../theme/theme.dart';

class DayLandingsTextField extends StatelessWidget {
  final TextEditingController dayLdgController;
  final TextEditingController dayToController;
  const DayLandingsTextField({super.key, required this.dayLdgController, required this.dayToController,});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
      ],
      controller: dayLdgController,
      style: TextStyle(color: Colors.white),
      decoration: _customInputDecoration('Day Landings')
          .copyWith(
        suffixIcon: IconButton(
          icon: Icon(
            Icons.add,
            color: Colors.green,
            size: 30,
          ),
          onPressed: () {
            int currentValue =
                int.tryParse(dayLdgController.text) ??
                    0;
            dayLdgController.text =
                (currentValue + 1).toString();
            dayToController.text =
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
