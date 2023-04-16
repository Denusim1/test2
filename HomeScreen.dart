import 'package:flutter/material.dart';
import 'package:vambaalkon2/screen/screen_1.dart';
import 'package:vambaalkon2/calculator_screen.dart';
import 'dart:io';

class HomeScreen extends StatelessWidget {
  final Directory dir;
  HomeScreen({required this.dir});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Screen1()),
                );
              },
              child: Text('Конструктор балконов'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LaminateCalculator(dir: dir)),
                );
              },
              child: Text('Расчет ламината'),
            ),
          ],
        ),
      ),
    );
  }
}
