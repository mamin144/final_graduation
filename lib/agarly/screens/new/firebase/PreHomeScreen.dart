// ignore_for_file: file_names, avoid_unnecessary_containers

import 'package:flutter/material.dart';

import 'LoginPage.dart';
import 'signin.dart';

class PreHomeScreen extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const PreHomeScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
          0xFFDCDCDC), // Set the background color to match the design
      body: Center(
        child: Container(
          width: 350,
          height: 700,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 5,
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Image.asset(
                'lib/pics/Screenshot 2024-06-22 053237.png',
                height: 250.0, // Adjust the height as needed
                width: 300.0, // Adjust the width as needed
              ),
              // const SizedBox(
              //     height: 16.0), // Add some space between image and text
              // const Text(
              //   'AGARLY',
              //   style: TextStyle(
              //     fontSize: 24,
              //     fontWeight: FontWeight.bold,
              //     color: Colors.black,
              //   ),
              // ),
              // const SizedBox(height: 8.0),
              // const Text(
              //   'YOUR DREAM, OUR RENTAL',
              //   textAlign: TextAlign.center,
              //   style: TextStyle(fontSize: 16, color: Colors.black54),
              // ),
              const Spacer(),
              Container(
                width: double.infinity,
                height: 300,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Welcome Back',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 32.0),
                    RoundedButton(
                      text: 'Log In',
                      color: Colors.lightBlue,
                      width: 304.0,
                      height: 50.0,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 16.0),
                    RoundedButton(
                      text: 'Sign Up',
                      color: Colors.lightBlue,
                      width: 304.0,
                      height: 50.0,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignInPage()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RoundedButton extends StatelessWidget {
  final String text;
  final Color color;
  final double width;
  final double height;
  final VoidCallback? onPressed;

  const RoundedButton({
    Key? key,
    required this.text,
    required this.color,
    required this.width,
    required this.height,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(25.0),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
