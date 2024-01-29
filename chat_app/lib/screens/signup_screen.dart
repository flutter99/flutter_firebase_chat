import 'package:chat_app/screens/home_page.dart';
import 'package:chat_app/screens/signin_screen.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/services/local_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../widgets/custom_button.dart';
import '../widgets/custom_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isLoading = false;
  String name = '', email = '', password = '', confirmPassword = '';

  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  registration() async {
    if (email.isNotEmpty &&
        password.isNotEmpty &&
        password == confirmPassword) {
      setState(() {
        isLoading = true;
      });

      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        String id = Uuid().v1();

        Map<String, dynamic> userInfoMap = {
          'id': id,
          'name': nameController.text,
          'email': emailController.text,
          'username': emailController.text.replaceAll('@gmail.com', ''),
          'photo':
              'https://firebasestorage.googleapis.com/v0/b/chat-app-fb631.appspot.com/o/user%20(2).jpg?alt=media&token=ad276cb6-147f-4976-95df-200de18d7e6f',
        };

        ///
        DatabaseMethod databaseMethod = DatabaseMethod();
        await databaseMethod.addUserDetails(userInfoMap, id);

        await LocalDatabase().saveUserID(id);
        await LocalDatabase().saveUserEmail(emailController.text);
        await LocalDatabase().saveUserDisplayName(nameController.text);
        await LocalDatabase().saveUserName(
          emailController.text.replaceAll('@gmail.com', ""),
        );
        await LocalDatabase().saveUserPic(
            'https://firebasestorage.googleapis.com/v0/b/chat-app-fb631.appspot.com/o/user%20(2).jpg?alt=media&token=ad276cb6-147f-4976-95df-200de18d7e6f');

        setState(() {
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              'Registration Successfully',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );

        ///
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                'Your Password is Week',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          );
        } else if (e.code == 'email-already-in-use') {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                'Email is already is use',
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
        setState(() {
          isLoading = false;
        });
      }
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
                controller: nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter Your Name';
                  }
                  return null;
                },
                hintText: 'Enter your name',
              ),

              /// email
              const SizedBox(height: 16),
              CustomTextField(
                heading: 'Email',
                controller: emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter Your Email';
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
                    return 'Enter Your password';
                  }
                  return null;
                },
                hintText: 'Enter your password',
                isObscure: true,
              ),

              /// password
              const SizedBox(height: 16),
              CustomTextField(
                heading: 'Confirm Password',
                controller: confirmPasswordController,
                validator: (value) {
                  if (value == null ||
                      passwordController.text !=
                          confirmPasswordController.text) {
                    return 'Password is not matched';
                  }
                  return null;
                },
                hintText: 'Enter your password again',
                isObscure: true,
              ),

              /// button
              const SizedBox(height: 40),
              CustomButton(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      name = nameController.text;
                      email = emailController.text;
                      password = passwordController.text;
                      confirmPassword = confirmPasswordController.text;
                    });

                    registration();
                  }
                },
                isLoading: isLoading,
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
      ),
    );
  }
}
