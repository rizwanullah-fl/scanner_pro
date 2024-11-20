import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class ImageToExcelConverter {
  Future<void> convertImageToExcel(File imageFile) async {
    // Get the bytes of the image file
    Uint8List imageBytes = await imageFile.readAsBytes();

    // Create a new Excel workbook
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];

    // Convert image bytes to an Image
    final ui.Image image =
        await decodeImageFromList(Uint8List.fromList(imageBytes));

    // Get the width and height of the image
    double imageWidth = image.width.toDouble();
    double imageHeight = image.height.toDouble();

    // Add the image to the Excel worksheet

    // Save the workbook
    List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    // Get the documents directory
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    // Save the Excel file to the documents directory
    final String excelFileName = 'file_with_image.xlsx';
    final String excelFilePath = '${documentsDirectory.path}/$excelFileName';
    await File(excelFilePath).writeAsBytes(bytes);

    print('Image saved to Excel successfully. Path: $excelFilePath');
  }
}

class ExcelDisplayScreen extends StatelessWidget {
  final File excelFile;

  ExcelDisplayScreen(this.excelFile);
  Future<void> saveImageToExcel() async {
    // Get the bytes of the image file
    Uint8List imageBytes = await excelFile.readAsBytes();

    // Create a new Excel workbook
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];

    // Add the image to the Excel worksheet
    // sheet.pictures
    //     .addPicture(base64.decode(base64Encode(imageBytes)), 1, 1, 300, 300);

    // Save the workbook
    List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    // Save the Excel file
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    // Save the Excel file to the documents directory
    final String excelFileName = 'file_with_image.xlsx';
    final String excelFilePath = '${documentsDirectory.path}/$excelFileName';
    await File(excelFilePath).writeAsBytes(bytes);
    print(excelFilePath);

    print('Image saved to Excel successfully.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Excel Display'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: saveImageToExcel,
          ),
        ],
      ),
      body: Center(
        child: Image.file(excelFile),
      ),
    );
  }
}
