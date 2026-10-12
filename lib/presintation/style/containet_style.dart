import 'package:flutter/material.dart';

import 'main_style.dart';

class ContainerStyle {
  ContainerStyle._();

  static final BoxDecoration primaryContainerStyle = BoxDecoration(
    color: MainStyle.backgrountColor.withGreen(20),
    borderRadius: BorderRadius.circular(10),
    border: Border.all(
      color: Colors.white12,
      width: 1,
    ),
  );

  static final BoxDecoration actionContainerStyle = BoxDecoration(
    color: MainStyle.backgrountColor.withGreen(20),
    borderRadius: BorderRadius.circular(10),
    border: Border.all(
      color: MainStyle.actionColor,
      width: 3,
    ),
  );


  static final BoxDecoration redContainerStyle = BoxDecoration(
    color: MainStyle.backgrountColor.withRed(30),
    borderRadius: BorderRadius.circular(10),
    border: Border.all(
      color: MainStyle.dangerColor,
      width: 1,
    ),
  );
}