import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_sizes.dart';
import '../../../services/form_verify.dart';
import '../../../utils/ui_helper.dart';
import '../../themes/text.dart';
import '../../widgets/app_button.dart';
import '../03_main/main_screen.dart';
import 'signup_screen.dart';

class LoginScreenAlt extends StatefulWidget {
  const LoginScreenAlt({Key? key}) : super(key: key);

  @override
  _LoginScreenAltState createState() => _LoginScreenAltState();
}

class _LoginScreenAltState extends State<LoginScreenAlt> {
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
  RxBool _showPass = false.obs;
  _onEyeClick() {
    _showPass.value = !_showPass.value;
  }

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(AppSizes.DEFAULT_PADDING),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /* <---- Header Logo ----> */
                  Container(
                    width: Get.width * 0.5,
                    margin: EdgeInsets.symmetric(vertical: 30),
                    child: Hero(
                      tag: AppImages.MAIN_LOGO,
                      child: Image.asset(
                        AppImages.MAIN_LOGO,
                      ),
                    ),
                  ),
                  /* <---- Input ----> */
                  Form(
                    key: _formKey,
                    child: Container(
                      margin: EdgeInsets.all(AppSizes.DEFAULT_MARGIN),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email_rounded),
                              hintText: 'you@email.com',
                            ),
                            controller: emailController,
                            validator: (value) {
                              return AppFormVerify.email(email: value);
                            },
                          ),
                          AppSizes.hGap20,
                          // Password Field
                          Obx(
                            () => TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: Icon(Icons.vpn_key_rounded),
                                hintText: '***********',
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
                                return AppFormVerify.password(password: value);
                              },
                            ),
                          ),
                          /* <---- Login Button ----> */
                          AppButton(
                            margin: EdgeInsets.symmetric(vertical: 30),
                            label: 'Login',
                            onTap: () {
                              bool _isFormOkay =
                                  _formKey.currentState!.validate();
                              if (_isFormOkay) {
                                AppUiHelper.dismissKeyboard(context: context);
                                Get.to(() => MainScreenUI());
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  /* <---- Sign UP BUTTON ----> */
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Don\'t have an account?'),
                        TextButton(
                          onPressed: () {
                            Get.to(() => SignUpScreen());
                          },
                          child: Text(
                            'Sign up',
                            style: AppText.b1.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.PRIMARY_COLOR,
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
      ),
    );
  }
}
