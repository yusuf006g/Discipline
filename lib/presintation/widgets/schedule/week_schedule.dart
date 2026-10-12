import 'package:flutter/material.dart';
import 'package:discipline/presintation/style/app_text_styles.dart';
import 'package:discipline/presintation/style/containet_style.dart';
import 'package:discipline/presintation/style/main_style.dart';

class WeekScheduleWidget extends StatelessWidget {
  const WeekScheduleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final days = ['П', 'В', 'С', 'Ч', 'П', 'С', 'В'];

    final values = [
      0.55,
      0.72,
      0.65,
      0.86,
      0.78,
      0.86,
      0.82,
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: ContainerStyle.primaryContainerStyle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Индекс постоянства',
                    style: AppTextStyles.heading,
                  ),

                  const SizedBox(height: 6),

                  Text(
                    '↑ 8% к прошлой неделе',
                    style: TextStyle(
                      color: MainStyle.successColor,
                      fontSize: 21,
                    ),
                  ),
                ],
              ),

              const Icon(
                Icons.speed_outlined,
                color: MainStyle.actionColor,
                size: 42,
              ),
            ],
          ),

          const SizedBox(height: 40),

          // GRAPH
          SizedBox(
            height: 280,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(
                days.length,
                    (index) {
                  final isCurrentDay = index == 5;

                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 9),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // BAR
                          Expanded(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: FractionallySizedBox(
                                heightFactor: values[index],
                                widthFactor: 0.82,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isCurrentDay
                                        ? MainStyle.actionColor
                                        : const Color(0xFF495149),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // DAY
                          Text(
                            days[index],
                            style: AppTextStyles.label,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}