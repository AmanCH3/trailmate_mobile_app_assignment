import 'package:flutter/material.dart';

class CommonTextformView extends StatelessWidget {
  final TextEditingController controller;

  final String label;

  final String hint;

  final String validatorMsg;

  final IconData icon;

  final Color fillColor;

  final Color textColor;

  const CommonTextformView({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.validatorMsg,
    required this.icon,
    required this.fillColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
        filled: true,
        fillColor: fillColor,
        prefixIcon: Icon(icon, color: textColor),
        labelText: label,
        labelStyle: TextStyle(color: textColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validatorMsg;
        }
        return null;
      },
    );
  }
}
