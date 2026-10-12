import 'package:discipline/presintation/style/app_text_styles.dart';
import 'package:discipline/presintation/style/containet_style.dart';
import 'package:discipline/presintation/style/main_style.dart';
import 'package:flutter/material.dart';

class DurationLevel extends StatelessWidget {
  final int prosent;

  const DurationLevel({
    super.key,
    required this.prosent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: ContainerStyle.primaryContainerStyle,
      child: Column(
        children: [
          // Верхняя часть
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ТЕКУЩИЙ УРОВЕНЬ',
                    style: AppTextStyles.label,
                  ),

                  const SizedBox(height: 14),

                  Text(
                    'Оператор II',
                    style: AppTextStyles.display,
                  ),
                ],
              ),

              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: MainStyle.actionColor,
                ),
                child: const Icon(
                  Icons.workspace_premium_outlined,
                  size: 40,
                  color: Colors.black,
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          Divider(
            color: const Color(0xFF29312C),
            height: 1,
          ),

          const SizedBox(height: 30),

          // XP
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '2 480 XP',
                style: AppTextStyles.body,
              ),

              Text(
                '3 000 XP',
                style: AppTextStyles.body,
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Прогресс
          Container(
            width: double.infinity,
            height: 18,
            decoration: BoxDecoration(
              color: const Color(0xFF202522),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: (prosent / 3000).clamp(0.0, 1.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: MainStyle.actionColor,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}