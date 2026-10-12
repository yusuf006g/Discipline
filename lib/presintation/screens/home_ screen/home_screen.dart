import 'package:discipline/presintation/style/app_text_styles.dart';
import 'package:discipline/presintation/style/main_style.dart';
import 'package:discipline/presintation/widgets/main/app_bar_widget.dart';
import 'package:discipline/presintation/widgets/main/drawer_widget.dart';
import 'package:discipline/presintation/widgets/home/ex_statics_widget.dart';
import 'package:discipline/presintation/widgets/home/fire_widget.dart';
import 'package:discipline/presintation/widgets/home/focuse_widget.dart';
import 'package:discipline/presintation/widgets/home/task_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainStyle.backgrountColor,

      endDrawer: const DrawerWidget(part: 1,),
      appBar: AppBarWidget(),

      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Вторник · День 18',
                style: AppTextStyles.miniGreenText,
              ),
              FireWidget(firePoint: 14),
            ],
          ),

          const SizedBox(height: 12),

          const Text(
            'Выиграй этот день, Алекс.',
            style: AppTextStyles.display,
          ),

          const SizedBox(height: 20),

          const ExStaticsWidget(
            status: '1',
            left: 99,
            prosent: 75,
            level: 1,
            xp: 1,
          ),

          const SizedBox(height: 20),

          const Text(
            'План на сегодня',
            style: AppTextStyles.body,
          ),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Три главные задачи',
                style: AppTextStyles.heading,
              ),
              Text(
                '0/3 готово',
                style: AppTextStyles.miniGreenText,
              ),
            ],
          ),

          const SizedBox(height: 20),

          const TaskWidget(
            title: 'Подготовить описание ',
            discibe: 'Глубокая работа · 50 мин',
            bonuses: 120,
          ),

          const SizedBox(height: 20),

          const FocusWidget(
            time: '12ч 15мин',
            percent: 37,
          ),
        ],
      ),
    );
  }
}