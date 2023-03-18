import 'package:flutter/material.dart';


class MyImageOverlay extends StatefulWidget {
  final Function(String) onImageSelected;

  const MyImageOverlay({Key? key, required this.onImageSelected}) : super(key: key);

  @override
  _MyImageOverlayState createState() => _MyImageOverlayState();
}

class _MyImageOverlayState extends State<MyImageOverlay> {
  String? _selectedFileName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            setState(() {
              _selectedFileName = 'img2_4.png';
            });
            widget.onImageSelected(_selectedFileName!);
          },
          child: const Text('Добавить изображение'),
        ),
        if (_selectedFileName != null)
          Image.asset(
            'assets/images/$_selectedFileName',
            width: 100,
            height: 100,
          ),
      ],
    );
  }
}
