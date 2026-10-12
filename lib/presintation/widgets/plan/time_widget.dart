import 'package:discipline/presintation/style/containet_style.dart';
import 'package:discipline/presintation/style/widgets_style.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../servises/go_route/go_route.dart';

import '../../style/app_text_styles.dart';
class TimeWidget extends StatelessWidget {
  const TimeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Срок достижения',
                style: AppTextStyles.WhiteHeading,
              ),
              TextButton(
                onPressed: () {
                  context.go('plan');
                },
                child: const Text(
                  'еще',
                  style: AppTextStyles.miniGreenText,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: DurationWidget(time: '6 недель'),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: DurationWidget(time: '12 недель'),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: DurationWidget(time: '6 месяцев'),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: SizedBox(
              height: 60,
              child: ElevatedButton(
                  style: WidgetsStyle.primaryButtonStyle,
                  onPressed: (){
                context.go('planTwo');
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
    );
  }
}

class DurationWidget extends StatelessWidget {
  final String time;

  const DurationWidget({
    super.key,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 84,
      decoration: ContainerStyle.primaryContainerStyle,
      child: Center(
        child: Text(
          time,
          style: AppTextStyles.WhiteHeading,
        ),
      ),
    );
  }
}