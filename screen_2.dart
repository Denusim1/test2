import 'package:flutter/material.dart';
import 'MyPopupScreen.dart';
import 'Widget_stena1.dart';

class Screen2 extends StatefulWidget {
  final List<int> selectedImageIDs;


  const Screen2({Key? key, required this.selectedImageIDs}) : super(key: key);

  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  String? _selectedFileName;
  double _left = 0;
  double _dragStart = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Выбор отделки '),
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
                            ],
                          ),
                        ),
                        Positioned(
                          top: 300.0,
                          left: 290.0,
                          child: MyInkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (BuildContext context) {
                                  return Align(
                                    alignment: Alignment.bottomCenter,
                                    child: FractionallySizedBox(
                                      child: MyPopupScreen(),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),
          Text('Selected image IDs: ${widget.selectedImageIDs}'),
          if (_selectedFileName != null)
            Text('Selected file name: $_selectedFileName'),
        ],
      ),
    );
  }
  void _onFileSelected(String fileName) {
    setState(() {
      _selectedFileName = fileName;
    });
  }
}


