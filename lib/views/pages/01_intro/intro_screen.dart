import '../../../constants/app_colors.dart';
import '../../../constants/app_defaults.dart';
import '../../../constants/app_sizes.dart';
import '../../../controllers/navigation/nav_controller.dart';
import '../../../models/intro.dart';
import '../02_auth/login_screen.dart';
import '../../themes/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/route_manager.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  // Add or remove intro from here
  List<Intro> _allIntros = [
    Intro(
      title: 'Fast, Accurate Face Detection',
      imageLocation: 'assets/images/intro/intro_0.png',
      subtitle:
          'Our main goal is to reduce the hassle of keeping attendance of your employees. With our fast, accurate face detection technology you can do this with ease. Our SDK can verify person even with mask on.',
    ),
    Intro(
      title: 'Works in Wide Variety of Devices',
      imageLocation: 'assets/images/intro/intro_1.png',
      subtitle:
          'The cost is low, you don\'t have to buy expensive biometric device. Just a device will do the job with the static verifier on',
    ),
    Intro(
      title: 'Easy Way To Verify',
      imageLocation: 'assets/images/intro/intro_2.png',
      subtitle:
          'The best biometric verification is the face verification, because it is the most easy and less time consuming. You just have to look',
    ),
    Intro(
      title: 'Security is built in',
      imageLocation: 'assets/images/intro/intro_3.png',
      subtitle:
          'We focus on security. Security and Fast, Accurate Verification are our main goal. Our SDK can detect photo, printed photo, mask, liveness etc. while being fast and accurate.',
    ),
  ];

  // Tracks currently active page
  RxInt _currentPage = 0.obs;
  late PageController _pageController;

  // Navigation
  NavigationController _controller = Get.find();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
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
                      padding: EdgeInsets.all(10),
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
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      _controller.introScreenDone();
                      Get.to(() => LoginScreenAlt());
                    },
                    child: Text('SKIP'),
                  ),
                  InkWell(
                    borderRadius: AppDefaults.defaulBorderRadius,
                    onTap: () {
                      if (_currentPage.value == _allIntros.length - 1) {
                        _controller.introScreenDone();
                        Get.to(() => LoginScreenAlt());
                      } else {
                        _pageController.animateToPage(
                          _currentPage.value + 1,
                          duration: AppDefaults.defaultDuration,
                          curve: Curves.bounceInOut,
                        );
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.all(20),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.PRIMARY_COLOR,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
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
      margin: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: active
            ? AppColors.PRIMARY_COLOR
            : AppColors.PRIMARY_COLOR.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
    );
  }
}
