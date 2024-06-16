import 'package:cipherschools_flutter_assignment/main.dart';
import 'package:cipherschools_flutter_assignment/pages/signup_page.dart';
import 'package:cipherschools_flutter_assignment/utils/color_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../widgets/my_textfield.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  bool? isChecked;

  @override
  Widget build(BuildContext context) {
    Future<void> logInWithEmailAndPassword() async {
      try {
        setState(() {
          isLoading = true;
        });
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const MyHomePage()));
        setState(() {
          isLoading = false;
        });
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

    Future<void> logInWithGoogle() async {
      try {
        final GoogleSignInAccount? googleSignInAccount =
            await GoogleSignIn().signIn();
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount!.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        await FirebaseAuth.instance.signInWithCredential(credential);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const MyHomePage()));
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        title: const Text('Log In'),
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
                          logInWithEmailAndPassword();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorConstants.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                        child: const Text(
                          'Log In',
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
                    logInWithGoogle();
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
                        'Log In with Google',
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
                    "Don't have an account? ",
                    style: TextStyle(fontSize: 16),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpScreen()));
                    },
                    child: Text(
                      'SignUp',
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