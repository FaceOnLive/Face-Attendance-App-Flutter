import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/app/controllers/settings_controller.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/themes/text.dart';
import '../../../core/auth/views/login_screen.dart';
import '../data/onboarding_repository.dart';
import 'models/intro_model.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  List<OnboardingModel> _allIntros = [];

  // Tracks currently active page
  final RxInt _currentPage = 0.obs;
  late PageController _pageController;

  // Navigation
  final SettingsController _controller = Get.find();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _allIntros = OnboardingRepository.all;
  }

  @override
  void dispose() {
    _pageController.dispose();
    _currentPage.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /* <---- Images And Title ----> */
            Expanded(
              child: PageView.builder(
                  controller: _pageController,
                  itemCount: _allIntros.length,
                  onPageChanged: (value) {
                    _currentPage.value = value;
                  },
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            _allIntros[index].imageLocation,
                          ),
                          Text(
                            _allIntros[index].title,
                            style: AppText.h6.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          AppSizes.hGap10,
                          Text(
                            _allIntros[index].subtitle,
                            style: AppText.caption,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }),
            ),

            /* <---- Intro Dots ----> */
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _allIntros.length,
                  (index) => _IntroDots(
                    active: _currentPage.value == index,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      _controller.onboardingDone();
                      Get.to(() => const LoginPage());
                    },
                    child: Text(
                      'SKIP',
                      style: AppText.b1.copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                  InkWell(
                    borderRadius: AppDefaults.defaulBorderRadius,
                    onTap: () {
                      if (_currentPage.value == _allIntros.length - 1) {
                        _controller.onboardingDone();
                        Get.to(() => const LoginPage());
                      } else {
                        _pageController.animateToPage(
                          _currentPage.value + 1,
                          duration: AppDefaults.defaultDuration,
                          curve: Curves.bounceInOut,
                        );
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: AppColors.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IntroDots extends StatelessWidget {
  /// Used For The Dots on the screen
  const _IntroDots({
    Key? key,
    required this.active,
  }) : super(key: key);

  final bool active;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppDefaults.defaultDuration,
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
