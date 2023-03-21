import 'package:flutter/material.dart';
import 'MyPopupScreen.dart';
import 'screen_2.dart';

class MyInkWell extends StatefulWidget {
  const MyInkWell({Key? key, required this.onFileSelected}) : super(key: key);
  final void Function(String) onFileSelected;

  @override
  _MyInkWellState createState() => _MyInkWellState();
}

class _MyInkWellState extends State<MyInkWell> {
  AssetImage _image = AssetImage('assets/images/photo_holder.png');
  String _selectedFileName = '';


  void _onFileSelected(String fileName) {
    setState(() {
      _selectedFileName = fileName;
      _image = AssetImage(fileName);
    });
    widget.onFileSelected(fileName); // pass the selected file name to the callback
  }


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await showDialog<String>(
          context: context,
          builder: (BuildContext context) {
            return MyPopupScreen(
              onFileSelected: _onFileSelected,
            );
          },
        );
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.orange,
            width: 1.0,
          ),
        ),
        child: Center(
          child: Icon(
            Icons.water_drop,
            color: Colors.orange,
          ),
        ),
      ),
    );
  }
}
