import 'package:flutter/material.dart';
import 'screen_2.dart';

class Screen1 extends StatefulWidget {
  const Screen1({Key? key}) : super(key: key);

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  List<bool> _selectedImages = List.filled(8, false);
  List<int> _selectedImageIDs = [];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Выбор основных характеристик балкона/лоджии'),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      Screen2(selectedImageIDs: _selectedImageIDs),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 16, top: 16),
              child: Text(
                'Выберите тип балкона',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildImageContainer(0),
                    _buildImageContainer(1),
                    _buildImageContainer(2),
                    _buildImageContainer(3),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 16, top: 16),
              child: Text(
                'Выберите тип остекления',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildImageContainer(4),
                    _buildImageContainer(5),
                    _buildImageContainer(6),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  List<String> _imageList = [
    'assets/images/start.jpg',
    'assets/images/bal_2.jpg',
    'assets/images/bal_3.jpg',
    'assets/images/bal_4.jpg',
    'assets/images/ost_1.jpg',
    'assets/images/ost_2.jpg',
    'assets/images/ost_3.jpg',
  ];

  Widget _buildImageContainer(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          for (int i = 0; i < _selectedImages.length; i++) {
            if (i ~/ 4 == index ~/ 4 && i != index) {
              _selectedImages[i] = false;
            }
          }
          _selectedImages[index] = !_selectedImages[index];
          if (_selectedImages[index]) {
            _selectedImageIDs.add(index);
          } else {
            _selectedImageIDs.remove(index);
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.shade400,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                _imageList[index],
                width: 300,
                height: 300,
                fit: BoxFit.cover,
              ),
            ),
            if (_selectedImages[index])
              Positioned(
                bottom: 16,
                right: 16,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}