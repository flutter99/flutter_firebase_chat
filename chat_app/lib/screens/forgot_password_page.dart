import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/custom_button.dart';
import '../widgets/custom_field.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String email = "";
  bool isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();

  resetPassword() async {
    setState(() {
      isLoading = true;
    });
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "Password Reset Email has been sent",
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      if (e.code == "user-not-found") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "No User found for that email.",
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// body
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: ListView(
            children: [
              /// heading
              const SizedBox(height: 30),
              const Center(
                child: Text(
                  'Forgot Password',
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
                  'Enter your email to reset password',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              /// email address
              const SizedBox(height: 30),
              CustomTextField(
                heading: 'Email',
                controller: emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email Field is not empty';
                  }
                  return null;
                },
                hintText: 'Enter your email',
              ),

              const SizedBox(height: 24),

              /// button
              CustomButton(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      email = emailController.text;
                    });
                    resetPassword();
                  }
                },
                isLoading: isLoading,
                buttonText: 'Reset',
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
