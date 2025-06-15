import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/presentation/view_model/register_view_model/register_event.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/presentation/view_model/register_view_model/register_view_model.dart';

import '../../../../core/common/common_textform_view.dart';
import 'login_view.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final fullNameController = TextEditingController();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();

  final phoneNumberController = TextEditingController();

  final myKey = GlobalKey<FormState>();

  bool _obscurePassword = true;

  // Simple email validation regex
  final RegExp _emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/login_page.png', fit: BoxFit.cover),

          Container(color: Colors.black.withOpacity(0.7)),

          SingleChildScrollView(
            padding: EdgeInsets.all(18),
            child: Form(
              key: myKey,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: const Text(
                      "Create an account",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // TextFormField(
                  //   controller: fullNameController,
                  //   style: const TextStyle(color: Colors.white),
                  //   decoration: InputDecoration(
                  //     filled: true,
                  //     fillColor: Colors.black38,
                  //     prefixIcon: Icon(Icons.person, color: Colors.white),
                  //     labelStyle: const TextStyle(color: Colors.white),
                  //
                  //     labelText: 'Fullname',
                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(8),
                  //       borderSide: BorderSide.none,
                  //     ),
                  //   ),
                  //   validator: (value) {
                  //     if (value == null || value.isEmpty) {
                  //       return "Email is required";
                  //     } else if (!_emailRegExp.hasMatch(value)) {
                  //       return "Enter a valid email";
                  //     }
                  //     return null;
                  //   },
                  // ),
                  CommonTextformView(
                    controller: fullNameController,
                    label: 'Fullname',
                    hint: "Provide your full name",
                    validatorMsg: "Please enter your name",
                    icon: Icons.person,
                  ),

                  SizedBox(height: 18),
                  // TextFormField(
                  //   controller: emailController,
                  //   style: const TextStyle(color: Colors.white),
                  //   keyboardType: TextInputType.emailAddress,
                  //   decoration: InputDecoration(
                  //     filled: true,
                  //     fillColor: Colors.black38,
                  //     prefixIcon: Icon(Icons.email, color: Colors.white),
                  //
                  //     labelText: 'Email address',
                  //     labelStyle: const TextStyle(color: Colors.white),
                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(8),
                  //       borderSide: BorderSide.none,
                  //     ),
                  //   ),
                  // ),
                  CommonTextformView(
                    controller: emailController,
                    label: "Email address",
                    hint: "abc@gmail.com",
                    validatorMsg: "Please provide your valid email address",
                    icon: Icons.email,
                  ),
                  SizedBox(height: 18),
                  TextFormField(
                    obscureText: _obscurePassword,
                    controller: passwordController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.black38,
                      labelStyle: const TextStyle(color: Colors.white),
                      prefixIcon: Icon(Icons.lock, color: Colors.white),
                      suffixIcon: Icon(Icons.visibility, color: Colors.white),
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your password";
                      } else if (value.length < 6) {
                        return "Password must be at least 6 charcters";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 18),
                  TextFormField(
                    controller: confirmPasswordController,
                    style: const TextStyle(color: Colors.white),
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.black38,
                      prefixIcon: Icon(Icons.lock, color: Colors.white),
                      // suffixIcon: Icon(Icons.visibility, color: Colors.white),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscurePassword:
                            !_obscurePassword;
                          });
                        },
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.white,
                        ),
                      ),
                      labelText: 'Confirm password',

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
                        return "Password must be at least 6 charcters";
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 18),

                  TextFormField(
                    controller: phoneNumberController,
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.phone,

                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.black38,
                      labelStyle: const TextStyle(color: Colors.white),
                      prefixIcon: Icon(Icons.phone, color: Colors.white),

                      labelText: "Contact no",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Phone number is required';
                      } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                        return 'Enter a valid 10-digit number';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 25),

                  Container(
                    width: double.infinity,

                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0x8889C158),
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        if (myKey.currentState!.validate()) {
                          var fullName = fullNameController.text;
                          var email = emailController.text;
                          var password = passwordController.text;
                          var confirmPassword = confirmPasswordController.text;
                          var phone = phoneNumberController.text;

                          debugPrint(
                            'fullname : $fullName ,email : $email , password   : $password , confirmpassword : $confirmPassword , phone : $phone',
                          );
                        }
                      },
                      child: Text(
                        "Sign in",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account ?',
                        style: const TextStyle(color: Colors.white),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginView(),
                            ),
                          );
                        },
                        child: Text(
                          'Sign in',
                          style: TextStyle(color: Color(0x8889C158)),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    child: Row(
                      children: [
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              if (myKey.currentState!.validate()) {
                                context.read<RegisterViewModel>().add(
                                  RegisterUserEvent(
                                    context: context,
                                    name: fullNameController.text,
                                    password: passwordController.text,
                                    phone: phoneNumberController.text,
                                    email: emailController.text,
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              side: const BorderSide(color: Colors.white),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 98,
                                vertical: 15,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              backgroundColor: Colors.white,
                            ),
                            icon: Image.asset(
                              "assets/images/google_image.png",
                              height: 24,
                              width: 24,
                              fit: BoxFit.contain,
                            ),

                            label: const Text(
                              "Sign in with Google",
                              style: TextStyle(color: Colors.black),
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
        ],
      ),
    );
  }
}
