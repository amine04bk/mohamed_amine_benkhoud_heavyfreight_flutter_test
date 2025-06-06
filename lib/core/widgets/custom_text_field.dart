import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final IconData? prefixIcon;
  final bool readOnly;
  final VoidCallback? onTap;

  const CustomTextField({
    required this.hintText,
    this.prefixIcon,
    this.readOnly = false,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon: const Icon(Icons.search, color: AppColors.textGrey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.lightGrey),
        ),
        filled: true,
        fillColor: AppColors.lightGrey.withOpacity(0.2),
      ),
    );
  }
}