import 'package:flutter/material.dart';
import 'package:hit_tech/core/constants/app_color.dart';

class DividerWithText extends StatelessWidget {
  final String text;

  const DividerWithText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const Expanded(
          child: Divider(
            color: AppColors.bNormal,
            thickness: 1,
            indent: 8,
            endIndent: 8,
          ),
        ),
        Text(
          text,
          style: const TextStyle(
            color: AppColors.bNormal,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Expanded(
          child: Divider(
            color: AppColors.bNormal,
            thickness: 1,
            indent: 8,
            endIndent: 8,
          ),
        ),
      ],
    );
  }
}
