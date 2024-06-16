import 'package:cipherschools_flutter_assignment/main.dart';
import 'package:cipherschools_flutter_assignment/pages/complete_profile_page.dart';
import 'package:cipherschools_flutter_assignment/pages/login_page.dart';
import 'package:cipherschools_flutter_assignment/utils/color_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../widgets/my_textfield.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  bool? isChecked;

  @override
  Widget build(BuildContext context) {
    Future<void> signUpWithEmailAndPassword() async {
      try {
        setState(() {
          isLoading = true;
        });
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ProfileDetails()));
        setState(() {
          isLoading = false;
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('The password provided is too weak.')),
          );
          setState(() {
            isLoading = false;
          });
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('The account already exists for that email.')),
          );
          setState(() {
            isLoading = false;
          });
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Error'),
                content: Text(e.toString()),
                actions: <Widget>[
                  ElevatedButton(
                      child: const Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                ],
              );
            });
      }
    }

    Future<void> signUpWithGoogle() async {
      try {
        final GoogleSignInAccount? googleSignInAccount =
            await GoogleSignIn().signIn();
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount!.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential authResult =
            await FirebaseAuth.instance.signInWithCredential(credential);

        final User? user = authResult.user;

        if (authResult.additionalUserInfo!.isNewUser) {
          if (user != null) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ProfileDetails()));
          }
        } else {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const MyHomePage()));
        }
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        title: const Text('Sign Up'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 80,
              ),
              MyTextField(
                myController: emailController,
                hintText: 'Email',
                isPassword: false,
              ),
              const SizedBox(height: 20),
              MyTextField(
                myController: passwordController,
                hintText: 'Password',
                isPassword: true,
              ),
              const SizedBox(height: 20),
              Row(
                children: <Widget>[
                  Transform.scale(
                    scale: 1.4,
                    child: Checkbox(
                      side:
                          BorderSide(color: ColorConstants.primary, width: 1.5),
                      value: isChecked ?? false,
                      onChanged: (value) {
                        setState(() {
                          isChecked = value;
                        });
                      },
                    ),
                  ),
                  Flexible(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'By signing up, you agree to the ',
                            style: TextStyle(
                                color: Colors.black), // Change color as needed
                          ),
                          TextSpan(
                            text: 'Terms of Service',
                            style: TextStyle(
                                color: ColorConstants.primary,
                                fontWeight: FontWeight.bold),
                          ),
                          const TextSpan(
                            text: ' and ',
                            style: TextStyle(
                                color: Colors.black), // Change color as needed
                          ),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: TextStyle(
                                color: ColorConstants.primary,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: double.maxFinite,
                height: 56,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(16)),
                child: isLoading
                    ? SpinKitWave(
                        color: ColorConstants.primary,
                      )
                    : ElevatedButton(
                        onPressed: () {
                          signUpWithEmailAndPassword();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorConstants.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
              ),
              const SizedBox(height: 15),
              const Text('Or with'),
              const SizedBox(height: 15),
              Container(
                width: double.maxFinite,
                height: 56,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                    borderRadius: BorderRadius.circular(16)),
                child: ElevatedButton(
                  onPressed: () {
                    signUpWithGoogle();
                  },
                  style: ElevatedButton.styleFrom(
                    shadowColor: Colors.transparent,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/ic_googleLogo.svg',
                        height: 24.0, // Adjust the height as needed
                        width: 24.0, // Adjust the width as needed
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        'Sign Up with Google',
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account? ',
                    style: TextStyle(fontSize: 16),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LogInScreen()));
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                          color: ColorConstants.primary),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}