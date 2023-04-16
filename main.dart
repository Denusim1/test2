import 'package:flutter/material.dart';
import 'package:vambaalkon2/startScreenAndAuth/auth.dart';
import 'package:vambaalkon2/startScreenAndAuth/splash_screen.dart';
import 'package:vambaalkon2/screen/screen_1.dart';
import 'dart:async';
import 'package:vambaalkon2/HomeScreen.dart';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';



void main() async {
  FirebaseOptions options = const FirebaseOptions(
    appId: '1:62754477829:android:5ce15231d0dfb4b593c96c',
    apiKey: 'AIzaSyDY4K_pITwRbCwqT5E053gNzgtQFHlR2Us',
    projectId: 'vam-balkon2',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
  );

  // Инициализация Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: options);

  runApp(MyApp());
}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoading = true;
  Directory someDirectory = Directory('/path/to/directory');

  @override
  void initState() {
    super.initState();
    // Имитация задержки для SplashScreen
    Future.delayed(const Duration(seconds: 3), () {
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
        '/screen1': (context) => const Screen1(),
        '/home': (context) => HomeScreen(dir: someDirectory),
        '/auth': (context) => LoginPage(),
      },
    );
  }
}
