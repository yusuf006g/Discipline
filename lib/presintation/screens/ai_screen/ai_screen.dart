import 'package:discipline/presintation/screens/ai_screen/ai_chat_screen.dart';
import 'package:discipline/presintation/style/main_style.dart';
import 'package:discipline/presintation/widgets/ai/question_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../style/app_text_styles.dart';
import '../../style/widgets_style.dart';
import '../../widgets/ai/award_widget.dart';
import '../../widgets/main/app_bar_widget.dart';
import '../../widgets/main/drawer_widget.dart';

class AiScreen extends StatelessWidget {
  const AiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(),
      endDrawer: const DrawerWidget(part: 3,),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Проверка качества с ИИ · 1 из 2', style: AppTextStyles.heading,),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: const Text('Покажите, что вы усвоили..', style: AppTextStyles.display,),
          ),
          const Text('Быстрая проверка не даст отметить поверхностный результат и сохранит ваш стандарт.', ),

          const SizedBox(height: 26),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: QuestionWidget(),
          ),
          Padding(
            padding: EdgeInsetsGeometry.symmetric(vertical: 20),
            child: SizedBox(
              height: 60,
              child: ElevatedButton(
                  style: WidgetsStyle.primaryButtonStyle,
                  onPressed: (){
                    context.go('aiTwo');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Отправить ответ ', style: AppTextStyles.ButtonTextStyle,),
                      Icon(Icons.navigate_next, size: 25,),
                    ],
                  )
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AiTwo extends StatelessWidget {
  const AiTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(),
      endDrawer: const DrawerWidget(part: 3,),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: MainStyle.successColor,
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Icon(
                Icons.check_circle_outline,
                size: 60,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Качество подтверждено',
              style: AppTextStyles.sccessHeading,
            ),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Результат принят.',
                style: AppTextStyles.display,
              ),
            ),

            const Text(
              'Вы не просто завершили задачу —\n'
                  'вы поняли материал и\n'
                  'достигли стандарта.',
              textAlign: TextAlign.center,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 70),
              child: AwardWidget(award: 120, progres: 1.2,),
            ),

            Padding(
              padding: EdgeInsetsGeometry.symmetric(vertical: 20, horizontal: 20),
              child: SizedBox(
                height: 60,
                child: ElevatedButton(
                    style: WidgetsStyle.primaryButtonStyle,
                    onPressed: (){
                      context.go('award');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Получить награду ', style: AppTextStyles.ButtonTextStyle,),
                        Icon(Icons.navigate_next, size: 25,),
                      ],
                    )
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}