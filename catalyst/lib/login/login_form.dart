import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:catalyst/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginModel {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? password;

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

  final url = Uri.parse('https://catalyst-lb6l.onrender.com/api/users/register');
  try {
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user.toJson()),
    );

    Navigator.pop(context); // Close the progress indicator

    if (response.statusCode == 201) {
      print('User registered successfully!');

      final userData = jsonDecode(response.body)['data']['user'];
      print(userData);
      final registeredUser = User.fromJson(userData);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(user: registeredUser),
        ),
      );
    } else {
      _showErrorDialog(context, 'Registration Failed', 'An error occurred. Please try again.');
      print('Failed to register user. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (e) {
    Navigator.pop(context); // Close the progress indicator
    _showErrorDialog(context, 'Registration Failed', 'An error occurred. Please try again.');
    print('Error registering user: $e');
  }
}

Future<void> loginUser(BuildContext context, String email, String password) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Center(child: CircularProgressIndicator());
    },
  );

  final url = Uri.parse('https://catalyst-lb6l.onrender.com/api/users/login');
  try {
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

    Navigator.pop(context); // Close the progress indicator

    if (response.statusCode == 200) {
      print('User logged in successfully!');
      final userData = jsonDecode(response.body)['data']['user'];
      final loggedInUser = User.fromJson(userData);

      // Save user data in shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('firstName', loggedInUser.firstName ?? '');
      await prefs.setString('lastName', loggedInUser.lastName ?? '');
      await prefs.setString('email', loggedInUser.email ?? '');
      // Add more fields as needed

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(user: loggedInUser),
        ),
      );
    } else if (response.statusCode == 400 &&
        jsonDecode(response.body)['message'] == 'Authentication failed') {
      print('Authentication failed. Incorrect password.');
      _showErrorDialog(context, 'Login Failed', 'Incorrect password. Please try again.');
    } else {
      print('Failed to log in. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      _showErrorDialog(context, 'Login Failed', responseBody['message']);
    }
  } catch (e) {
    Navigator.pop(context); // Close the progress indicator
    _showErrorDialog(context, 'Login Failed', 'An error occurred. Please try again.');
    print('Error logging in user: $e');
  }
}

void _showErrorDialog(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('OK'),
        ),
      ],
    ),
  );
}

class User {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? password;
  final List<dynamic>? stocks;
  final List<dynamic>? projects;
  final String? id;
  final String? image;

  User({
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.stocks,
    this.projects,
    this.id,
    this.image,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    firstName: json["firstName"],
    lastName: json["lastName"],
    email: json["email"],
    password: json["password"],
    stocks: json["stocks"] != null ? List<dynamic>.from(json["stocks"].map((x) => x)) : [],
    projects: json["projects"] != null ? List<dynamic>.from(json["projects"].map((x) => x)) : [],
    id: json["_id"],
    image: json["profileImage"],
  );

  Map<String, dynamic> toJson() => {
    "firstName": firstName,
    "lastName": lastName,
    "email": email,
    "password": password,
    "stocks": stocks != null ? List<dynamic>.from(stocks!.map((x) => x)) : [],
    "projects": projects != null ? List<dynamic>.from(projects!.map((x) => x)) : [],
    "_id": id,
    "profileImage": image,
  };
}
