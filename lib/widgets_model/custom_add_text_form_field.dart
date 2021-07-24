import 'package:flutter/material.dart';

class CustomAddTextFormField extends StatelessWidget {
  final String? label, hint, initialValue;
  final Function? onSave;
  final Function? validator;
  final TextInputType? keyboardType;

  const CustomAddTextFormField(
      {Key? key,
      this.label,
      this.hint,
      this.initialValue,
      this.onSave,
      this.validator,
      this.keyboardType
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      keyboardType: keyboardType,
      onSaved: onSave as void Function(String?)?,
      validator: validator as String? Function(String?)?,
      decoration: InputDecoration(
          labelText: label,
          fillColor: Colors.white,
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          hintStyle: TextStyle(
            color: Colors.grey,
          )),
    );
  }
}
