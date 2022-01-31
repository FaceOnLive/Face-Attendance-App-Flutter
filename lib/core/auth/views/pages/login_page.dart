import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/utils/ui_helper.dart';
import '../../../utils/form_verify.dart';
import '../../../themes/text.dart';
import '../../../widgets/app_button.dart';
import '../../controllers/login_controller.dart';

import 'login_page_face.dart';

// import 'login_page_face.dart';
import 'register_as_admin_page.dart';
import 'sign_up_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  /* <---- Login Dependecny ----> */
  final LoginController _controller = Get.find();

  /* <---- Text Editing Controllers ----> */
  late TextEditingController emailController;
  late TextEditingController passController;
  _initializeControllers() {
    emailController = TextEditingController();
    passController = TextEditingController();
  }

  _disposeControllers() {
    emailController.dispose();
    passController.dispose();
  }

  /* <---- Show Password ----> */
  final RxBool _showPass = false.obs;
  _onEyeClick() {
    _showPass.value = !_showPass.value;
  }

  // Form Key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /* <---- Login Click Button ----> */

  Rxn<String> errorMessage = Rxn<String>();

  Future<void> _onLoginButtonPressed() async {
    bool _isFormOkay = _formKey.currentState!.validate();
    if (_isFormOkay) {
      // Dismiss Keyboard
      AppUiUtil.dismissKeyboard(context: context);
      try {
        _controller.isLoggingIn = true;
        _controller.update();
        await _controller.loginWithEmail(
          email: emailController.text,
          password: passController.text,
        );
        _controller.isLoggingIn = false;
        _controller.update();
      } on FirebaseException catch (e) {
        errorMessage.value = e.message;
        _controller.isLoggingIn = false;
        _controller.update();
      }
    }
  }

  /* <---- State ----> */
  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  @override
  void dispose() {
    _disposeControllers();
    _showPass.close();
    errorMessage.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        actions: [
          // Face Login Button
          GetBuilder<LoginController>(builder: (controller) {
            if (controller.isFaceLoginAvailable) {
              return InkWell(
                onTap: () {
                  Get.to(() => const LoginPageFace());
                },
                borderRadius: AppDefaults.borderRadius,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.asset(
                    AppImages.illustrationFaceID,
                    height: 24,
                    width: 24,
                  ),
                ),
              );
            } else {
              return const SizedBox();
            }
          }),
        ],
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(AppDefaults.padding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /* <---- Header Logo ----> */
                SizedBox(
                  width: Get.width * 0.5,
                  child: Hero(
                    tag: AppImages.logo,
                    child: Image.asset(
                      AppImages.logo2,
                    ),
                  ),
                ),
                AppSizes.hGap15,
                Text(
                  'Face Attendance',
                  style: AppText.h6.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
                AppSizes.hGap15,
                AppSizes.hGap15,
                /* <---- Input ----> */
                Form(
                  key: _formKey,
                  child: SizedBox(
                    width: Get.width * 0.75,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email_rounded),
                            hintText: 'you@email.com',
                          ),
                          controller: emailController,
                          validator: (value) {
                            return AppFormVerify.email(email: value);
                          },
                          textInputAction: TextInputAction.next,
                        ),
                        AppSizes.hGap20,
                        // Password Field
                        Obx(
                          () => TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: const Icon(Icons.vpn_key_rounded),
                              hintText: '***********',
                              errorText: errorMessage.value,
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  _onEyeClick();
                                },
                                child: Icon(
                                  _showPass.isFalse
                                      ? Icons.visibility_off_rounded
                                      : Icons.visibility_rounded,
                                ),
                              ),
                            ),
                            controller: passController,
                            obscureText: !_showPass.value,
                            validator: (value) {
                              errorMessage.value =
                                  AppFormVerify.password(password: value);
                              return errorMessage.value;
                            },
                            onFieldSubmitted: (v) {
                              _onLoginButtonPressed();
                            },
                            textInputAction: TextInputAction.done,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                /* <---- Login Button ----> */
                GetBuilder<LoginController>(builder: (loginController) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppDefaults.padding),
                    child: AppButton(
                      margin: const EdgeInsets.symmetric(vertical: 30),
                      label: 'Login',
                      isLoading: loginController.isLoggingIn,
                      onTap: _onLoginButtonPressed,
                    ),
                  );
                }),
                AppSizes.hGap15,
                /* <---- Sign UP BUTTON ----> */
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Don\'t have an account?'),
                        TextButton(
                          onPressed: () {
                            Get.to(() => const SignUpPage());
                          },
                          child: Text(
                            'Sign up',
                            style: AppText.b1.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () =>
                          Get.to(() => const RegisterAsAdminPage()),
                      child: const Text('Register as Admin'),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
