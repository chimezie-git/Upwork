import 'package:either_dart/either.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nitrobills/app/controllers/auth/auth_controller.dart';
import 'package:nitrobills/app/data/enums/button_enum.dart';
import 'package:nitrobills/app/data/provider/app_error.dart';
import 'package:nitrobills/app/data/repository/auth_repo.dart';
import 'package:nitrobills/app/data/services/validators.dart';
import 'package:nitrobills/app/ui/global_widgets/buttons.dart';
import 'package:nitrobills/app/ui/global_widgets/nb_buttons.dart';
import 'package:nitrobills/app/ui/global_widgets/nb_field.dart';
import 'package:nitrobills/app/ui/global_widgets/nb_headers.dart';
import 'package:nitrobills/app/ui/pages/auth/forget_password_page.dart';
import 'package:nitrobills/app/ui/pages/auth/signup_page.dart';
import 'package:nitrobills/app/ui/pages/auth/widgets/auth_modal.dart';
import 'package:nitrobills/app/ui/pages/auth/widgets/previous_signin_card.dart';
import 'package:nitrobills/app/ui/utils/nb_colors.dart';
import 'package:nitrobills/app/ui/utils/nb_image.dart';
import 'package:nitrobills/app/ui/utils/nb_text.dart';
import 'package:nitrobills/app/ui/utils/nb_utils.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  late bool hasUser;
  late AuthController userCntrl;
  ValueNotifier<ButtonEnum> buttonStatus =
      ValueNotifier<ButtonEnum>(ButtonEnum.disabled);
  late TextEditingController usernameEmailCntrl;
  late TextEditingController passwordCntrl;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool signinError = false;
  String? signinErrorTxt;

  @override
  void initState() {
    super.initState();
    userCntrl = Get.find<AuthController>();
    usernameEmailCntrl = TextEditingController();
    passwordCntrl = TextEditingController();
    hasUser = userCntrl.authDataAvailable.value;
  }

  @override
  void dispose() {
    passwordCntrl.dispose();
    buttonStatus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned(
            top: 1.h,
            left: 5.w,
            right: 5.w,
            height: 110.h,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                color: const Color(0xFF434242),
              ),
            ),
          ),
          Positioned(
            top: 10.h,
            height: 790.h,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: NbColors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(16.r),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      NbHeader.backAndTitle("Sign in", _back),
                      30.verticalSpace,
                      hasUser
                          ? PreviousSigninCard(
                              date: userCntrl.lastLogin.value,
                              name:
                                  "${userCntrl.firstName} ${userCntrl.lastName}",
                              onClose: () {
                                setState(() {
                                  hasUser = false;
                                });
                              },
                            )
                          : NbField.text(
                              keyboardType: TextInputType.emailAddress,
                              controller: usernameEmailCntrl,
                              hint: "Email or username",
                              forcedError: signinError,
                              onChanged: _onChanged,
                              validator: () {
                                if (usernameEmailCntrl.text.isEmpty) {
                                  return "Enter a valid username or email";
                                } else {
                                  return null;
                                }
                              }),
                      24.verticalSpace,
                      NbField.text(
                          obscureText: true,
                          controller: passwordCntrl,
                          hint: "Password",
                          forcedError: signinError,
                          onChanged: _onChanged,
                          validator: () {
                            if (!NbValidators.isPassword(
                                passwordCntrl.text.trim())) {
                              return "Password must be eight characters, with at least one letter and one number";
                            } else {
                              return null;
                            }
                          }),
                      if (signinErrorTxt != null)
                        Align(
                            alignment: Alignment.centerLeft,
                            child: NbText.sp12(signinErrorTxt!)
                                .setColor(NbColors.red)),
                      30.verticalSpace,
                      if (userCntrl.biometricAvailable.value && hasUser)
                        Padding(
                          padding: EdgeInsets.only(bottom: 26.h),
                          child: GreyTextSvgButton(
                            onTap: biometricLogin,
                            text: "Use Fingerprint",
                            svg: NbSvg.username,
                          ),
                        ),
                      ValueListenableBuilder(
                        valueListenable: buttonStatus,
                        builder: (context, value, child) {
                          return NbButton.primary(
                            text: "Login",
                            onTap: _login,
                            status: value,
                          );
                        },
                      ),
                      26.verticalSpace,
                      if (userCntrl.biometricAvailable.value && hasUser)
                        Padding(
                          padding: EdgeInsets.only(top: 11.h),
                          child: RichText(
                            text: TextSpan(
                              text: "Dont have an account? ",
                              style: TextStyle(
                                  color: const Color(0xFF282828),
                                  fontFamily: 'Satoshi',
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500),
                              children: [
                                TextSpan(
                                  text: "Sign up",
                                  style: const TextStyle(
                                    color: Color(0xFF1E92E9),
                                    fontFamily: 'Satoshi',
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = _signup,
                                )
                              ],
                            ),
                          ),
                        )
                      else
                        GreyDoubleTextButton(
                          onTap: _signup,
                          text1: "Dont have an account?",
                          text2: "Signup",
                        ),
                      TextButton(
                        onPressed: _forgetPassword,
                        child: NbText.sp14("Forget Password?").w500.darkGrey,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _back() {
    Get.back();
  }

  void _signup() {
    AuthModal.show(const SignupPage());
  }

  void biometricLogin() async {
    buttonStatus.value = ButtonEnum.loading;
    final data = await AuthRepo().biometricLogin();
    if (data.isLeft) {
      showFieldErrors(data.left);
    }
    buttonStatus.value = ButtonEnum.active;
  }

  void _login() async {
    NbUtils.removeKeyboard();
    Either<SingleFieldError, Null> data = Right(null);
    buttonStatus.value = ButtonEnum.loading;
    if (hasUser) {
      usernameEmailCntrl.text = userCntrl.email.value;
      if (formKey.currentState?.validate() ?? false) {
        data = await AuthRepo().onlyPasswordLogin(passwordCntrl.text);
      }
    } else {
      if (formKey.currentState?.validate() ?? false) {
        data =
            await AuthRepo().login(usernameEmailCntrl.text, passwordCntrl.text);
      }
    }
    if (data.isLeft) {
      showFieldErrors(data.left);
    }
    buttonStatus.value = ButtonEnum.active;
  }

  void _forgetPassword() {
    AuthModal.show(const ForgetPasswordPage());
  }

  bool _validate() {
    if (!hasUser) {
      if (usernameEmailCntrl.text.isEmpty) {
        return false;
      }
    }
    if (NbValidators.isPassword(passwordCntrl.text.trim())) {
      return false;
    } else {
      return true;
    }
  }

  void _onChanged(String? val) {
    if (_validate()) {
      buttonStatus.value = ButtonEnum.disabled;
    } else {
      buttonStatus.value = ButtonEnum.active;
    }
    formKey.currentState?.reset();
    clearForcedErrors();
  }

  void clearForcedErrors() {
    signinError = false;
    signinErrorTxt = null;
    setState(() {});
  }

  void showFieldErrors(SingleFieldError error) {
    signinError = true;
    signinErrorTxt = "login and password incorrect";
    setState(() {});
  }
}
