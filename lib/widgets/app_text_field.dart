import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppTextField extends StatefulWidget {
  final String label;
  final IconData? icon;
  final bool obscure;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  const AppTextField({
    super.key,
    required this.label,
    this.icon,
    this.obscure = false,
    this.controller,
    this.validator,
    this.keyboardType,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _hidden = widget.obscure;

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder border(Color color, double width) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: color, width: width),
        );

    return TextFormField(
      controller: widget.controller,
      obscureText: _hidden,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        labelText: widget.label,
        prefixIcon: widget.icon != null ? Icon(widget.icon) : null,
        suffixIcon: widget.obscure
            ? IconButton(
                icon: Icon(_hidden
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined),
                onPressed: () => setState(() => _hidden = !_hidden),
              )
            : null,
        filled: true,
        fillColor: Colors.white,
        border: border(Colors.transparent, 1),
        enabledBorder: border(Colors.transparent, 1),
        focusedBorder: border(AppColors.primary, 1.5),
      ),
    );
  }
}