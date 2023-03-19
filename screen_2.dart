import 'package:flutter/material.dart';
import 'MyPopupScreen.dart';
import 'Widget_stena1.dart';

class Screen2 extends StatefulWidget {
  final List<int> selectedImageIDs;

  Screen2({Key? key, required this.selectedImageIDs}) : super(key: key);

  @override
  _Screen2State createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  ImageProvider _defaultImage = AssetImage('assets/images/image1.png');
  ImageProvider _image = AssetImage('assets/images/image1.png');
  String? _selectedFileName;
  double _left = 0;
  double _dragStart = 0;

  void _updateImage(ImageProvider image) {
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Выбор отделки'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          SizedBox(
            width: 500,
            height: 500,
            child: GestureDetector(
              onHorizontalDragStart: (DragStartDetails details) {
                _dragStart = details.localPosition.dx;
              },
              onHorizontalDragUpdate: (DragUpdateDetails details) {
                setState(() {
                  _left -= (_dragStart - details.localPosition.dx);
                  _dragStart = details.localPosition.dx;
                });
              },
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 600,
                          height: 600,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Image.asset(
                                  'assets/images/img2_${widget.selectedImageIDs.sublist(widget.selectedImageIDs.length - 2, widget.selectedImageIDs.length)[0]}.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned.fill(
                                child: Image.asset(
                                  'assets/images/img2_${widget.selectedImageIDs.sublist(widget.selectedImageIDs.length - 2, widget.selectedImageIDs.length)[1]}.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned.fill(
                                child: Image(
                                  image: _image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 280,
                          left: 00,
                          right: 0,
                          child: Center(
                            child: SizedBox(
                              width: 50.0,
                              height: 50.0,
                              child: MyInkWell(
                                onFileSelected: (fileName) async {
                                  var fileName = await showDialog<String>(
                                    context: context,
                                    barrierColor: Colors.transparent,
                                    builder: (BuildContext context) {
                                      return MyPopupScreen(
                                        onFileSelected: (fileName) {

                                          _selectedFileName = fileName;
                                        },
                                      );
                                    },
                                  );
                                  if (fileName != null) {
                                    setState(() {
                                      _image = AssetImage(fileName);
                                    });
                                  }
                                },

                                //child: Icon(Icons.photo_library),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



