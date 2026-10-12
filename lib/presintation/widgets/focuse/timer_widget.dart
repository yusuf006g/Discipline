import 'package:circular_countdown/circular_countdown.dart';
import 'package:discipline/presintation/style/main_style.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:timer_controller/timer_controller.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget({super.key});

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  late final TimerController controller;

  static const int totalSeconds = 50 * 60;

  @override
  void initState() {
    super.initState();

    controller = TimerController.seconds(totalSeconds);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 300,
          height: 300,
          child: TimerControllerBuilder(
            controller: controller,
            builder: (context, value, child) {
              final minutes = value.remaining ~/ 60;
              final seconds = value.remaining % 60;

              final isRunning = value.status == TimerStatus.running;

              return Stack(
                alignment: Alignment.center,
                children: [
                  CircularCountdown(
                    countdownTotal: totalSeconds,
                    countdownRemaining: value.remaining,
                    countdownCurrentColor: MainStyle.actionColor,
                    countdownRemainingColor: MainStyle.actionColor,
                    strokeWidth: 32,
                    isClockwise: true,
                  ),

                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$minutes:${seconds.toString().padLeft(2, '0')}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'ИЗ 50:00',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          letterSpacing: 4,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),

        const SizedBox(height: 30),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // RESET
            IconButton(
              onPressed: () {
                controller.reset();
              },
              icon: const Icon(
                Icons.refresh,
                color: Colors.white,
                size: 32,
              ),
            ),

            const SizedBox(width: 30),

            // PLAY / PAUSE
            TimerControllerBuilder(
              controller: controller,
              builder: (context, value, child) {
                final isRunning =
                    value.status == TimerStatus.running;

                return GestureDetector(
                  onTap: () {
                    if (isRunning) {
                      controller.pause();
                    } else {
                      controller.start();
                    }
                  },
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: MainStyle.actionColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isRunning
                          ? Icons.pause
                          : Icons.play_arrow,
                      color: Colors.black,
                      size: 50,
                    ),
                  ),
                );
              },
            ),

            const SizedBox(width: 30),

            // DONE
            IconButton(
              onPressed: () {
                context.go('ai');
              },
              icon: const Icon(
                Icons.check,
                color: Colors.white,
                size: 32,
              ),
            ),
          ],
        ),
      ],
    );
  }
}