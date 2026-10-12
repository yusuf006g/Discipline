import 'package:discipline/presintation/style/containet_style.dart';
import 'package:flutter/material.dart';

import '../../style/app_text_styles.dart';
import '../../style/main_style.dart';

class AwardWidget extends StatelessWidget {
  final int award;
  final double progres;
  const AwardWidget({super.key, required this.award, required this.progres});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 450,
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 8,
      ),
      decoration: ContainerStyle.primaryContainerStyle,
      child: Row(
        children: [
          Icon(
            Icons.bolt_outlined,
            color: MainStyle.actionColor,
            size: 50,
          ),

          const SizedBox(width: 10),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '+$award XP',
                style: AppTextStyles.display,
              ),

              const SizedBox(height: 4),

              Text(
                'Множитель качества · $progres×',
                style: TextStyle(
                  color: Color(0xFF9A9D98),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
