import 'package:catalyst/home/home_view.dart';
import 'package:catalyst/login/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';

import '../signUp/sign_up.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(87, 154, 255, 1.0),
            ),
            child: Column(
              children: [
                SizedBox(height: 63),
                Text(
                  "Hi, Welcome Back!",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                SizedBox(height: 50),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(100)),
                  ),
                  child: Column(
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email address.';
                                  }
                                  if (!value
                                      .toLowerCase()
                                      .endsWith('@gmail.com')) {
                                    return 'Please enter a valid Gmail address.';
                                  }
                                  return null; // No error
                                },
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.email,
                                      color: Color.fromRGBO(77, 134, 156, 1)),
                                  labelText: 'E-mail',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                onChanged: (value) =>
                                    setState(() => _email = value),
                              ),
                            ),
                            SizedBox(height: 40),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password.';
                                  }
                                  if (value.length < 6) {
                                    return 'Password must be at least 6 characters long.';
                                  }
                                  if (!RegExp(r'[a-zA-Z]').hasMatch(value)) {
                                    return 'Password must contain at least one letter.';
                                  }
                                  return null; // No error
                                },
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.lock,
                                      color: Color.fromRGBO(77, 134, 156, 1)),
                                  labelText: 'Password',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(_obscureText
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined),
                                    onPressed: () {
                                      setState(
                                          () => _obscureText = !_obscureText);
                                    },
                                  ),
                                ),
                                obscureText: _obscureText,
                                onChanged: (value) =>
                                    setState(() => _password = value),
                              ),
                            ),
                            SizedBox(height: 40),
                            ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  print("it cliked");
                                  loginUser(context, _email, _password);
                                }
                              },
                              child: Text('Login',
                                  style: TextStyle(color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                primary: Color.fromRGBO(77, 134, 156, 1),
                                minimumSize: Size(300, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Don\'t have an account! ',
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "Sign up",
                                    style: TextStyle(color: Colors.blue),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                          PageRouteBuilder(
                                              pageBuilder: (_, __, ___) =>
                                                  SignupView(),
                                              transitionsBuilder: (context,
                                                  animation,
                                                  secondaryAnimation,
                                                  child) {
                                                const begin = Offset(1.0, 0.0);
                                                const end = Offset.zero;
                                                const curve = Curves.easeInOut;
                                                var tween = Tween(
                                                        begin: begin, end: end)
                                                    .chain(CurveTween(
                                                        curve: curve));
                                                var offsetAnimation =
                                                    animation.drive(tween);
                                                return SlideTransition(
                                                  position: offsetAnimation,
                                                  child: child,
                                                );
                                              },
                                              transitionDuration:
                                                  Duration(seconds: 1)),
                                          (route) => false,
                                        );
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
