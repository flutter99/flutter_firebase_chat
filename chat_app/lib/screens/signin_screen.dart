import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_field.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// body
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              /// email address
              const SizedBox(height: 60),
              CustomTextField(
                heading: 'Email',
                controller: TextEditingController(),
                hintText: 'Enter your email',
              ),

              /// password
              const SizedBox(height: 16),
              CustomTextField(
                heading: 'Password',
                controller: TextEditingController(),
                hintText: 'Enter your password',
                isObscure: true,
              ),

              /// forgot password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              CustomButton(
                onTap: () {},
                buttonText: 'Sign In',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
