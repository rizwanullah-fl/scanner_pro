import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
// import 'package:aspose_words_cloud/aspose_words_cloud.dart';
import 'package:document_file_save_plus/document_file_save_plus.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scanner/extra/indicator.dart';

class AsposeWordsCloudService {
  bool isLoading = false;
  Future<void> uploadDocument(String selectedFilePath, BuildContext context,String name) async {

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://api.pspdfkit.com/build'),
    );

    // Add form fields
    request.fields['instructions'] = jsonEncode({
      'parts': [
        {'file': 'document'}
      ]
    });

    // Add file
    request.files.add(await http.MultipartFile.fromPath(
      'document',
      selectedFilePath,
    ));

    // Set authorization header
    request.headers['Authorization'] =
    'Bearer pdf_live_NoKyZ0IV7mv1VoLfEE0BYOJWpMk1agnhV4PPVqDUmZa';
    MyProgressDialog.show(context);
    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
print(response.statusCode);
      print(response.bodyBytes);
      if (response.statusCode == 200) {
        Navigator.pop(context);
        Uint8List bytes = response.bodyBytes;
        isLoading = true;

        await saveFile(name,bytes: bytes,context );

      } else {
        print('Failed to convert document. Status code: ${response.statusCode}');
        print(response.body);
        // Handle error response here
      }
    } catch (e) {
      print('Error: $e');
      // Handle other errors here
    }
  }

  Future<void> saveFile(
      String name,
      BuildContext context,
      {required Uint8List bytes,}) async {
    try {
      isLoading == true ? CircularProgressIndicator() : null;
      DocumentFileSavePlus()
          .saveFile(
          bytes,
          '${DateTime.now()}.${'my_sample_file.${name}'}',
          "appliation/${name}"
      )
          .then((value) {
            isLoading = false;
            showSnackBar(context, 'File saved successfully ${name}',);
        print('File has been saved successfully');
      });
    } catch (e) {
      debugPrint("$e");
    }
  }
  void showSnackBar(BuildContext context, String message,) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2), // Adjust the duration as needed
      ),
    );
  }
//   Future savefile(String file , String name , String name2) async {
//     var configuration = Configuration('6f307100-9da1-42d6-8ba1-193cfeb095e5','d5ed4270aac7d3285b255e0b41f957da');
//     var wordsApi = WordsApi(configuration);
//     var localFileContent = await  (File(file).readAsBytes());
// print(localFileContent);
//     var uploadRequest = UploadFileRequest(ByteData.view(localFileContent.buffer), 'fileStoredInCloud.$name');
//     await wordsApi.uploadFile(uploadRequest);
//
// // Save file as pdf in cloud
//     var saveOptionsData = PdfSaveOptionsData()
//       ..fileName = 'destStoredInCloud.$name2';
//     var saveAsRequest = SaveAsRequest('fileStoredInCloud.$name', saveOptionsData);
//     await wordsApi.saveAs(saveAsRequest);
//     print(saveAsRequest);
//     print(wordsApi.saveAs(saveAsRequest));
//   }
}
