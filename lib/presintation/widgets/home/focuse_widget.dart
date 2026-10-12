import 'package:flutter/material.dart';
import 'package:discipline/presintation/style/containet_style.dart';

import '../../style/app_text_styles.dart';

class FocusWidget extends StatelessWidget {
  final String time;
  final int percent;

  const FocusWidget({
    super.key,
    required this.time,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: ContainerStyle.primaryContainerStyle,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Фокус на  сегодня',
                  style: AppTextStyles.label,
                ),
                const SizedBox(height: 8),
                Text(
                  time,
                  style: AppTextStyles.titleText,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 8),

        Expanded(
          child: Container(
            decoration: ContainerStyle.primaryContainerStyle,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Результат недели',
                  style: AppTextStyles.label,
                ),
                const SizedBox(height: 8),
                Text(
                  '$percent%',
                  style: AppTextStyles.titleText,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}