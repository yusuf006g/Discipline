import 'package:flutter/material.dart';
import 'package:discipline/presintation/style/app_text_styles.dart';
import '../../style/main_style.dart';
import '../../widgets/main/app_bar_widget.dart';
import '../../widgets/main/drawer_widget.dart';
import '../../widgets/focuse/bloc_widget.dart';
import '../../widgets/focuse/timer_widget.dart';

class FocuseScreen extends StatelessWidget {
  const FocuseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool protectionEnabled = true;
    return Scaffold(
      appBar: const AppBarWidget(),
      endDrawer: DrawerWidget(part: 2),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                    Text('Сеанс глубокой работы', style: AppTextStyles.body,),
                Row(
                  children: [
                    Icon(Icons.lock_outline, color: MainStyle.dangerColor),
                    Text(' строго', style: AppTextStyles.bodyRed,),
                  ],
                ),
              ],
            ),
          ),
          Text('Подготовить описание продукта', style: AppTextStyles.heading,),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 30.0),
            child: TimerWidget(),
          ),
          BlocWidget()
        ],
      ),
    );
  }
}
