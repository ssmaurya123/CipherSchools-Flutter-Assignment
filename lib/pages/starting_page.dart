import 'package:cipherschools_flutter_assignment/pages/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StartingScreen extends StatelessWidget {
  const StartingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
          height: height,
          width: width,
          decoration: const BoxDecoration(color: Color.fromRGBO(123, 97, 255, 1)),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 40,
                ),
                const Image(
                  image: AssetImage("assets/images/logo.png"),
                  height: 80,
                  width: 80,
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Welcome to",
                          style: GoogleFonts.aBeeZee(
                              fontSize: 40,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "CipherX.",
                          style: GoogleFonts.brunoAceSc(
                              fontSize: 36,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                        )
                      ],
                    ),
                    Container(
                      height: 90,
                      width: 90,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(45),
                          color: const Color.fromRGBO(237, 225, 225, 0.75)),
                      child: IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignUpScreen()));
                          },
                          icon: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 60,
                            color: Colors.black,
                          )),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "The best way to track your expenses.",
                  style: GoogleFonts.aBeeZee(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.white),
                ),
                const SizedBox(
                  height: 60,
                )
              ],
            ),
          )),
    );
  }
}