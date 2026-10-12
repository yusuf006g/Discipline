import 'package:flutter/material.dart';
import 'package:discipline/presintation/style/app_text_styles.dart';
import 'package:discipline/presintation/style/main_style.dart';

import '../../style/containet_style.dart';

class ExStaticsWidget extends StatelessWidget {
  final int level;
  final int xp;
  final int prosent;
  final int left;
  final String status;

  const ExStaticsWidget({
    super.key,
    required this.level,
    required this.xp,
    required this.prosent,
    required this.left,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: ContainerStyle.primaryContainerStyle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'УРОВЕНЬ $level · ОПЕРАТОР',
                      style: AppTextStyles.body,
                    ),

                    const SizedBox(height: 12),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '$xp',
                          style: AppTextStyles.display,
                        ),

                        const SizedBox(width: 6),

                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            'XP',
                            style: AppTextStyles.body,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: MainStyle.actionColor,
                    width: 4,
                  ),
                ),
                child: Center(
                  child: Text(
                    '$prosent%',
                    style: AppTextStyles.heading,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          Container(
            height: 16,
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: (prosent / 100).clamp(0.0, 1.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: MainStyle.actionColor,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          Text(
            '$left XP до уровня «$status»',
            style: AppTextStyles.body.copyWith(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}