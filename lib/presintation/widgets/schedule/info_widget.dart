import 'package:discipline/presintation/style/app_text_styles.dart';
import 'package:discipline/presintation/style/containet_style.dart';
import 'package:flutter/material.dart';


class InfoWidget extends StatelessWidget {
  final String main;
  final String discribe;
  const InfoWidget({super.key, required this.main, required this.discribe});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ContainerStyle.primaryContainerStyle,
      padding: EdgeInsets.all(15),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(main, style: AppTextStyles.middleGreenText,),
          Text(discribe, style: AppTextStyles.label,)
        ],
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  const InfoRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InfoWidget(
            main: '87%',
            discribe: 'Выполнено',
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: InfoWidget(
            main: '9.4 ч',
            discribe: 'Фокус',
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: InfoWidget(
            main: '12',
            discribe: 'Серия',
          ),
        ),
      ],
    );
  }
}