import 'package:discipline/presintation/style/containet_style.dart';
import 'package:discipline/presintation/style/widgets_style.dart';
import 'package:flutter/material.dart';

import '../../style/app_text_styles.dart';
import '../../style/main_style.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      padding: const EdgeInsets.all(20),
      decoration: ContainerStyle.primaryContainerStyle,
      child: const TextField(
        maxLines: null,
        expands: true,
        style: AppTextStyles.label,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Запустить свой первый продукт',
        ),
      ),
    );
  }
}
