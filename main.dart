


import 'package:flutter/material.dart';
import 'package:vambaalkon2/auth.dart';
import 'package:vambaalkon2/splash_screen.dart';
import 'package:vambaalkon2/screen_1.dart';
//import 'package:phone_otp_ui/screen_2.dart';
import 'package:flutter/foundation.dart';

import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _isLoading ? SplashScreen() : LoginPage(),
      routes: {
        '/screen1': (context) => Screen1(),
        //'/screen2': (context) => BalconyInsideScreen(),
      },
    );
  }
}
