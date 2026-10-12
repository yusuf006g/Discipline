import 'package:discipline/presintation/widgets/awward/duration_level.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../style/app_text_styles.dart';
import '../../widgets/awward/reward_widget.dart';
import '../../widgets/awward/weekly_xp_widget.dart';
import '../../widgets/main/app_bar_widget.dart';
import '../../widgets/main/drawer_widget.dart';

class AwardScreen extends StatelessWidget {
  const AwardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(),
      endDrawer: const DrawerWidget(part: 5,),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
        const Text('Сезон 03 · осталось 18 дней', style: AppTextStyles.heading,),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: const Text('Заслужите свой ранг.', style: AppTextStyles.display,),
          ),
          const Text('Постоянство даёт результат. Каждое подтверждённое действие ведёт вперёд.', ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: DurationLevel(prosent: 2480,),
          ),
          
          Text('Путь по уровням', style: AppTextStyles.heading,),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: LevelsWidget(),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'На этой неделе',
                style: AppTextStyles.body,
              ),
              TextButton(child: Text('еще', style: AppTextStyles.miniGreenText,), onPressed: (){
                context.go('/week_xp');
              } ,)
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: WeeklyXpWidget(),
          )
        ]
      ),
    );
  }
}
