import 'package:face_attendance/services/form_verify.dart';

import '../../../constants/app_images.dart';
import '../../../constants/app_sizes.dart';
import '../../dialogs/email_sent.dart';
import '../../widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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
  RxBool _showPass = false.obs;
  _onEyeClick() {
    _showPass.value = !_showPass.value;
  }

  bool _isPasswordMatching() {
    return passController.text == confirmPassController.text;
  }

  // Key
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
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Container(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /* <---- Header ----> */
                Image.asset(AppImages.ILLUSTRATION_WELCOME),
                /* <---- Form ----> */
                Form(
                  key: _formKey,
                  child: Container(
                    margin: EdgeInsets.all(AppSizes.DEFAULT_MARGIN),
                    padding: EdgeInsets.all(AppSizes.DEFAULT_MARGIN),
                    child: Column(
                      children: [
                        // Full Name
                        TextFormField(
                          decoration: InputDecoration(
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
                        // Password Fields
                        Obx(
                          () => Column(
                            children: [
                              TextFormField(
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
                                  return AppFormVerify.password(
                                      password: value);
                                },
                              ),
                              AppSizes.hGap20,
                              // Confirm Password
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Confirm Password',
                                  prefixIcon: Icon(Icons.vpn_key_rounded),
                                  hintText: '***********',
                                ),
                                controller: confirmPassController,
                                obscureText: !_showPass.value,
                                validator: (value) {
                                  return AppFormVerify.password(
                                      password: value);
                                },
                              ),
                            ],
                          ),
                        ),
                        /* <---- Submit Button ----> */
                        AppSizes.hGap30,
                        AppButton(
                          label: 'Submit',
                          onTap: () async {
                            bool _isFormOkay =
                                _formKey.currentState!.validate() &&
                                    _isPasswordMatching();
                            if (_isFormOkay) {
                              await Get.dialog(EmailSentSuccessfullDialog());
                              Get.back();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
