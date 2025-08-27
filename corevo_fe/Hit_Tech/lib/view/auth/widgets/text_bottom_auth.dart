import 'package:flutter/material.dart';
import 'package:hit_tech/core/constants/app_color.dart';

import '../../../core/constants/app_dimension.dart';

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
          style: TextStyle(
            color: AppColors.bNormal,
            fontSize: AppDimensions.textSizeM,
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
