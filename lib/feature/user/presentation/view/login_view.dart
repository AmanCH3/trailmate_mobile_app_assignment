// feature/user/presentation/view/login_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailmate_mobile_app_assignment/app/service_locator/service_locator.dart';
import 'package:trailmate_mobile_app_assignment/core/common/common_textform_view.dart';
import 'package:trailmate_mobile_app_assignment/core/common/trail_mate_loading.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/presentation/view_model/login_view_model/login_event.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/presentation/view_model/login_view_model/login_state.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/presentation/view_model/login_view_model/login_view_model.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return BlocProvider(
      create: (_) => serviceLocator<LoginViewModel>(),
      child: BlocBuilder<LoginViewModel, LoginState>(
        builder: (context, state) {
          final bloc = context.read<LoginViewModel>();

          return Scaffold(
            body: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset('assets/images/login_page.png', fit: BoxFit.cover),
                Container(color: Colors.black.withOpacity(0.7)),
                SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 300,
                  ),
                  child: Form(
                    key: formKey,
                    child: TrailMateLoading(
                      isLoading: state.isLoading,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Welcome!",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 40),
                          CommonTextformView(
                            controller: emailController,
                            label: "Email Address",
                            hint: "Enter your email",
                            validatorMsg: "Please enter your email address",
                            icon: Icons.email,
                            fillColor: Colors.black38,
                            textColor: Colors.white,
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: passwordController,
                            obscureText:
                                !context
                                    .watch<LoginViewModel>()
                                    .state
                                    .isPasswordVisible,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.black38,
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: Colors.white,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  context
                                          .watch<LoginViewModel>()
                                          .state
                                          .isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  final isVisible =
                                      context
                                          .read<LoginViewModel>()
                                          .state
                                          .isPasswordVisible;
                                  context.read<LoginViewModel>().add(
                                    ShowHidePassword(
                                      context: context,
                                      isVisible: !isVisible,
                                    ),
                                  );
                                },
                              ),
                              labelText: "Password",
                              labelStyle: const TextStyle(color: Colors.white),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your password";
                              } else if (value.length < 6) {
                                return "Password must be at least 6 characters";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Checkbox(
                                value: state.rememberMe,
                                onChanged: (val) {
                                  bloc.add(
                                    ToggleRememberMe(value: val ?? false),
                                  );
                                },
                                checkColor: Colors.black,
                                activeColor: Colors.white,
                              ),
                              const Text(
                                "Remember me",
                                style: TextStyle(color: Colors.white),
                              ),
                              const Spacer(),
                              TextButton(
                                onPressed: () {},
                                child: const Text(
                                  "Forgot Password?",
                                  style: TextStyle(color: Color(0x8889C158)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0x8889C158),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed:
                                  state.isLoading
                                      ? null
                                      : () {
                                        if (formKey.currentState!.validate()) {
                                          bloc.add(
                                            LoginWithEmailAndPassword(
                                              context: context,
                                              email:
                                                  emailController.text.trim(),
                                              password:
                                                  passwordController.text
                                                      .trim(),
                                            ),
                                          );
                                        }
                                      },
                              child: const Text(
                                "Sign In",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                bloc.add(
                                  NavigateToRegisterView(context: context),
                                );
                              },
                              child: const Text(
                                "Don't have an account? Sign up",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
