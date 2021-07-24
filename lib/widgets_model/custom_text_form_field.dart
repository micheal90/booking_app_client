import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
 final TextEditingController? controller;
 final String label;
 final String hint;
 final bool isPassword;
 final IconData prefixIcon;
 final Widget? suffixIcon;
 final TextInputType type;
 final String? Function(String?)? validate;
 final Function(String?)? onSave;
  CustomTextFormField({
     this.controller,
    required this.label,
    required this.hint,
    required this.isPassword,
    required this.prefixIcon,
     this.suffixIcon,
    required this.type,
    required this.validate,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      validator: validate,
      onSaved: onSave,
      decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(prefixIcon),
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
    );
  }
}
