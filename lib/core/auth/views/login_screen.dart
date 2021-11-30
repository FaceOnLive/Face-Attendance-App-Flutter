import 'package:face_attendance/core/auth/controllers/login_controller.dart';
import 'package:face_attendance/core/themes/text.dart';
import 'package:face_attendance/core/widgets/app_button.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/constants.dart';
import '../../../core/utils/ui_helper.dart';
import '../../../data/providers/form_verify.dart';

import 'login_screen_face.dart';
import 'signup_screen.dart';

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
  final RxBool _loginProgress = false.obs;

  Rxn<String> errorMessage = Rxn<String>();

  _onLoginButtonPressed() async {
    bool _isFormOkay = _formKey.currentState!.validate();
    if (_isFormOkay) {
      // Dismiss Keyboard
      AppUiHelper.dismissKeyboard(context: context);
      // Start Progress Loading
      _loginProgress.trigger(true);
      try {
        await _controller.loginWithEmail(
          email: emailController.text,
          password: passController.text,
        );
        _loginProgress.trigger(false);
      } on FirebaseException catch (e) {
        errorMessage.value = e.message;
        _loginProgress.trigger(false);
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
    _loginProgress.close();
    errorMessage.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        actions: [
          InkWell(
            onTap: () {
              Get.to(() => const LoginScreenAlt());
            },
            borderRadius: AppDefaults.defaulBorderRadius,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(
                AppImages.illustrationFaceID,
                height: 24,
                width: 24,
              ),
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(AppSizes.defaultPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /* <---- Header Logo ----> */
                Container(
                  width: Get.width * 0.5,
                  margin: const EdgeInsets.symmetric(vertical: 30),
                  child: Hero(
                    tag: AppImages.mainLogo,
                    child: Image.asset(
                      AppImages.mainLogo,
                    ),
                  ),
                ),
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
                        /* <---- Login Button ----> */
                        Obx(
                          () => AppButton(
                            margin: const EdgeInsets.symmetric(vertical: 30),
                            label: 'Login',
                            isLoading: _loginProgress.value,
                            onTap: _onLoginButtonPressed,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                /* <---- Sign UP BUTTON ----> */
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Don\'t have an account?'),
                      TextButton(
                        onPressed: () {
                          Get.to(() => const SignUpScreen());
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
