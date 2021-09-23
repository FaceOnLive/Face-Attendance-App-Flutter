import 'package:firebase_core/firebase_core.dart';
import '../../../controllers/auth/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_sizes.dart';
import '../../../services/form_verify.dart';
import '../../../utils/ui_helper.dart';
import '../../themes/text.dart';
import '../../widgets/app_button.dart';
import 'signup_screen.dart';

class LoginScreenAlt extends StatefulWidget {
  const LoginScreenAlt({Key? key}) : super(key: key);

  @override
  _LoginScreenAltState createState() => _LoginScreenAltState();
}

class _LoginScreenAltState extends State<LoginScreenAlt> {
  /* <---- Login Dependecny ----> */
  LoginController _controller = Get.find();

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

  // Form Key
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /* <---- Login Click Button ----> */
  RxBool _loginProgress = false.obs;

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
                      width: Get.width * 0.75,
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
                            textInputAction: TextInputAction.next,
                          ),
                          AppSizes.hGap20,
                          // Password Field
                          Obx(
                            () => TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: Icon(Icons.vpn_key_rounded),
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
                              margin: EdgeInsets.symmetric(vertical: 30),
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
