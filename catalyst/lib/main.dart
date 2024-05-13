import 'package:catalyst/home/add_project.dart';
import 'package:catalyst/home/home_view.dart';
import 'package:catalyst/login/login_form.dart';
import 'package:catalyst/splash/splash.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'login/login_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: AddProject());
  }
}
