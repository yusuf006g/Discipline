import 'package:flutter/material.dart';

import '../../style/app_text_styles.dart';
import '../../style/main_style.dart';

class FirstStep extends StatelessWidget {
  const FirstStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF141C0B),
        border: Border.all(
          color: MainStyle.actionColor,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.auto_awesome,
            color: MainStyle.actionColor,
            size: 40,
          ),

          const SizedBox(height: 25),

          const Text(
            'Первый шаг на завтра',
            style: AppTextStyles.titleText
          ),

          const SizedBox(height: 10),

          const Text(
            'Напишите 5 вопросов для интервью и назначьте '
                ,
              style: AppTextStyles.label
          ),

          const SizedBox(height: 10),

          Divider(
            color: MainStyle.actionColor.withOpacity(0.4),
          ),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Оценка времени',
                  style: AppTextStyles.body
              ),

              const Text(
                '45 мин · +80 XP',
                  style: AppTextStyles.body,

              ),
            ],
          ),
        ],
      ),
    );
  }
}
