import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';

class IntroDot extends StatelessWidget {
  /// Used For The Dots on the screen
  const IntroDot({
    Key? key,
    required this.active,
  }) : super(key: key);

  final bool active;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppDefaults.duration,
      width: 15,
      height: 15,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: active
            ? AppColors.primaryColor
            : AppColors.primaryColor.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
    );
  }
}
