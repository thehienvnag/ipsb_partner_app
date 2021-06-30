import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:string_validator/string_validator.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String? Function(String?, String)? validator;
  final Function(String?) onSubmitted;
  final String? value;
  final int? maxLength;
  final double? width;
  final List<TextInputFormatter>? masks;
  final TextInputType? inputType;
  final String? counterText;
  const CustomTextField({
    Key? key,
    required this.label,
    this.validator,
    required this.onSubmitted,
    this.value,
    this.maxLength,
    this.width,
    this.masks,
    this.inputType = TextInputType.text,
    this.counterText,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: TextFormField(
        key: ObjectKey(value),
        maxLines: null,
        initialValue: value ?? '',
        keyboardType: inputType,
        maxLength: maxLength,
        onSaved: (newValue) => onSubmitted(newValue),
        onFieldSubmitted: (value) => onSubmitted(value),
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          labelText: label,
          border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black12),
          ),
          filled: true,
          counterText: counterText,
          fillColor: Color(0xffF9F7F7),
        ),
        validator: validator != null
            ? (value) => validator!(value, label.toLowerCase())
            : null,
        inputFormatters: masks,
      ),
    );
  }
}

class TextFieldValidator {
  static String? require(String? value, String fieldName) {
    if (value == null || value.isEmpty) return 'Vui lòng nhập $fieldName!';
    return null;
  }

  static String? isIntNum(String? value, String fieldName) {
    if (value == null || value.isEmpty) return 'Vui lòng nhập $fieldName!';
    if (isInt(value)) return 'Vui lòng nhập số nguyên cho $fieldName!';
    return null;
  }
}
