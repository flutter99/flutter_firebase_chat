import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String? heading;
  final TextEditingController controller;
  final String hintText;
  final bool? isObscure;
  final String? obscureCharacter;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatter;
  final void Function(String)? onChanged;
  final Widget? suffixIcon;
  final TextInputAction? textInputAction;
  final double? fieldHeight;

  const CustomTextField({
    super.key,
    required this.heading,
    required this.controller,
    required this.hintText,
    this.isObscure = false,
    this.obscureCharacter = '*',
    this.keyboardType,
    this.validator,
    this.inputFormatter,
    this.onChanged,
    this.suffixIcon,
    this.textInputAction = TextInputAction.next,
    this.fieldHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        /// heading
        heading == null
            ? const SizedBox()
            : Text(
                heading!,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
        heading == null ? const SizedBox() : const SizedBox(height: 10),

        /// field
        TextFormField(
          controller: controller,
          obscureText: isObscure!,
          obscuringCharacter: obscureCharacter!,
          keyboardType: keyboardType,
          validator: validator,
          inputFormatters: inputFormatter,
          onChanged: onChanged,
          textInputAction: textInputAction,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.withOpacity(0.2),
            hintText: hintText,
            hintStyle: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
            constraints: BoxConstraints.tightFor(
              height: fieldHeight ?? 55,
            ),
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(
                color: Colors.green,
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(
                color: Colors.green,
                width: 1.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(
                color: Colors.green,
                width: 1.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
