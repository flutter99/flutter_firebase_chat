import 'package:chat_app/screens/signin_screen.dart';
import 'package:flutter/material.dart';

import '../widgets/custom_button.dart';
import '../widgets/custom_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// body
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ListView(
          children: [
            /// heading
            const SizedBox(height: 30),
            const Center(
              child: Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            /// desc
            const SizedBox(height: 12),
            const Center(
              child: Text(
                'Enter details to create account',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            /// email address
            const SizedBox(height: 60),
            CustomTextField(
              heading: 'Name',
              controller: TextEditingController(),
              hintText: 'Enter your name',
            ),

            /// email
            const SizedBox(height: 16),
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

            /// password
            const SizedBox(height: 16),
            CustomTextField(
              heading: 'Confirm Password',
              controller: TextEditingController(),
              hintText: 'Enter your password again',
              isObscure: true,
            ),

            /// button
            const SizedBox(height: 40),
            CustomButton(
              onTap: () {},
              buttonText: 'Sign Up',
            ),
            const SizedBox(height: 10),

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Already have an account?',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignInScreen(),
                        ),
                        (route) => false);
                  },
                  child: const Text(
                    'LogIn',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
