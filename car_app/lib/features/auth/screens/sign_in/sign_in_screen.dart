import 'package:car_app/core/extensions/context_extension.dart';
import 'package:car_app/core/extensions/int_extension.dart';
import 'package:car_app/core/extensions/list_extension.dart';
import 'package:car_app/core/extensions/textstyle_extension.dart';
import 'package:car_app/core/mixins/app_notice.dart';
import 'package:car_app/core/resource/app_assets.dart';
import 'package:car_app/core/services/shared_prefs.dart';
import 'package:car_app/core/theme/app_colors.dart';
import 'package:car_app/core/theme/app_textstyles.dart';
import 'package:car_app/features/auth/screens/auth_button.dart';
import 'package:car_app/features/auth/screens/auth_text_field.dart';
import 'package:car_app/features/auth/screens/sign_in/sign_up_screen.dart';
import 'package:car_app/features/home/home_screen.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> with AppNotice {
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  final _prefs = SharedPrefs();

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 28, right: 13),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              60.verticalSpace,
              Text(
                'Sign in',
                style: AppTextstyles.regular.setSize(48),
              ),
              100.verticalSpace,
              AuthTextField(
                controller: _loginController,
                hint: 'Enter email',
                title: 'EMAIL OR PHONE',
              ),
              20.verticalSpace,
              AuthTextField(
                controller: _passwordController,
                hint: '*******',
                title: 'PASSWORD',
              ),
              20.verticalSpace,
              const Text('Forgot password?'),
              40.verticalSpace,
              InkWell(
                onTap: () async {
                  final login = await _prefs.read(key: StorageKey.login);
                  final password = await _prefs.read(key: StorageKey.password);
                  if (login == _loginController.text &&
                      password == _passwordController.text) {
                    showSuccess(message: 'Успешный вход');
                    context.push(
                      const HomeScreen(),
                    );
                  } else {
                    showError(errorText: 'Ошибка при авторизации');
                  }
                },
                child: Container(
                  height: 60,
                  padding: [12, 60].symmetricPadding,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: AppColors.mainColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: SizedBox(
                      child: Text(
                        'Log in',
                        style: AppTextstyles.semiBold
                            .setSize(20)
                            .copyWith(color: AppColors.textColor),
                      ),
                    ),
                  ),
                ),
              ),
              15.verticalSpace,
              const Center(child: Text('OR')),
              15.verticalSpace,
              const AuthButton(
                image: AppAssets.chrome,
                text: 'Continue with Facebook',
              ),
              13.verticalSpace,
              const AuthButton(
                image: AppAssets.facebook,
                text: 'Continue with LogoDev',
              ),
              40.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Don’t Have an account yet?'),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'SIGN UP',
                      style: TextStyle(color: Colors.orange),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
