import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/utils/ui_helper.dart';
import '../../../utils/form_verify.dart';
import '../../../widgets/app_button.dart';
import '../../controllers/signup_controller.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  /* <---- Dependency -----> */
  final SignUpController _controller = Get.put(SignUpController());

  /* <---- Text Editing Controllers ----> */
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passController;
  late TextEditingController confirmPassController;
  _initializeControllers() {
    nameController = TextEditingController();
    emailController = TextEditingController();
    passController = TextEditingController();
    confirmPassController = TextEditingController();
  }

  _disposeControllers() {
    nameController.dispose();
    emailController.dispose();
    passController.dispose();
    confirmPassController.dispose();
  }

  /* <---- Show Password ----> */
  final RxBool _showPass = false.obs;
  _onEyeClick() {
    _showPass.value = !_showPass.value;
  }

  bool _isPasswordMatching() {
    return passController.text == confirmPassController.text;
  }

  // Key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final RxBool _isAddingUser = false.obs;

  Future<void> _onCreateUser() async {
    bool _isFormOkay =
        _formKey.currentState!.validate() && _isPasswordMatching();
    if (_isFormOkay) {
      AppUiUtil.dismissKeyboard(context: context);
      _isAddingUser.trigger(true);
      try {
        await _controller.registerUsers(
          userName: nameController.text,
          email: emailController.text,
          password: passController.text,
        );
        _isAddingUser.trigger(false);
      } on Exception catch (e) {
        print(e);
        _isAddingUser.trigger(false);
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
    _isAddingUser.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /* <---- Header ----> */
              Image.asset(AppImages.illustrationWelcome),
              /* <---- Form ----> */
              Form(
                key: _formKey,
                child: Container(
                  margin: const EdgeInsets.all(AppDefaults.margin),
                  padding: const EdgeInsets.all(AppDefaults.margin),
                  child: Column(
                    children: [
                      // Full Name
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Full Name',
                          prefixIcon: Icon(Icons.person_rounded),
                          hintText: 'John Doe',
                        ),
                        controller: nameController,
                        validator: (value) {
                          return AppFormVerify.name(fullName: value);
                        },
                      ),
                      AppSizes.hGap20,
                      // Email
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
                      ),
                      AppSizes.hGap20,
                      // Password Fields
                      Obx(
                        () => Column(
                          children: [
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: const Icon(Icons.vpn_key_rounded),
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
                                return AppFormVerify.password(
                                    password: value,
                                    confirmPassword:
                                        confirmPassController.text);
                              },
                            ),
                            AppSizes.hGap20,
                            // Confirm Password
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Confirm Password',
                                prefixIcon: Icon(Icons.vpn_key_rounded),
                                hintText: '***********',
                              ),
                              controller: confirmPassController,
                              obscureText: !_showPass.value,
                              validator: (value) {
                                return AppFormVerify.password(
                                  password: value,
                                  confirmPassword: passController.text,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      /* <---- Submit Button ----> */
                      AppSizes.hGap30,
                      Obx(
                        () => AppButton(
                          label: 'Submit',
                          isLoading: _isAddingUser.value,
                          onTap: _onCreateUser,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
