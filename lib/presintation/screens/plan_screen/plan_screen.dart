import 'package:discipline/presintation/widgets/plan/control.dart';
import 'package:discipline/presintation/widgets/plan/first_step.dart';
import 'package:discipline/presintation/widgets/home/task_widget.dart';
import 'package:discipline/presintation/widgets/home/text_field_widget.dart';
import 'package:flutter/material.dart';

import 'package:discipline/presintation/widgets/main/app_bar_widget.dart';
import 'package:discipline/presintation/widgets/main/drawer_widget.dart';
import 'package:go_router/go_router.dart';

import '../../style/app_text_styles.dart';
import '../../style/widgets_style.dart';
import '../../widgets/plan/plan_part_widget.dart';
import '../../widgets/plan/time_widget.dart';

class PlanScreen extends StatelessWidget {
  const PlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(),
      endDrawer: const DrawerWidget(part: 2,),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Конструктор целей · 1/3', style: AppTextStyles.heading,),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text('Определите победу.', style: AppTextStyles.display,),
          ),
          const Text('Будьте точны. Дисциплина начинается с цели, которую стоит защищать.', ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: PlanPartWidget(actionOne: true, actionTwo: false, actionThree: false,),
          ),
          const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ваша долгосрочная цель', style: AppTextStyles.label,),
                  TextFieldWidget()
                ],
              )
          ),
          TimeWidget()
        ],
      ),
    );
  }
}

class PlanSecendPart extends StatelessWidget {
  const PlanSecendPart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(),
      endDrawer: const DrawerWidget(part: 2,),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Конструктор целей · 2/3', style: AppTextStyles.heading,),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text('ИИ построил ваш путь.', style: AppTextStyles.display,),
          ),
          const Text('Реалистичный план на 12 недель, разбитый на конкретные действия.', ),
          Padding(
            padding: const  EdgeInsets.symmetric(vertical: 20.0),
            child: PlanPartWidget(actionOne: true, actionTwo: true, actionThree: false,),
          ),
          TaskCreetedWidget(title: 'Проверить проблему', discibe: '10 разговоров с клиентами', bonuses: 20, time: 'Недели 1–2',),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: SizedBox(
              height: 60,
              child: ElevatedButton(
                  style: WidgetsStyle.primaryButtonStyle,
                  onPressed: (){
                    context.go('planThree');
                  }, child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Составить мой план ' , style: AppTextStyles.ButtonTextStyle, ),
                  Icon(Icons.navigate_next),
                ],
              )),
            ),
          )
        ],
      ),
    );
  }
}




class PlanThirdPart extends StatelessWidget {
  const PlanThirdPart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(),
      endDrawer: const DrawerWidget(part: 2,),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Конструктор целей · 3/3', style: AppTextStyles.heading,),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text('Следуйте системе.', style: AppTextStyles.display,),
          ),
          const Text('Реалистичный план на 12 недель, разбитый на конкретные действия.', ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: PlanPartWidget(actionOne: true, actionTwo: true, actionThree: true,),
          ),
          FirstStep(),
          const SizedBox(height: 20,),
          SettingsWidget(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: SizedBox(
              height: 60,
              child: ElevatedButton(
                  style: WidgetsStyle.primaryButtonStyle,
                  onPressed: (){
                    context.go('home');
                  }, child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Составить мой план ' , style: AppTextStyles.ButtonTextStyle, ),
                  Icon(Icons.navigate_next),
                ],
              )),
            ),
          )
        ],
      ),
    );
  }
}
