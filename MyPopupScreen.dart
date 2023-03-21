import 'package:flutter/material.dart';

class MyPopupScreen extends StatefulWidget {
  final Function(String)? onFileSelected;

  const MyPopupScreen({Key? key, this.onFileSelected}) : super(key: key);

  @override
  _MyPopupScreenState createState() => _MyPopupScreenState();
}

class _MyPopupScreenState extends State<MyPopupScreen> {
  late String _fileName;
  double _bottomPosition = 0.0;
  double _screenHeight = 0.0;
  String? _selectedImageName;

  void _onButtonPressed() {
    Navigator.pop(context, {'selectedImageNames': [_selectedImageName!]});
  }

  @override
  void initState() {
    super.initState();
    _fileName = '';
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.18,
      alignment: Alignment.bottomCenter,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(7.0),
          ),
        ),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                itemBuilder: (BuildContext context, int index) {
                  String imageName = 'assets/images/cvet1_$index.png';
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedImageName = imageName;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.all(8.0),
                      width: 100.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _selectedImageName == imageName
                              ? Colors.blue
                              : Colors.grey,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                        image: DecorationImage(
                          image: AssetImage('assets/images/cvet$index.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 50.0,
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_selectedImageName != null) {
                      Navigator.pop(context, _selectedImageName!);
                      widget.onFileSelected?.call(_selectedImageName!);
                    } else {
                      // Show an error message or do something else
                    }
                  },
                  child: const Text('Выбрать'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

