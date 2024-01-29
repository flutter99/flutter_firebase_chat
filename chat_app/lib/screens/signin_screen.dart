import 'package:chat_app/screens/forgot_password_page.dart';
import 'package:chat_app/screens/home_page.dart';
import 'package:chat_app/screens/signup_screen.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/services/local_database.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool isLoading = false;
  String email = '', password = '', name = '', pic = '', username = '', id = '';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  userLogin() async {
    setState(() {
      isLoading = true;
    });

    try {
      ///
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      QuerySnapshot querySnapshot =
          await DatabaseMethod().getUserByEmail(email);
      name = '${querySnapshot.docs[0]['name']}';
      username = '${querySnapshot.docs[0]['username']}';
      pic = '${querySnapshot.docs[0]['photo']}';
      id = querySnapshot.docs[0].id;

      await LocalDatabase().saveUserDisplayName(name);
      await LocalDatabase().saveUserName(username);
      await LocalDatabase().saveUserPic(pic);
      await LocalDatabase().saveUserEmail(email);
      await LocalDatabase().saveUserID(id);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              'No User Found For This Email',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        );
      } else if (e.code == 'wrong-password') {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              'Incorrect Password',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        );
      }
    } catch (e) {
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
                  'Sign In',
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
                  'Enter your login details',
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

              /// password
              const SizedBox(height: 16),
              CustomTextField(
                heading: 'Password',
                controller: passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'password Field is not empty';
                  }
                  return null;
                },
                hintText: 'Enter your password',
                isObscure: true,
              ),

              /// forgot password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ForgotPassword(),
                      ),
                    );
                  },
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

              /// button
              CustomButton(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      email = emailController.text;
                      password = passwordController.text;
                    });
                    userLogin();
                  }
                },
                isLoading: isLoading,
                buttonText: 'Sign In',
              ),
              const SizedBox(height: 10),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Don\'t have an account?',
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
                            builder: (context) => const SignUpScreen(),
                          ),
                          (route) => false);
                    },
                    child: const Text(
                      'SignUp',
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
      ),
    );
  }
}
