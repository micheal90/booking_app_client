import 'package:booking_app_client/providers/auth_provider.dart';
import 'package:booking_app_client/screens/forgot_password_screen.dart';
import 'package:booking_app_client/screens/veiw_screens/home_screen.dart';
import 'package:booking_app_client/util/langs/translate_controller.dart';
import 'package:booking_app_client/widgets_model/custom_elevated_button.dart';
import 'package:booking_app_client/widgets_model/custom_text.dart';
import 'package:booking_app_client/widgets_model/custom_text_form_field.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();
  bool _isShowPassword = true;
  bool _isLoading = false;
  void changeShowPassword() {
    setState(() {
      _isShowPassword = !_isShowPassword;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void submit(BuildContext context) async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<AuthProvider>(context, listen: false).logInWithEmail();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()));
    } on FirebaseException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.toString()),
        duration: Duration(seconds: 5),
      ));
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return DoubleBack(
      child: Scaffold(
          body: SafeArea(
        child: GetBuilder<TranslateController>(
          init: Get.find<TranslateController>(),
          builder: (controller) => SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  Container(
                    color: KPrimaryColor,
                    child: Column(
                      children: [
                        SizedBox(height: 60),
                        CustomText(
                          text: 'Login Employee'.tr,
                          color: Colors.white,
                          fontSize: 33,
                          alignment: Alignment.center,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      height: size.height * 0.7,
                      width: size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40))),
                      child: Padding(
                        padding: const EdgeInsets.all(22),
                        child: Form(
                          key: _formKey,
                          child: SingleChildScrollView(
                            child: Consumer<AuthProvider>(
                              builder: (BuildContext context, authValue,
                                      Widget? child) =>
                                  Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextFormField(
                                      controller: _emailController,
                                      label: 'Email'.tr,
                                      hint: 'example@gmail.com',
                                      isPassword: false,
                                      prefixIcon: Icons.email,
                                      suffixIcon: null,
                                      type: TextInputType.emailAddress,
                                      validate: (String? val) {
                                        if (val!.isEmpty ||
                                            !val.contains('@')) {
                                          return "Enter a valid email".tr;
                                        }
                                        return null;
                                      },
                                      onSave: (value) {
                                        //print('Email: $value');
                                        authValue.email = value!.trim();
                                      }),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  CustomTextFormField(
                                    controller: _passwordController,
                                    label: 'Password'.tr,
                                    hint: "Minimum 6 characters".tr,
                                    onFieldSubmitted: (_) => submit(context),
                                    isPassword: _isShowPassword ? true : false,
                                    prefixIcon: Icons.lock,
                                    suffixIcon: IconButton(
                                      icon: _isShowPassword
                                          ? Icon(Icons.visibility_off_rounded)
                                          : Icon(Icons.visibility),
                                      onPressed: changeShowPassword,
                                    ),
                                    type: TextInputType.text,
                                    validate: (String? val) {
                                      if (val!.isEmpty || val.length < 6) {
                                        return "Password is too short".tr;
                                      }
                                      return null;
                                    },
                                    onSave: (String? value) {
                                      //print('password: $value');
                                      authValue.password = value!.trim();
                                    },
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ForgotPasswordScreen()));
                                      },
                                      child: CustomText(
                                        text: 'Forgot Password?'.tr,
                                        alignment: Alignment.centerRight,
                                      )),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  _isLoading
                                      ? CircularProgressIndicator()
                                      : CustomElevatedButton(
                                          text: 'LOGIN'.tr,
                                          onPressed: () {
                                            submit(context);
                                          },
                                        ),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  Row(
                                    children: [
                                      CustomText(
                                        text: 'Language:'.tr,
                                      ),
                                      const SizedBox(
                                        width: 20.0,
                                      ),
                                      CustomText(
                                        text: 'English'.tr,
                                      ),
                                      Radio(
                                          value: 'en',
                                          groupValue: controller.selectedLang,
                                          onChanged: (String? lang) =>
                                              controller.changeLanguage(lang!)),
                                      const SizedBox(
                                        width: 10.0,
                                      ),
                                      CustomText(
                                        text: 'Arabic'.tr,
                                      ),
                                      Radio(
                                        value: 'ar',
                                        groupValue: controller.selectedLang,
                                        onChanged: (String? lang) =>
                                            controller.changeLanguage(lang!),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }
}
