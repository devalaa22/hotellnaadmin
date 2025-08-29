import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:edarhalfnadig/cubit/login_cubit/login_states.dart';
import 'package:edarhalfnadig/cubit/login_cubit/login_cubit.dart';
import 'package:edarhalfnadig/shared/shared.dart';
import 'package:edarhalfnadig/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final disKey = GlobalKey();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginStates>(
      listener: (context, state) {
        if (state is LoginErrorState) {}
      },
      builder: (context, state) {
        LoginCubit cubit = LoginCubit.get(context);
        SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark));
        return Scaffold(
          backgroundColor: Colors.white,
          body: WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: cacheImage(
                          url:
                              'https://www.gannett-cdn.com/-mm-/05b227ad5b8ad4e9dcb53af4f31d7fbdb7fa901b/c=0-64-2119-1259/local/-/media/USATODAY/USATODAY/2014/08/13/1407953244000-177513283.jpg',
                          width: double.infinity,
                          height: 250,
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            DefaultTextField(
                                textForUnValid: 'أدخل رقم الهاتف',
                                controller: emailController,
                                type: TextInputType.number,
                                isValidNumber: true,
                                text: 'رقم الهاتف',
                                prefix: Icons.phone),
                            const SizedBox(
                              height: 20,
                            ),
                            DefaultTextField(
                                textForUnValid: 'أدخل الرمز السري',
                                controller: passwordController,
                                type: TextInputType.visiblePassword,
                                text: 'الرمز السري',
                                prefix: Icons.lock,
                                isPassword: cubit.isPassword,
                                suffix: cubit.isPassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                suffixFunction: () {
                                  cubit.changePasswordShow();
                                }),
                            const SizedBox(
                              height: 20,
                            ),
                            state is! LoginLoadingState
                                ? defaultButton(context: context,
                                    function: () {
                                      if (formKey.currentState!.validate() ==
                                          true) {
                                        cubit.userLogin(
                                            context: context,
                                            adminEmail: emailController.text,
                                            password: passwordController.text);
                                      } else {}
                                    },
                                    text: 'تسجيل الدخول')
                                : Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 5),
                                      child: CircularProgressIndicator(
                                        color: subColor,
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
            ),
          ),
        );
      },
    );
  }
}
