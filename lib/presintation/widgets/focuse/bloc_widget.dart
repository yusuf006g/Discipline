import 'package:discipline/presintation/style/app_text_styles.dart';
import 'package:discipline/presintation/style/containet_style.dart';
import 'package:discipline/presintation/style/main_style.dart';
import 'package:flutter/material.dart';

class BlocWidget extends StatefulWidget {
  const BlocWidget({super.key});

  @override
  State<BlocWidget> createState() => _BlocWidgetState();
}

class _BlocWidgetState extends State<BlocWidget> {
  bool value = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: ContainerStyle.redContainerStyle,
      child: Row(
        children: [
          Icon(
            size: 40,
            Icons.lock_outline,
            color: MainStyle.dangerColor,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Защита от отвлечений',
                  style: AppTextStyles.body,
                ),

                const SizedBox(height: 4),

                Text(
                  'Приложения и уведомления заблокированы',
                  style: AppTextStyles.label,
                ),
              ],
            ),
          ),

          Switch(
            value: value,
            onChanged: (newValue) {
              setState(() {
                value = newValue;
              });
            },
            activeThumbColor: Colors.black,
            activeTrackColor: MainStyle.dangerColor,
            inactiveThumbColor: Colors.black,
            inactiveTrackColor: const Color(0xFF202522),
          ),
        ],
      ),
    );
  }
}