import 'package:flutter/material.dart';

import '../../style/app_text_styles.dart';
import '../../style/main_style.dart';

class SettingsWidget extends StatefulWidget {
  const SettingsWidget({super.key});

  @override
  State<SettingsWidget> createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  bool dailyPlan = true;
  bool focusProtection = true;
  bool aiConfirmation = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SettingItem(
          title: 'Ежедневный план в 8:00',
          value: dailyPlan,
          onChanged: (value) {
            setState(() => dailyPlan = value);
          },
        ),

        const SizedBox(height: 24),

        SettingItem(
          title: 'Строгая защита фокуса',
          value: focusProtection,
          onChanged: (value) {
            setState(() => focusProtection = value);
          },
        ),

        const SizedBox(height: 24),

        SettingItem(
          title: 'Подтверждение через ИИ',
          value: aiConfirmation,
          onChanged: (value) {
            setState(() => aiConfirmation = value);
          },
        ),
      ],
    );
  }
}


class SettingItem extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SettingItem({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 92,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFF29312C),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextStyles.body
          ),

          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.black,
            activeTrackColor: MainStyle.actionColor,
            inactiveThumbColor: Colors.black,
            inactiveTrackColor: const Color(0xFF202522),
          ),
        ],
      ),
    );
  }
}

