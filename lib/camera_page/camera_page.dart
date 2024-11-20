// import 'dart:io';
//
// import 'package:camera/camera.dart';
// import 'package:cunning_document_scanner/cunning_document_scanner.dart';
// // import 'package:cunning_document_scanner/cunning_document_scanner.dart';
// import 'package:document_scanner_flutter/configs/configs.dart';
// import 'package:document_scanner_flutter/document_scanner_flutter.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:provider/provider.dart';
// import 'package:scanner/camera_page/cunningdocumentscanner.dart';
// import 'package:scanner/camera_page/perview_page.dart';
// import 'package:scanner/management/provider_folder.dart';
// import 'package:scanner/management/provider_image.dart';
// import 'package:scanner/scanned_images_folder/scan_folder.dart';
//
// class CameraPage extends StatefulWidget {
//   const CameraPage({Key? key, required this.cameras}) : super(key: key);
//
//   final List<CameraDescription>? cameras;
//
//   @override
//   State<CameraPage> createState() => _CameraPageState();
// }
//
// class _CameraPageState extends State<CameraPage> {
//   late CameraController _cameraController;
//   bool _isRearCameraSelected = true;
//   late int _currentIndex;
//   ScrollController scrollController = ScrollController();
//   List<String> _pictures = [];
//
//   @override
//   void dispose() {
//     _cameraController.dispose();
//     super.dispose();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     initCamera(widget.cameras![0]);
//   }
//
//   openGalleryScanner(BuildContext context) async {
//     // var image = _cameraController.takePicture();
//     var image = await DocumentScannerFlutter.launch(context,
//         labelsConfig: {
//           ScannerLabelsConfig.ANDROID_NEXT_BUTTON_LABEL: "Next Step",
//           ScannerLabelsConfig.ANDROID_OK_LABEL: "OK"
//         },
//         source: ScannerFileSource.GALLERY);
//
//     if (_scannedImage != null) {
//       // Handle the scanned image if needed
//
//       // Navigate to the home screen and remove the current screen from the stack
//       Navigator.pushReplacement(context,
//           MaterialPageRoute(builder: (context) => ScannedImagesScreen()));
//     } else if (image != null) {
//       _scannedImage = image as File?;
//
//       // Prompt the user to choose an item
//       DataProvider dataProvider =
//           Provider.of<DataProvider>(context, listen: false);
//
//       // Get the list of items from dataProvider
//       List<String> items = dataProvider.items;
//
//       String? chosenItem = await showDialog<String>(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Choose an Item'),
//                 IconButton(
//                   icon: Icon(Icons.add),
//                   onPressed: () {
//                     showDialog(
//                       context: context,
//                       builder: (context) {
//                         return AlertDialog(
//                           title: Text('Add Name'),
//                           content: TextField(
//                             controller: _nameController,
//                             decoration: InputDecoration(labelText: 'Name'),
//                           ),
//                           actions: [
//                             TextButton(
//                               child: Text('Cancel'),
//                               onPressed: () {
//                                 Navigator.of(context).pop();
//                               },
//                             ),
//                             TextButton(
//                               child: Text('Add'),
//                               onPressed: () async {
//                                 String name = _nameController.text;
//                                 DataProvider dataProvider =
//                                     Provider.of<DataProvider>(context,
//                                         listen: false);
//                                 dataProvider.addItem(name);
//                                 _nameController.clear();
//                                 Navigator.of(context).pop();
//                               },
//                             ),
//                           ],
//                         );
//                       },
//                     );
//                   },
//                 ),
//               ],
//             ),
//             content: SingleChildScrollView(child: Consumer<DataProvider>(
//               builder: (context, dataProvider, child) {
//                 // Your Column widget here, using data from dataProvider.items
//                 return Column(
//                   children: dataProvider.items.map((item) {
//                     return ListTile(
//                       title: Text(item),
//                       onTap: () {
//                         Navigator.of(context).pop(item);
//                       },
//                     );
//                   }).toList(),
//                 );
//               },
//             )),
//           );
//         },
//       );
//
//       if (chosenItem != null && chosenItem.isNotEmpty) {
//         // Add the scanned image to the ImageListProvider
//         final imageProvider =
//             Provider.of<ImageListProvider>(context, listen: false);
//         imageProvider.addImage(_scannedImage!, chosenItem);
//
//         // No need to add the chosen item as it already exists in DataProvider
//         // You can use the chosenItem to associate the image with this item if needed
//
//         setState(() {});
//       }
//     }
//   }
//
//   Widget handleSingleFilter() {
//     if (_cameraController.value.isInitialized) {
//       // Use FutureBuilder to handle asynchronous data retrieval
//       FutureBuilder<List<String>?>(
//         future: CunningDocumentScanner.getPictures(
//           true,
//         ),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             // Display a loading indicator while waiting for data
//             return Container(
//               color: Colors.black,
//               child: const Center(child: CircularProgressIndicator()),
//             );
//           } else if (snapshot.hasError) {
//             // Handle error case
//             return Container(
//               color: Colors.red,
//               child: Center(child: Text('Error: ${snapshot.error}')),
//             );
//           } else if (snapshot.hasData) {
//             // Process the pictures data
//             List<String>? pictures = snapshot.data;
//             // Here, you can handle the pictures data or update the UI accordingly
//             // For example, displaying the images using the returned data
//             return Text('Display images here');
//           } else {
//             // Handle other cases if needed
//             return Container(
//               color: Colors.grey,
//               child: const Center(child: Text('No data')),
//             );
//           }
//         },
//       );
//     } else {
//       // If the camera is not initialized, display a loading indicator
//     }
//     return Container();
//   }
//
//   int selectedFilterIndex = 0; // Default to the first filter
//
// // Function to apply the selected filter (implement this according to your requirements)
//   void applyFilter(String filterName) {
//     // Implement the logic to apply the filter
//     // This function will modify the camera preview according to the selected filter
//     // For example:
//     // cameraController.applyFilter(filterName);
//   }
//   Future<void> takePicture2() async {
//     if (!_cameraController.value.isInitialized) {
//       return null;
//     }
//     if (_cameraController.value.isTakingPicture) {
//       return null;
//     }
//     try {
//       // Configure camera settings for capturing ID card-sized image
//
//       XFile picture = await _cameraController.takePicture();
//
//       // Reset camera settings to default or previous state
//
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => PreviewPage(
//             picture: picture,
//           ),
//         ),
//       );
//     } on CameraException catch (e) {
//       debugPrint('Error occurred while taking a picture: $e');
//       return null;
//     }
//   }
//
//   Future takePicture() async {
//     if (!_cameraController.value.isInitialized) {
//       return null;
//     }
//     if (_cameraController.value.isTakingPicture) {
//       return null;
//     }
//     try {
//       await _cameraController.setFlashMode(FlashMode.off);
//       XFile picture = await _cameraController.takePicture();
//       // Navigator.push(
//       //     context,
//       //     MaterialPageRoute(
//       //         builder: (context) => PreviewPage(
//       //               picture: picture,
//       //             )));
//     } on CameraException catch (e) {
//       debugPrint('Error occured while taking picture: $e');
//       return null;
//     }
//   }
//
//   Future initCamera(CameraDescription cameraDescription) async {
//     _cameraController =
//         CameraController(cameraDescription, ResolutionPreset.high);
//     try {
//       await _cameraController.initialize().then((_) {
//         if (!mounted) return;
//         setState(() {});
//       });
//     } on CameraException catch (e) {
//       debugPrint("camera error $e");
//     }
//   }
//
//   List<String> filters = [
//     'Batch',
//     'Single',
//     'ID Card',
//     'To Text',
//     'ID Photo Maker',
//     'To Excel',
//     'PPT',
//   ];
//
//   Widget getCameraPreview() {
//     if (_cameraController.value.isInitialized) {
//       switch (filters[selectedFilterIndex]) {
//         case 'Batch':
//           return _cameraController.value.isInitialized
//               ? CameraPreview(_cameraController)
//               : Container(
//                   color: Colors.black,
//                   child: const Center(child: CircularProgressIndicator()),
//                 );
//         case 'Single':
//           return handleSingleFilter();
//
//         case 'ID Card':
//           return _cameraController.value.isInitialized
//               ? CameraPreview(_cameraController)
//               : Container(
//                   color: Colors.black,
//                   child: const Center(child: CircularProgressIndicator()),
//                 );
//         case 'To Text':
//           return _cameraController.value.isInitialized
//               ? CameraPreview(_cameraController)
//               : Container(
//                   color: Colors.black,
//                   child: const Center(child: CircularProgressIndicator()),
//                 );
//         case 'ID Photo Maker':
//           return _cameraController.value.isInitialized
//               ? CameraPreview(_cameraController)
//               : Container(
//                   color: Colors.black,
//                   child: const Center(child: CircularProgressIndicator()),
//                 );
//         case 'To Excel':
//           return _cameraController.value.isInitialized
//               ? CameraPreview(_cameraController)
//               : Container(
//                   color: Colors.black,
//                   child: const Center(child: CircularProgressIndicator()),
//                 );
//         case 'PPT':
//           return _cameraController.value.isInitialized
//               ? CameraPreview(_cameraController)
//               : Container(
//                   color: Colors.black,
//                   child: const Center(child: CircularProgressIndicator()),
//                 );
//         default:
//           return Container(); // Default case or placeholder
//       }
//     } else {
//       return Container(
//         color: Colors.black,
//         child: const Center(child: CircularProgressIndicator()),
//       );
//     }
//   }
//
// // Define a variable to keep track of the currently selected filter
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Stack(
//           children: [
//             Expanded(
//               child: getCameraPreview(),
//             ),
//             Align(
//               alignment: Alignment.topLeft, // Adjust alignment as needed
//               child: Container(
//                 padding: EdgeInsets.all(5),
//                 height: MediaQuery.of(context).size.height * 0.08,
//                 decoration: const BoxDecoration(
//                   color: Colors.black,
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     InkWell(
//                         onTap: () {
//                           Navigator.of(context).pop();
//                         },
//                         child: Icon(Icons.arrow_back, color: Colors.white)),
//                     Icon(Icons.flash_auto, color: Colors.white),
//                   ],
//                 ), // Change the icon as needed
//               ),
//             ),
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Container(
//                 height: MediaQuery.of(context).size.height * 0.20,
//                 decoration: const BoxDecoration(
//                   borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//                   color: Colors.black,
//                 ),
//                 child: Column(
//                   children: [
//                     SizedBox(
//                       height: 20,
//                     ),
//                     Container(
//                       height: 20, // Adjust the height as needed
//                       child: ListView.builder(
//                         controller: scrollController,
//                         scrollDirection: Axis.horizontal,
//                         itemCount: filters.length,
//                         itemBuilder: (context, index) {
//                           return GestureDetector(
//                             onTap: () {
//                               setState(() {
//                                 selectedFilterIndex = index;
//                                 applyFilter(filters[selectedFilterIndex]);
//                               });
//
//                               // Calculate the scroll position based on the selected index
//                               double scrollPosition =
//                                   (index * 100.0); // Adjust 100 as needed
//
//                               // Scroll to the selected filter
//                               scrollController.animateTo(
//                                 scrollPosition,
//                                 duration: Duration(milliseconds: 500),
//                                 curve: Curves.easeInOut,
//                               );
//                             },
//                             child: Container(
//                               padding: EdgeInsets.symmetric(horizontal: 16),
//                               alignment: Alignment.center,
//                               decoration: BoxDecoration(
//                                 color: selectedFilterIndex == index
//                                     ? Colors
//                                         .grey // Change the selected filter background color
//                                     : Colors.transparent,
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Text(
//                                 filters[index],
//                                 style: TextStyle(
//                                   color: selectedFilterIndex == index
//                                       ? Colors
//                                           .white // Change the selected filter text color
//                                       : Colors
//                                           .grey, // Change the unselected filter text color
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Expanded(
//                           child: IconButton(
//                             padding: EdgeInsets.zero,
//                             iconSize: 30,
//                             icon:
//                                 Icon(CupertinoIcons.grid, color: Colors.white),
//                             onPressed: () {
//                               setState(() {
//                                 selectedFilterIndex =
//                                     (selectedFilterIndex + 1) % filters.length;
//                                 applyFilter(filters[selectedFilterIndex]);
//                               });
//                             },
//                           ),
//                         ),
//                         Expanded(
//                           child: IconButton(
//                             onPressed: () async {
//                               // Get the selected filter
//                               String selectedFilter =
//                                   filters[selectedFilterIndex];
//
//                               // Call the function based on the selected filter
//                               switch (selectedFilter) {
//                                 case 'Batch':
//                                   // Call the function related to 'Batch'
//                                   // functionNameForBatch();
//                                   break;
//                                 case 'Single':
//                                   // Call the function related to 'Single'
//                                   // functionNameForSingle();
//                                   break;
//                                 case 'ID Card':
//                                   // Call the function related to 'ID Card'
//                                   // functionNameForIDCard();
//                                   break;
//                                 // Add cases for other filters as needed
//                                 default:
//                                   // Handle default case
//                                   break;
//                               }
//                             },
//                             iconSize: 50,
//                             padding: EdgeInsets.zero,
//                             constraints: const BoxConstraints(),
//                             icon: const Icon(Icons.circle, color: Colors.white),
//                           ),
//                         ),
//                         Expanded(
//                           child: IconButton(
//                             onPressed: () {
//                               openGalleryScanner(context);
//                             },
//                             iconSize: 30,
//                             padding: EdgeInsets.zero,
//                             constraints: const BoxConstraints(),
//                             icon: const Icon(Icons.image, color: Colors.white),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   final TextEditingController _nameController = TextEditingController();
//   File? _scannedImage;
//   var exceldata = '';
//   File? _file;
// }
