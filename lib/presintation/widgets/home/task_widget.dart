import 'package:discipline/presintation/style/widgets_style.dart';
import 'package:flutter/material.dart';
import 'package:discipline/presintation/style/app_text_styles.dart';

import '../../style/containet_style.dart';
import '../../style/main_style.dart';

class TaskWidget extends StatefulWidget {
  final String title;
  final String discibe;
  final int bonuses;

  const TaskWidget({
    super.key,
    required this.title,
    required this.discibe,
    required this.bonuses,
  });

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  bool isCompleted = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: ContainerStyle.primaryContainerStyle,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                isCompleted = !isCompleted;
              });
            },
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white24,
                  width: 2,
                ),
              ),
              child: isCompleted
                  ? const Icon(
                Icons.check,
                size: 18,
                color: Color(0xFFC6F221),
              )
                  : null,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.title,
                      style: AppTextStyles.heading,
                    ),
                    Text(
                      '+${widget.bonuses}',
                      style: AppTextStyles.miniGreenText,
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Text(
                  widget.discibe,
                  style: AppTextStyles.label,
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: WidgetsStyle.primaryButtonStyle,
                        onPressed: () {},
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.navigate_next_outlined),
                            SizedBox(width: 4),
                            Text('Фокус'),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    Expanded(
                      child: ElevatedButton(
                        style: WidgetsStyle.primaryButtonStyle,
                        onPressed: () {},
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle_outline),
                            SizedBox(width: 4),
                            Text('Проверить'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



class TaskCreetedWidget extends StatefulWidget {
  final String title;
  final String discibe;
  final int bonuses;
  final String time;

  const TaskCreetedWidget({
    super.key,

    required this.title,
    required this.discibe,
    required this.bonuses,
    required this.time,
  });

  @override
  State<TaskCreetedWidget> createState() => _TaskCreetedWidgetState();
}

class _TaskCreetedWidgetState extends State<TaskCreetedWidget> {
  bool isCompleted = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: ContainerStyle.primaryContainerStyle,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                isCompleted = !isCompleted;
              });
            },
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white24,
                  width: 2,
                ),
              ),
              child: isCompleted
                  ? const Icon(
                Icons.check,
                size: 18,
                color: Color(0xFFC6F221),
              )
                  : null,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.time,
                  style: AppTextStyles.label,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.title,
                      style: AppTextStyles.heading,
                    ),
                    Text(
                      '+${widget.bonuses}',
                      style: AppTextStyles.miniGreenText,
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Text(
                  widget.discibe,
                  style: AppTextStyles.label,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}