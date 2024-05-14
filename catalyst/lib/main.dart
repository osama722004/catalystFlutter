import 'package:catalyst/home/add_project.dart';
import 'package:catalyst/home/home_view.dart';
import 'package:catalyst/login/login_form.dart';
import 'package:catalyst/splash/splash.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'login/login_view.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
User user=User(firstName: 'osama',lastName: 'zaid',email: 'zdrosama@gmail.com',id: '1',password: "123456789",image: 'osama',stocks: [],projects: [] );
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomePage(user: user,));
  }
}
