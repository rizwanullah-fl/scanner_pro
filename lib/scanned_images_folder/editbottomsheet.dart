import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scanner/scanned_images_folder/download_images.dart';

class EditBottomSheet extends StatefulWidget {
  final Function(String) addTextCallback;
  final Function(File) addimageCallbAck;

  const EditBottomSheet(
      {super.key,
      required this.addTextCallback,
      required this.addimageCallbAck});

  @override
  State<EditBottomSheet> createState() => _EditBottomSheetState();
}

class _EditBottomSheetState extends State<EditBottomSheet> {
  String _inputText = '';

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        initialChildSize: 0.2,
        maxChildSize: 0.2,
        minChildSize: 0.1,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            color: Colors.white,
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                  top: 20,
                  left: 20,
                  right: 20,
                  bottom: 20,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () {
                        _openAddTextDialog(context);
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.text_format_sharp,
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            padding:
                                EdgeInsets.all(0), // Set the padding to zero
                            child: Text('Add Text'),
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: _pickImage,
                      child: Row(
                        children: [
                          Icon(
                            Icons.image,
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            padding:
                                EdgeInsets.all(0), // Set the padding to zero
                            child: Text('Add image'),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        height: 45,
                        child: Center(
                            child: Text(
                          "Cancel",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF009B79),
                          ),
                        )),
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 228, 247, 228),
                            borderRadius: BorderRadius.circular(5)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  List<Positioned> textWidgets = [];
  List<DraggableText> draggableTexts = [];
  List<DraggableSignature> draggableSignature = [];
  List<DraggableImage> draggableImage = [];
  File? _pickedImage;

  void _addText(text) {
    setState(() {
      textWidgets.add(
        Positioned(
          top: 100.0,
          left: 100.0,
          child: Draggable(
            feedback: Text(text),
            child: Text(text),
          ),
        ),
      );

      draggableTexts.add(DraggableText(Offset(100.0, 100.0), text));
      if (text.isNotEmpty) {
        widget.addTextCallback(text); // Call the callback with entered text
        setState(() {
          _inputText = ''; // Clear the input field after adding text
        });
      }
    });
  }

  void _openAddTextDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Text'),
          content: TextField(
            onChanged: (value) {
              setState(() {
                _inputText = value; // Update text as it changes
              });
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _addText(_inputText);
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);

     // if (pickedImage != null) {
        widget.addimageCallbAck(File(pickedImage!.path)); // Call the callback with entered text
        setState(() {
          pickedImage!.path;  // Clear the input field after adding text
        });
      }
}
