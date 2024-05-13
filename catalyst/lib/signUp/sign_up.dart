import 'dart:convert';
import 'package:catalyst/login/login_form.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupView extends StatefulWidget {
  const SignupView({Key? key}) : super(key: key);

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final _formKey = GlobalKey<FormState>();
  String _firstName = '';
  String _lastName = '';
  String _email = '';
  String _password = '';
  String _verifyPassword = '';
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(height: 80),
          Text(
            'Create an account',
            style: GoogleFonts.poppins(
              color: Color.fromRGBO(77, 134, 156, 1),
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 15),
          Text(
            'Successful investing is about managing risk, not avoiding it.',
            style: GoogleFonts.poppins(
              color: Color.fromRGBO(77, 134, 156, 1),
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your first name.';
                                  }
                                  return null; // No error
                                },
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.account_circle_outlined,
                                    color: Color.fromRGBO(77, 134, 156, 1),
                                  ),
                                  labelText: 'First Name',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                onChanged: (value) =>
                                    setState(() => _firstName = value),
                              ),
                            ),
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your last name.';
                                  }
                                  return null; // No error
                                },
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.account_circle_outlined,
                                    color: Color.fromRGBO(77, 134, 156, 1),
                                  ),
                                  labelText: 'Last Name',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                onChanged: (value) =>
                                    setState(() => _lastName = value),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email address.';
                            }
                            if (!value.toLowerCase().endsWith('@gmail.com')) {
                              return 'Please enter a valid Gmail address.';
                            }
                            return null; // No error
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: Color.fromRGBO(77, 134, 156, 1),
                            ),
                            labelText: 'Email Address or Phone Number',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onChanged: (value) => setState(() => _email = value),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: TextFormField(
                          obscureText: _obscureText,
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
                            suffixIcon: IconButton(
                                icon: Icon(_obscureText
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined),
                                onPressed: () {
                                  setState(() => _obscureText = !_obscureText);
                                }),
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: Color.fromRGBO(77, 134, 156, 1),
                            ),
                            labelText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onChanged: (value) =>
                              setState(() => _password = value),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: TextFormField(
                          obscureText: _obscureText,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a password.';
                            }
                            if (value != _password) {
                              return 'Passwords do not match.';
                            }
                            return null; // No error
                          },
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                                icon: Icon(_obscureText
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined),
                                onPressed: () {
                                  setState(() => _obscureText = !_obscureText);
                                }),
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: Color.fromRGBO(77, 134, 156, 1),
                            ),
                            labelText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onChanged: (value) =>
                              setState(() => _verifyPassword = value),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      print("================================================");
                      LoginModel loginModel = LoginModel(
                          firstName: _firstName,
                          lastName: _lastName,
                          email: _email,
                          password: _password);
                      registerUser(context,loginModel);
                      print("================================================");
                    }
                  },
                  child: Text('Sign Up', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromRGBO(77, 134, 156, 1),
                    minimumSize: Size(300, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
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
