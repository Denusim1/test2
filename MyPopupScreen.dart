import 'package:flutter/material.dart';
import 'screen_2.dart';

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
  List<String> _selectedImageNames = [];
  List<int> _selectedImageIndexList = [];

  void _toggleImageSelection(String imageName, int index) {
    setState(() {
      if (_selectedImageNames.contains(imageName)) {
        _selectedImageNames.remove(imageName);
        _selectedImageIndexList.removeWhere((element) => element == index);
      } else {
        _selectedImageNames.add(imageName);
        _selectedImageIndexList.add(index);
      }
    });
  }

  void _onButtonPressed() {
    Navigator.pop(context, {'selectedImageNames': _selectedImageNames, 'selectedImageIndexList': _selectedImageIndexList});
  }

  @override
  void initState() {
    super.initState();
    _fileName = '';
  }

  @override
  Widget build(BuildContext context) {
    _screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity?.isNegative == false) {
          Navigator.pop(context);
        }
      },
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
        height: _screenHeight * 0.18,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                itemBuilder: (BuildContext context, int index) {
                  String imageName = 'assets/images/cvet$index.jpg';
                  return GestureDetector(
                    onTap: () {
                      _toggleImageSelection(imageName, index);
                      widget.onFileSelected?.call(imageName); // call the callback function
                    },
                    child: Container(
                      margin: EdgeInsets.all(8.0),
                      width: 100.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _selectedImageNames.contains(imageName)
                              ? Colors.blue
                              : Colors.grey,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                        image: DecorationImage(
                          image: AssetImage(imageName),
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
                  child: Text('Выбрать'),
                  onPressed: () {
                    Navigator.pop(context, _selectedImageNames.first); // передаем первое выбранное изображение
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
