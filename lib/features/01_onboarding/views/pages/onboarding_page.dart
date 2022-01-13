import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/constants.dart';
import '../../../../../core/themes/text.dart';
import '../../../../core/app/controllers/core_controller.dart';
import '../../../../core/auth/views/pages/login_page.dart';
import '../../data/onboarding_repository.dart';
import '../../models/intro_model.dart';
import '../components/intro_dot.dart';
import '../components/onboarding_hero_section.dart';

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
  final CoreController _controller = Get.find();

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
                    return OnboardingHeroSection(
                      onboardingModel: _allIntros[index],
                    );
                  }),
            ),

            /* <---- Intro Dots ----> */
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _allIntros.length,
                  (index) => IntroDot(
                    active: _currentPage.value == index,
                  ),
                ),
              ),
            ),

            /// Bottom Section
            OnboardingBottomSection(
              controller: _controller,
              currentPage: _currentPage,
              allIntros: _allIntros,
              pageController: _pageController,
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingBottomSection extends StatelessWidget {
  const OnboardingBottomSection({
    Key? key,
    required CoreController controller,
    required RxInt currentPage,
    required List<OnboardingModel> allIntros,
    required PageController pageController,
  })  : _controller = controller,
        _currentPage = currentPage,
        _allIntros = allIntros,
        _pageController = pageController,
        super(key: key);

  final CoreController _controller;
  final RxInt _currentPage;
  final List<OnboardingModel> _allIntros;
  final PageController _pageController;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            borderRadius: AppDefaults.borderRadius,
            onTap: () {
              if (_currentPage.value == _allIntros.length - 1) {
                _controller.onboardingDone();
                Get.to(() => const LoginPage());
              } else {
                _pageController.animateToPage(
                  _currentPage.value + 1,
                  duration: AppDefaults.duration,
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
    );
  }
}
