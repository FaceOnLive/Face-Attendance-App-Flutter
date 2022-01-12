import '../models/intro_model.dart';

class OnboardingRepository {
  // Add or remove intro from here
  static List<OnboardingModel> all = [
    OnboardingModel(
      title: 'Fast, Accurate Face Detection',
      imageLocation: 'assets/images/intro/intro_0.png',
      subtitle:
          'Our main goal is to reduce the hassle of keeping attendance of your employees. With our fast, accurate face detection technology you can do this with ease. Our SDK can verify person even with mask on.',
    ),
    OnboardingModel(
      title: 'Works in Wide Variety of Devices',
      imageLocation: 'assets/images/intro/intro_1.png',
      subtitle:
          'The cost is low, you don\'t have to buy expensive biometric device. Just a device will do the job with the static verifier on',
    ),
    OnboardingModel(
      title: 'Easy Way To Verify',
      imageLocation: 'assets/images/intro/intro_2.png',
      subtitle:
          'The best biometric verification is the face verification, because it is the most easy and less time consuming. You just have to look',
    ),
    OnboardingModel(
      title: 'Security is built in',
      imageLocation: 'assets/images/intro/intro_3.png',
      subtitle:
          'We focus on security. Security and Fast, Accurate Verification are our main goal. Our SDK can detect photo, printed photo, mask, liveness etc. while being fast and accurate.',
    ),
  ];
}
