import 'dart:convert';
import 'dart:js';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:catalyst/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginModel {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? password;
  static String ID = '';
  LoginModel({
    this.firstName,
    this.lastName,
    this.email,
    this.password,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "password": password,
      };
}

Future<void> registerUser(BuildContext context, LoginModel user) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Center(child: CircularProgressIndicator());
    },
  );

  final url =
      Uri.parse('https://catalyst-lb6l.onrender.com/api/users/register');
  final response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(user.toJson()),
  );

  if (response.statusCode == 201) {
    print('User registered successfully!');
    final userData = jsonDecode(response.body)['data']['user'];
    final registeredUser = User.fromJson(userData);

    // Uncomment and implement navigation to home page with user object
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(user: registeredUser),
      ),
    );
  } else if (response.statusCode >= 400 && response.statusCode < 600) {
    print('Failed to register user. Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Registration Failed'),
        content: Text('An error occurred. Please try again.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  } else {
    print('Unexpected response status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    throw Exception('Failed to register user');
  }
}

Future<void> loginUser(
    BuildContext context, String email, String password) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Center(child: CircularProgressIndicator());
    },
  );

  final url = Uri.parse('https://catalyst-lb6l.onrender.com/api/users/login');
  final response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      'email': email,
      'password': password,
    }),
  );

  if (response.statusCode == 200) {
    print('User logged in successfully!');
    print(response.body);
    final userData = jsonDecode(response.body)['data']['user'];
    final loggedInUser = User.fromJson(userData);

    // Save user data in shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('firstName', loggedInUser.firstName);
    await prefs.setString('lastName', loggedInUser.lastName);
    await prefs.setString('email', loggedInUser.email);
    // Add more fields as needed

    // navigate to hme and send user data tome home
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(user: loggedInUser),
      ),
    );
  } else if (response.statusCode == 400 &&
      jsonDecode(response.body)['message'] == 'Authentication failed') {
    print('Authentication failed. Incorrect password.');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Login Failed'),
        content: Text('Incorrect password. Please try again.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  } else {
    print('Failed to log in. Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    final Map<String, dynamic> responseBody = jsonDecode(response.body);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Login Failed'),
        content: Text(responseBody['message']),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}

class User {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final List<dynamic> stocks;
  final List<dynamic> projects;
  final String id;
  final String image;

  User(
      {required this.firstName,
      required this.lastName,
      required this.email,
      required this.password,
      required this.stocks,
      required this.projects,
      required this.id,
      required this.image});

  factory User.fromJson(Map<String, dynamic> json) => User(
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        password: json["password"],
        stocks: List<dynamic>.from(json["stocks"].map((x) => x)),
        projects: List<dynamic>.from(json["projects"].map((x) => x)),
        id: json["_id"],
        image: json["profileImage"],
      );

  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "password": password,
        "stocks": List<dynamic>.from(stocks.map((x) => x)),
        "projects": List<dynamic>.from(projects.map((x) => x)),
        "_id": id,
        "profileImage": Image,
      };
}
