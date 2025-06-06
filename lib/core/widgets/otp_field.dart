import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class OTPField extends StatelessWidget {
  const OTPField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(4, (index) {
        return Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primaryOrange),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Center(
            child: TextField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 1,
              decoration: InputDecoration(
                border: InputBorder.none,
                counterText: '',
              ),
            ),
          ),
        );
      }),
    );
  }
}