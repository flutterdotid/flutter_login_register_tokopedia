import 'package:flutter/material.dart';
import 'package:tokopedia/ui/screens/home_screen.dart';
import 'package:tokopedia/ui/screens/login_screen.dart';
import 'package:tokopedia/ui/screens/register_screen.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tokopedia',
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
        "/login" : (context) => LoginScreen(),
        "/register" : (context) => RegisterScreen(),
        "/home" : (context) => HomeScreen(),
      },
    );
  }
}
