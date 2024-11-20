import 'dart:math';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:scanner/management/provider_image.dart';
import 'package:scanner/scanned_images_folder/download_images.dart';

class SignatureOverlay extends StatefulWidget {
  final String folderName;
  final int index;
  final File images;
  final Uint8List signatureBytes;
  final Offset signaturePosition;

  const SignatureOverlay({
    required this.folderName,
    required this.index,
    required this.images,
    required this.signatureBytes,
    required this.signaturePosition,
  });

  @override
  _SignatureOverlayState createState() => _SignatureOverlayState();
}

class _SignatureOverlayState extends State<SignatureOverlay> {
  late DraggableSignature _draggableSignature;
  double _containerWidth = 450; // Initial width
  double _containerHeight = 620; // Initial height
  double _rotationAngle = 0;
  bool draggable = false;
  double previousLeft = 0.0;
  double previousTop = 0.0;
  GlobalKey _globalKey = GlobalKey();
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    _draggableSignature =
        DraggableSignature(Offset.zero, "Signature", size: Size.zero);
    previousLeft = (500 - (_containerWidth / 2)) / 2;
    previousTop = (680 - (_containerHeight / 2)) / 2;
  }

  DraggableSignature signature = DraggableSignature(
    Offset(0, 0),
    'Your Signature',
    size: Size(0, 50),
  );
  @override
  Widget build(BuildContext context) {
    final selectedImages = Provider.of<ImageListProvider>(context, listen: true)
        .getImagesForItem(widget.folderName);
    ImageListProvider imageListProvider =
        Provider.of<ImageListProvider>(context, listen: true);
    double defaultLeft = (500 - (_containerWidth / 2)) / 2;
    double defaultTop = (680 - (_containerHeight / 2)) / 2;
    // double currentLeft = previousLeft;
    // double currentTop = previousTop;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xff192A36),
        title: Text(
          'Signature',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
              onPressed: () {
                if (_isSavingImage == false) {
                  setState(() {
                    _isSavingImage =
                        true; // Set _isSavingImage to true before saving the image
                  });
                } else {
                  setState(() {
                    _isSavingImage =
                        false; // Set _isSavingImage to true before saving the image
                  });
                }
              },
              child: Text(
                _isSavingImage == true ? 'Preview' : 'Edit',
                style: TextStyle(
                    color:
                        _isSavingImage == true ? Colors.white : Colors.white),
              )),
          TextButton(
            onPressed: () async {
              setState(() {
                _isSavingImage =
                    false; // Set _isSavingImage to true before saving the image
                isLoading = true;
              });
              await Future.delayed(Duration(seconds: 3));

              final boundary = _globalKey.currentContext!.findRenderObject()
                  as RenderRepaintBoundary;
              final image = await boundary.toImage(
                pixelRatio: 3, // Adjust pixelRatio as needed
              );

              final byteData =
                  await image.toByteData(format: ImageByteFormat.png);
              final buffer = byteData!.buffer.asUint8List();
              final img.Image baseImage = img.decodeImage(buffer)!;
              Uint8List newImageBytes = Uint8List.fromList(await buffer);
              print(newImageBytes);
              final snackBar = SnackBar(
                content: Text('Signature Added'), // Your snackbar message
                duration: Duration(seconds: 2),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              // Now you can pass the newImageBytes to the updateImages method
              imageListProvider.updateImages(
                widget.folderName,
                selectedImages[widget.index],
                newImageBytes,
              );
              isLoading = false;
              Navigator.pop(context);
            },
            child: Text(
              'Done',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 12, right: 12, top: 17),
            child: RepaintBoundary(
              key: _globalKey,
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height - 150,
                    width: 600,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(selectedImages[widget.index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // isLoading
                  //     ? CircularProgressIndicator()
                  //     :
                  Positioned(
                    left: draggable
                        ? _draggableSignature.position.dx
                        : previousLeft,
                    top: draggable
                        ? _draggableSignature.position.dy
                        : previousTop,
                    child: GestureDetector(
                      onPanEnd: (details) {
                        setState(() {
                          draggable = false;
                          previousLeft = _draggableSignature.position.dx;
                          previousTop = _draggableSignature.position.dy;
                        });
                      },
                      onPanUpdate: (details) {
                        setState(() {
                          draggable = true;
                          _draggableSignature.updatePosition(
                            _draggableSignature.position + details.delta,
                          );
                        });
                      },
                      child: Stack(
                        children: [
                          Transform.rotate(
                            angle: _rotationAngle,
                            child: Container(
                              width: _containerWidth / 2,
                              height: _containerHeight / 2,
                              child: Stack(
                                children: [
                                  Image.memory(
                                    widget.signatureBytes,
                                  ),
                                  if (_isSavingImage)
                                    Container(
                                      width: _containerWidth / 2,
                                      height: _containerHeight / 2,
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        border: Border.all(color: Colors.blue),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        // crossAxisAlignment:
                                        //     CrossAxisAlignment.end,
                                        children: [
                                          Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Container(
                                              height: 100,
                                              alignment: Alignment.bottomLeft,
                                              child: GestureDetector(
                                                onDoubleTap: () {
                                                  setState(() {
                                                    _containerWidth *= 1.1;
                                                    _containerHeight *= 1.1;
                                                    _containerWidth =
                                                        _containerWidth.clamp(
                                                            30.0,
                                                            double.infinity);
                                                    _containerHeight =
                                                        _containerHeight.clamp(
                                                            30.0,
                                                            double.infinity);

                                                    // Update the size
                                                    _draggableSignature.setSize(
                                                        _containerWidth,
                                                        rotationAngle:
                                                            _rotationAngle);
                                                  });
                                                },
                                                onPanUpdate: (details) {
                                                  setState(() {
                                                    // Calculate the change in both dimensions based on the average change
                                                    double deltaAverage =
                                                        (details.delta.dy +
                                                                details
                                                                    .delta.dy) /
                                                            2.0;
                                                    double newWidth =
                                                        (_containerWidth +
                                                                deltaAverage)
                                                            .clamp(
                                                                404.9031207443263,
                                                                double
                                                                    .infinity);
                                                    double newHeight =
                                                        (_containerWidth +
                                                                deltaAverage /
                                                                    2)
                                                            .clamp(
                                                                404.9031207443263,
                                                                double
                                                                    .infinity);

                                                    print(newWidth);
                                                    _draggableSignature.setSize(
                                                        newWidth,
                                                        rotationAngle:
                                                            _rotationAngle);

                                                    // Update both dimensions equally
                                                    _containerWidth = newWidth;
                                                    _containerHeight =
                                                        newHeight;
                                                  });
                                                },
                                                child: Image.asset(
                                                  'assets/images/resize.png',
                                                  color: Colors.white,
                                                  height: 100,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.topRight,
                                            child: Container(
                                              height: 100,
                                              alignment: Alignment.topRight,
                                              child: GestureDetector(
                                                onDoubleTap: () {
                                                  setState(() {
                                                    print('sdcsd');
                                                    _rotationAngle += (pi /
                                                        12); // Change angle by 15 degrees (pi/12 radians)
                                                    // Ensure the angle stays within 0 to 2*pi range
                                                    _rotationAngle %= (2 * pi);
                                                    // Update the size and rotation angle
                                                    _draggableSignature.setSize(
                                                        _containerWidth,
                                                        rotationAngle:
                                                            _rotationAngle);
                                                  });
                                                },
                                                onPanUpdate: (details) {
                                                  setState(() {
                                                    double rotationAngleDelta =
                                                        details.delta.dx /
                                                            (_containerWidth /
                                                                2);
                                                    double newRotationAngle =
                                                        (_rotationAngle +
                                                                rotationAngleDelta) %
                                                            (2 * pi);
                                                    _rotationAngle =
                                                        newRotationAngle;
                                                    print(_rotationAngle);
                                                    // Update the size and rotation angle
                                                    _draggableSignature.setSize(
                                                        _containerWidth,
                                                        rotationAngle:
                                                            _rotationAngle);
                                                  });
                                                },
                                                child: Image.asset(
                                                  'assets/images/rotate.png',
                                                  height: 100,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isSavingImage = true;
}
