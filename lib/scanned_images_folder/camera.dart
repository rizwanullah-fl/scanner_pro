import 'dart:io';

import 'package:advance_pdf_viewer2/advance_pdf_viewer.dart';
import 'package:document_scanner_flutter/configs/configs.dart';
import 'package:document_scanner_flutter/document_scanner_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scanner/bottomNavigation.dart';
import 'package:scanner/management/provider_folder.dart';
import 'package:scanner/management/provider_image.dart';
import 'package:scanner/scanned_images_folder/scan_folder.dart';

class Camera extends StatefulWidget {
  const Camera({super.key});

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  PDFDocument? _scannedDocument;
  File? _scannedDocumentFile;
  File? _scannedImage;
  @override
  void initState() {
    super.initState();
    openImageScanner(context);
  } // Flag to track whether the camera is open or not

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
            title: Text('Choose an Item'),
            content: SingleChildScrollView(
              child: Column(
                children: items.map((item) {
                  return ListTile(
                    title: Text(item),
                    onTap: () {
                      Navigator.of(context).pop(item);
                    },
                  );
                }).toList(),
              ),
            ),
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

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
