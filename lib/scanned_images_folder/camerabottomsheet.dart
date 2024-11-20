import 'dart:io';

import 'package:document_scanner_flutter/configs/configs.dart';
import 'package:document_scanner_flutter/document_scanner_flutter.dart';
import 'package:flutter/material.dart';
import 'package:multiple_image_camera/camera_file.dart';
import 'package:multiple_image_camera/multiple_image_camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:scanner/management/provider_folder.dart';
import 'package:scanner/management/provider_image.dart';
import 'package:scanner/scanned_images_folder/qr_scan.dart';
import 'package:scanner/scanned_images_folder/scan_folder.dart';
import 'package:path/path.dart' as path;

class CameraBottomSheet extends StatefulWidget {
  const CameraBottomSheet({super.key});

  @override
  State<CameraBottomSheet> createState() => _CameraBottomSheetState();
}

class _CameraBottomSheetState extends State<CameraBottomSheet> {
  File? _scannedImage;
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        initialChildSize: 0.4,
        maxChildSize: 0.4,
        minChildSize: 0.3,
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
                        openImageScanner(context);
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.scanner_sharp,
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            padding:
                                EdgeInsets.all(0), // Set the padding to zero
                            child: Text('Scanner Camera'),
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            openGalleryScanner(context);
                          },
                          child: Container(
                            height: 40,
                            child: Icon(
                              Icons.photo_album_sharp,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          padding: EdgeInsets.all(0), // Set the padding to zero
                          child: Text('Gallery'),
                        ),
                      ],
                    ),
                    Divider(),
                    Row(
                      children: [
                        InkWell(
                          onTap: () async {
                            // Inside your code where images are being captured and saved
                            List<MediaModel> capturedImages = [];
                            ImageListProvider imageProvider =
                                ImageListProvider();
                            String itemName =
                                "YourBatchName"; // Replace with your batch name

// ... (inside your function where you're capturing images)
                            MultipleImageCamera.capture(context: context)
                                .then((capturedImages) {
                              if (capturedImages != null &&
                                  capturedImages.isNotEmpty) {
                                List<File> files = capturedImages
                                    .map((mediaModel) => mediaModel.file)
                                    .toList();
                                for (File image in files) {
                                  imageProvider.addImage(image, itemName);
                                }
                              }
                            });
                            print(capturedImages);
                          },
                          child: Container(
                            height: 40,
                            child: Icon(
                              Icons.batch_prediction,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          padding: EdgeInsets.all(0), // Set the padding to zero
                          child: Text('Batch Images'),
                        ),
                      ],
                    ),
                    Divider(),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        openImageScanner(context);
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.card_giftcard,
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            padding:
                                EdgeInsets.all(0), // Set the padding to zero
                            child: Text('Id Card'),
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => QrScan()));
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.card_giftcard,
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            padding:
                                EdgeInsets.all(0), // Set the padding to zero
                            child: Text('Qr Scanner'),
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

  List<MediaModel> images = [];
  final TextEditingController _nameController = TextEditingController();

  openImageScanner(BuildContext context) async {
    var image = await DocumentScannerFlutter.launch(
      context,
      labelsConfig: {
        ScannerLabelsConfig.ANDROID_NEXT_BUTTON_LABEL: "Next Step",
        ScannerLabelsConfig.ANDROID_OK_LABEL: "OK"
      },
      source: ScannerFileSource.CAMERA,
    );

    if (_scannedImage != null) {
      // Handle the scanned image if needed

      // Navigate to the home screen and remove the current screen from the stack
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => ScannedImagesScreen()));
    } else if (image != null) {
      _scannedImage = image;

      // Prompt the user to choose an item
      DataProvider dataProvider =
          Provider.of<DataProvider>(context, listen: false);

      // Get the list of items from dataProvider
      List<String> items = dataProvider.items;

      String? chosenItem = await showDialog<String>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Choose an Item'),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Add Name'),
                          content: TextField(
                            controller: _nameController,
                            decoration: InputDecoration(labelText: 'Name'),
                          ),
                          actions: [
                            TextButton(
                              child: Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text('Add'),
                              onPressed: () async {
                                String name = _nameController.text;
                                DataProvider dataProvider =
                                    Provider.of<DataProvider>(context,
                                        listen: false);
                                dataProvider.addItem(name);
                                _nameController.clear();
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            content: SingleChildScrollView(child: Consumer<DataProvider>(
              builder: (context, dataProvider, child) {
                // Your Column widget here, using data from dataProvider.items
                return Column(
                  children: dataProvider.items.map((item) {
                    return ListTile(
                      title: Text(item),
                      onTap: () {
                        Navigator.of(context).pop(item);
                      },
                    );
                  }).toList(),
                );
              },
            )),
          );
        },
      );

      if (chosenItem != null && chosenItem.isNotEmpty) {
        // Add the scanned image to the ImageListProvider
        final imageProvider =
            Provider.of<ImageListProvider>(context, listen: false);
        imageProvider.addImage(_scannedImage!, chosenItem);

        // No need to add the chosen item as it already exists in DataProvider
        // You can use the chosenItem to associate the image with this item if needed

        setState(() {});
      }
    }
  }

  openGalleryScanner(BuildContext context) async {
    var image = await DocumentScannerFlutter.launch(
      context,
      labelsConfig: {
        ScannerLabelsConfig.ANDROID_NEXT_BUTTON_LABEL: "Next Step",
        ScannerLabelsConfig.ANDROID_OK_LABEL: "OK"
      },
      source: ScannerFileSource.CAMERA,
    );

    if (_scannedImage != null) {
      // Handle the scanned image if needed

      // Navigate to the home screen and remove the current screen from the stack
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => ScannedImagesScreen()));
    } else if (image != null) {
      _scannedImage = image;

      // Prompt the user to choose an item
      DataProvider dataProvider =
          Provider.of<DataProvider>(context, listen: false);

      // Get the list of items from dataProvider
      List<String> items = dataProvider.items;

      String? chosenItem = await showDialog<String>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Choose an Item'),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Add Name'),
                          content: TextField(
                            controller: _nameController,
                            decoration: InputDecoration(labelText: 'Name'),
                          ),
                          actions: [
                            TextButton(
                              child: Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text('Add'),
                              onPressed: () async {
                                String name = _nameController.text;
                                DataProvider dataProvider =
                                    Provider.of<DataProvider>(context,
                                        listen: false);
                                dataProvider.addItem(name);
                                _nameController.clear();
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            content: SingleChildScrollView(child: Consumer<DataProvider>(
              builder: (context, dataProvider, child) {
                // Your Column widget here, using data from dataProvider.items
                return Column(
                  children: dataProvider.items.map((item) {
                    return ListTile(
                      title: Text(item),
                      onTap: () {
                        Navigator.of(context).pop(item);
                      },
                    );
                  }).toList(),
                );
              },
            )),
          );
        },
      );

      if (chosenItem != null && chosenItem.isNotEmpty) {
        // Add the scanned image to the ImageListProvider
        final imageProvider =
            Provider.of<ImageListProvider>(context, listen: false);
        imageProvider.addImage(_scannedImage!, chosenItem);

        // No need to add the chosen item as it already exists in DataProvider
        // You can use the chosenItem to associate the image with this item if needed

        setState(() {});
      }
    }
  }
}
