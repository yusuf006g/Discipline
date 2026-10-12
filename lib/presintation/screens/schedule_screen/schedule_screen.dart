import 'package:discipline/presintation/widgets/schedule/streak_widget.dart';
import 'package:flutter/material.dart';
import '../../style/app_text_styles.dart';
import '../../widgets/main/app_bar_widget.dart';
import '../../widgets/main/drawer_widget.dart';
import '../../widgets/schedule/info_widget.dart';
import '../../widgets/schedule/week_schedule.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(),
      endDrawer: const DrawerWidget(part: 4,),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Итоги недели · 7–13 сентября', style: AppTextStyles.heading,),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: const Text('Ваша дисциплина в цифрах.', style: AppTextStyles.display,),
          ),
          InfoRow(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: WeekScheduleWidget(),
          ),
          const Text('Сила привычек',style: AppTextStyles.middleText,),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: StreakWidget(),
          ),
        ]
      ),
    );
  }
}
