import 'package:flutter/material.dart';

import '../constants/colors.dart';

class DividerBase extends StatelessWidget {
  const DividerBase({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 358,
      height: 2,
      decoration: BoxDecoration(color: L_GREY),
    );
  }
}