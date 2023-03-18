import 'package:flutter/material.dart';
import 'MyPopupScreen.dart';



class MyInkWell extends StatelessWidget {
  const MyInkWell({Key? key, required this.onTap}) : super(key: key);
  final void Function() onTap;
//Виджет капля
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.orange[300],
          shape: BoxShape.circle,
        ),
        width: 30,
        height: 30,
        child: Icon(
          Icons.water_drop,
          color: Colors.orange,
          size: 20,
        ),
      ),
    );
  }
}
