import 'package:discipline/presintation/style/main_style.dart';
import 'package:flutter/material.dart';

class PlanPartWidget extends StatelessWidget {
  final bool actionOne;
  final bool actionTwo;
  final bool actionThree;
  const PlanPartWidget({super.key, required this.actionOne, required this.actionTwo, required this.actionThree});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 8,
            decoration: BoxDecoration(
              color: actionOne ? MainStyle.actionColor: MainStyle.offColor,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 8,
            decoration: BoxDecoration(
              color: actionTwo ? MainStyle.actionColor: MainStyle.offColor,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 8,
            decoration: BoxDecoration(
              color: actionThree ? MainStyle.actionColor: MainStyle.offColor,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}


