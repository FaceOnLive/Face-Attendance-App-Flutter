import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/themes/text.dart';
import '../../models/intro_model.dart';

class OnboardingHeroSection extends StatelessWidget {
  const OnboardingHeroSection({
    Key? key,
    required this.onboardingModel,
  }) : super(key: key);

  final OnboardingModel onboardingModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            onboardingModel.imageLocation,
          ),
          Text(
            onboardingModel.title,
            style: AppText.h6.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          AppSizes.hGap10,
          Text(
            onboardingModel.subtitle,
            style: AppText.caption,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
