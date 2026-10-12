import 'package:discipline/presintation/style/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../style/main_style.dart';
import '../../widgets/awward/weekly_xp_widget.dart';

class WeekXpScreen extends StatelessWidget {
  const WeekXpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('На этой неделе', style: AppTextStyles.WhiteHeading,),
        leading: BackButton(
          onPressed: () => context.go('/award'),
          color: Colors.white,
        ),
        backgroundColor: MainStyle.backgrountColor,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            WeeklyXpItem(
              icon: Icons.verified_user_outlined,
              title: 'Проверенные задачи',
              xp: '+360',
              color: MainStyle.actionColor,
            ),

            const SizedBox(height: 18),

            WeeklyXpItem(
              icon: Icons.center_focus_strong,
              title: 'Глубокий фокус',
              xp: '+180',
              color: MainStyle.actionColor,
            ),

            const SizedBox(height: 18),

            WeeklyXpItem(
              icon: Icons.local_fire_department_outlined,
              title: 'Серия из 12 дней',
              xp: '+120',
              color: MainStyle.actionColor,
            ),
          ],
        ),
      ),
    );
  }
}
