import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';
import 'package:zc_desktop_flutter/core/constants/images.dart';
import 'package:zc_desktop_flutter/core/constants/strings.dart';
import 'package:zc_desktop_flutter/core/network/failure.dart';
import 'package:zc_desktop_flutter/core/validator/validation_extension.dart';
import 'package:zc_desktop_flutter/ui/shared/const_app_colors.dart';
import 'package:zc_desktop_flutter/ui/shared/const_text_styles.dart';
import 'package:zc_desktop_flutter/ui/shared/const_ui_helpers.dart';
import 'package:zc_desktop_flutter/ui/shared/dumb_widgets/build_left_startup_image.dart';
import 'package:zc_desktop_flutter/ui/shared/dumb_widgets/zcdesk_auth_btn.dart';
import 'package:zc_desktop_flutter/ui/shared/dumb_widgets/zcdesk_input_field.dart';
import 'package:zc_desktop_flutter/ui/views/auth/login_page/login_viewmodel.dart';

class LoginView extends HookWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    return ViewModelBuilder<LoginViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    BuildStartUpImage(),
                    Expanded(
                      flex: 2,
                      child: Container(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.symmetric(
                            horizontal: 80.w,
                            vertical: 40.h,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(AppImages.zuriLogoUrl),
                              verticalSpaceMedium,
                              Text(
                                AppStrings.signIn,
                                style: headline3,
                              ),
                              if (model.hasError) ...[
                                verticalSpaceMedium,
                                Text(
                                  (model.modelError as Failure).message,
                                  style: headline6.copyWith(color: Colors.red),
                                ),
                              ],
                              verticalSpaceMedium,
                              Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    AuthInputField(
                                      label: 'Email',
                                      controller: emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      hintPlaceHolder: AppStrings.emailHint,
                                      validator: context.validateEmail,
                                    ),
                                    verticalSpaceMedium,
                                    AuthInputField(
                                      label: 'Password',
                                      password: true,
                                      controller: passwordController,
                                      isVisible: model.passwordVisible,
                                      onVisibilityTap:
                                          model.setPasswordVisibility,
                                      hintPlaceHolder: AppStrings.passwordHint,
                                      validator: context.validatePassword,
                                    ),
                                  ],
                                ),
                              ),
                              verticalSpaceMedium,
                              SizedBox(
                                height: 45.h,
                                width: 440.w,
                                child: AuthButton(
                                  label: 'Login',
                                  isBusy: model.isBusy,
                                  onTap: () async {
                                    if (!_formKey.currentState!.validate())
                                      return;

                                    await model.login(
                                      email: emailController.text,
                                      password: passwordController.text,
                                    );
                                  },
                                ),
                              ),
                              verticalSpaceMediumTwo,
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Easy Sign in With',
                                    style: bodyText1.copyWith(fontSize: 16.sp),
                                  ),
                                  verticalSpaceSmall,
                                  AuthIcons(),
                                  verticalSpaceSmall,
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Don\'t have an Account?',
                                        style: subtitle2.copyWith(
                                            color: leftNavBarColor),
                                      ),
                                      TextButton(
                                        onPressed: model.goToSignUp,
                                        child: Text(
                                          ' Sign Up',
                                          style: TextStyle(
                                            color: Color(0xff20C18C),
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  verticalSpaceTiny,
                                  TextButton(
                                    onPressed: model.gotoForgetPassword,
                                    child: Text(
                                      'Forgot Password?',
                                      style:
                                          bodyText1.copyWith(fontSize: 16.sp),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      viewModelBuilder: () => LoginViewModel(),
    );
  }
}

class AuthIcons extends ViewModelWidget<LoginViewModel> {
  const AuthIcons({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, LoginViewModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Image.asset(AppImages.googleLogoUrl),
          iconSize: 40.h,
          onPressed: () {},
        ),
        horizontalSpaceRegular,
        IconButton(
          icon: Image.asset(AppImages.facebookLogoUrl),
          iconSize: 40.h,
          onPressed: () {},
        ),
        horizontalSpaceRegular,
        IconButton(
          icon: Image.asset(AppImages.twitterLogoUrl),
          iconSize: 40.h,
          onPressed: () {},
        ),
      ],
    );
  }
}
