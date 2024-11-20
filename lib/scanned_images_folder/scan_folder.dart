import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:document_scanner_flutter/configs/configs.dart';
import 'package:document_scanner_flutter/document_scanner_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multiple_image_camera/camera_file.dart';
import 'package:multiple_image_camera/multiple_image_camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:scanner/camera_page/camera_page.dart';
import 'package:scanner/management/controller/google_signin.dart';
import 'package:scanner/management/provider_folder.dart';
import 'package:scanner/management/provider_image.dart';
import 'package:scanner/management/selectionmode.dart';
import 'package:scanner/scanned_images_folder/ExtractText.dart';
import 'package:scanner/scanned_images_folder/Maincolor.dart';
import 'package:scanner/scanned_images_folder/addImagetoexcel.dart';
import 'package:scanner/scanned_images_folder/batchImages.dart';
import 'package:scanner/scanned_images_folder/camerabottomsheet.dart';
import 'package:scanner/scanned_images_folder/image_Screen.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:scanner/scanned_images_folder/qr_scan.dart';
import 'package:scanner/scanned_images_folder/setting/setting.dart';

import '../management/Convet_Images.dart';
// import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class ScannedImagesScreen extends StatefulWidget {
  @override
  State<ScannedImagesScreen> createState() => _ScannedImagesScreenState();
}

class _ScannedImagesScreenState extends State<ScannedImagesScreen> {
  final TextEditingController _nameController = TextEditingController();
  File? _scannedImage;
  var exceldata = '';
  bool isloading = false;
  File? _file;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> pickFil2(String name) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );

    if (result != null) {
      final firstImagePath = result.files.single.path;
      // Convert the image path to a File
      File _scannedImage = File(firstImagePath!);

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
                Text('choose folder'),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Create a Folder'),
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

  openImageScanner(BuildContext context) async {
    setState(() {
      isloading = true;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(), // Or any other loading widget
          );
        },
      );
    });
    List<String>? imagePaths = await CunningDocumentScanner.getPictures();
    setState(() {
      isloading = false;
      Navigator.pop(context);
    });
    if (_scannedImage != null) {
      // Handle the scanned image if needed

      // Navigate to the home screen and remove the current screen from the stack
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => ScannedImagesScreen()));
    } else if (imagePaths != null) {
      String firstImagePath = imagePaths!.first;

      // Convert the image path to a File
      File _scannedImage = File(firstImagePath);

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
                Text('choose folder'),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Create a Folder'),
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
        imageProvider.addImage(_scannedImage, chosenItem);

        // No need to add the chosen item as it already exists in DataProvider
        // You can use the chosenItem to associate the image with this item if needed

        setState(() {});
      }
    }
  }

  final ImageToExcelConverter imageToExcelConverter = ImageToExcelConverter();

  Future<void> _openCameraAndConvertToExcel() async {
    var image = await DocumentScannerFlutter.launch(
      context,
      labelsConfig: {
        ScannerLabelsConfig.ANDROID_NEXT_BUTTON_LABEL: "Next Step",
        ScannerLabelsConfig.ANDROID_OK_LABEL: "OK"
      },
      source: ScannerFileSource.GALLERY,
    );
    var exceldata = await imageToExcelConverter
        .convertImageToExcel(File(_scannedImage!.path));
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
                Text('choose folder'),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Create a Folder'),
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

  openImageScanner2(BuildContext context) async {
    var image = await DocumentScannerFlutter.launch(
      context,
      labelsConfig: {
        ScannerLabelsConfig.ANDROID_NEXT_BUTTON_LABEL: "Next Step",
        ScannerLabelsConfig.ANDROID_OK_LABEL: "OK"
      },
      source: ScannerFileSource.GALLERY,
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
                Text('choose folder'),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Create a Folder'),
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

  void sort_items() {
    DataProvider dataProvider =
        Provider.of<DataProvider>(context, listen: false);
    List<String> items = dataProvider.items;
    items.sort();
    dataProvider.items = items;
    setState(() {});
  }

  User? _currentUser;
  String? _userEmail;
  String? _userName;
  String? _userPhotoUrl;

  @override
  void initState() {
    super.initState();
    // _getCurrentUser();
  }

  // GoogleSignInController googleSignInController = GoogleSignInController();

  // Future<void> _getCurrentUser() async {
  //   _userEmail = await googleSignInController.getUserEmail();
  //   _userName = await googleSignInController.getUserName();
  //   _userPhotoUrl = await googleSignInController.getUserPhotoUrl();
  //   setState(() {
  //     print(_userPhotoUrl);
  //     _currentUser = User(
  //         email: _userEmail.toString(),
  //         displayName: _userName.toString(),
  //         photoUrl: _userPhotoUrl.toString());
  //   });
  // }

  String selectedView = 'ListView'; // Default selected view

  bool isSearchOpen = false; // Flag to track if search field is open

  TextEditingController _searchController = TextEditingController();

  List<int> _selectedIndices = []; // Track selected indices
  String searchQuery = ''; // Variable to hold the search query

  @override
  Widget build(BuildContext context) {
    print('fvfvfv$_userPhotoUrl');
    final imageProvider =
        Provider.of<ImageListProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: AppColors.FourthColor,
      appBar: AppBar(
        // leading: IconButton(
        //   onPressed: () {
        //     Navigator.push(
        //       context,
        //       PageRouteBuilder(
        //         pageBuilder: (context, animation, secondaryAnimation) =>
        //             Setting(),
        //         transitionsBuilder:
        //             (context, animation, secondaryAnimation, child) {
        //           const begin = Offset(1.0, 0.0);
        //           const end = Offset.zero;
        //           const curve = Curves.easeInOut;

        //           var tween = Tween(begin: begin, end: end)
        //               .chain(CurveTween(curve: curve));

        //           var offsetAnimation = animation.drive(tween);

        //           return SlideTransition(
        //               position: offsetAnimation, child: child);
        //         },
        //       ),
        //     );
        //   },
        //   icon: Icon(Icons.settings),
        // ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: AppColors.primaryColor,
        title: Text(
          'Doc Scanner - AI',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      Setting(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    const begin = Offset(1.0, 0.0);
                    const end = Offset.zero;
                    const curve = Curves.easeInOut;

                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));

                    var offsetAnimation = animation.drive(tween);

                    return SlideTransition(
                        position: offsetAnimation, child: child);
                  },
                ),
              );
            },
            icon: Icon(Icons.settings),
          ),
          PopupMenuButton<int>(
            icon: Icon(Icons.more_vert, color: Colors.white),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Create Folder'),
                    Icon(
                      Icons.folder_copy,
                      color: Color(0xff192A36),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Import Files'),
                    Icon(
                      Icons.import_export_sharp,
                      color: Color(0xff192A36),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Image to pdf'),
                    Icon(
                      Icons.image,
                      color: Color(0xff192A36),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('pdf to word'),
                    Icon(
                      Icons.wordpress,
                      color: Color(0xff192A36),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('word to pdf'),
                    Icon(
                      Icons.picture_as_pdf,
                      color: Color(0xff192A36),
                    ),
                  ],
                ),
              ),
              // Add more PopupMenuItems as needed
            ],
            onSelected: (value) {
              // Handle the selection here
              switch (value) {
                case 1:
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Create a Folder'),
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
                  break;
                case 2:
                  pickFil2('pdf');
                  // Handle Option 2
                  break;
                case 3:
                  pickFile('pdf');
                  // Handle Option 3
                  break;
                case 4:
                  pickFile('docx');
                  break;
                case 5:
                  pickFile('pdf');
                  break;
                // Add cases for other options
              }
            },
          )
        ],
      ),
      // drawer: _currentUser != null
      //     ? Drawer(
      //         child: ListView(
      //           padding: EdgeInsets.zero,
      //           children: <Widget>[
      //             UserAccountsDrawerHeader(
      //               accountName: Text(_currentUser?.email ??
      //                   ''), // Replace with actual user name
      //               accountEmail: null, // Add user email if available
      //               currentAccountPicture: CircleAvatar(
      //                 child: _userPhotoUrl != null
      //                     ? CircleAvatar(
      //                         backgroundImage:
      //                             NetworkImage(_userPhotoUrl.toString()),
      //                       )
      //                     : CircleAvatar(
      //                         child: Icon(Icons.person),
      //                       ),
      //               ), // Replace with actual profile picture
      //             ),
      //             ListTile(
      //               title: Text(_currentUser?.displayName ?? ''),
      //               onTap: () {
      //                 print(_currentUser?.photoUrl);
      //                 // Handle item 1 tap
      //               },
      //             ),
      //             Divider(),
      //             ListTile(
      //               title: Text('Sign out'),
      //               onTap: () async {
      //                 await googleSignInController.signOut();
      //                 setState(() {
      //                   _currentUser = null;
      //                 });
      //                 Navigator.pop(context); // Close the drawer
      //               },
      //             ),
      //           ],
      //         ),
      //       )
      //     : Drawer(
      //         child: ListView(
      //           padding: EdgeInsets.zero,
      //           children: <Widget>[
      //             UserAccountsDrawerHeader(
      //               accountName: Text(_currentUser?.email ??
      //                   'login'), // Replace with actual user name
      //               accountEmail: null, // Add user email if available
      //               // currentAccountPicture: CircleAvatar(
      //               //     child: Image.network(UserController.user?.photoURL ??
      //               //         '')), // Replace with actual profile picture
      //             ),
      //             ListTile(
      //               title: Text(_currentUser?.displayName ?? ''),
      //               onTap: () {
      //                 // Handle item 1 tap
      //               },
      //             ),
      //             Divider(),
      //             ListTile(
      //               title: Text('Login in'),
      //               onTap: () {
      //                 // setState(() async {
      //                 //   await UserController.signout();
      //                 // });
      //                 // Navigator.pop(context);
      //               },
      //             ),
      //           ],
      //         ),
      //       ),
      body: Column(
        children: [
          // Container(
          //   height: 120,
          //   color: Colors.transparent,
          //   margin: EdgeInsets.only(left: 10, right: 10, top: 20),
          //   child: Stack(
          //     children: [
          //       Column(
          //         children: [
          //           Row(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               InkWell(
          //                 onTap: () {
          //                   openImageScanner(context);
          //                 },
          //                 child: Container(
          //                   height: 40,
          //                   width: 150,
          //                   padding: EdgeInsets.only(left: 10),
          //                   decoration: BoxDecoration(
          //                     color: Color(0xff0DA292F),
          //                     borderRadius: BorderRadius.only(
          //                       bottomRight: Radius.circular(100),
          //                     ),
          //                     // border: Border.all(color: Colors.black),
          //                   ),
          //                   child: Row(
          //                     mainAxisAlignment: MainAxisAlignment.start,
          //                     crossAxisAlignment: CrossAxisAlignment.center,
          //                     children: [
          //                       Icon(
          //                         Icons.scanner_outlined,
          //                         color: Colors.white,
          //                       ),
          //                       SizedBox(width: 8),
          //                       Text(
          //                         'Scanner',
          //                         style: TextStyle(color: Colors.white),
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //               ),
          //               SizedBox(
          //                 width: 30,
          //               ),
          //               InkWell(
          //                 onTap: () {
          //                   Navigator.push(
          //                       context,
          //                       MaterialPageRoute(
          //                           builder: (context) => QrScan()));
          //                 },
          //                 child: Container(
          //                   height: 40,
          //                   width: 150,
          //                   padding: EdgeInsets.only(left: 20),
          //                   decoration: BoxDecoration(
          //                     color: Color(0xff04190ED),
          //                     borderRadius: BorderRadius.only(
          //                       bottomLeft: Radius.circular(100),
          //                     ),
          //                     // border: Border.all(color: Colors.black),
          //                   ),
          //                   child: Row(
          //                     mainAxisAlignment: MainAxisAlignment.start,
          //                     crossAxisAlignment: CrossAxisAlignment.center,
          //                     children: [
          //                       Icon(Icons.qr_code_scanner_sharp,
          //                           color: Colors.white),
          //                       SizedBox(width: 8),
          //                       Text(
          //                         'Qr Scanner',
          //                         style: TextStyle(color: Colors.white),
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //               )
          //             ],
          //           ),
          //           SizedBox(
          //             height: 10,
          //           ),
          //           Row(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               InkWell(
          //                 onTap: () async {
          //                   String? chosenItem;
          //                   // Inside your code where images are being captured and saved
          //                   List<MediaModel> capturedImages = [];
          //                   ImageListProvider imageProvider =
          //                       Provider.of<ImageListProvider>(context,
          //                           listen: false);
          //                   int currentFilesLength = 0;
          //                   MultipleImageCamera.capture(context: context)
          //                       .then((capturedImages) async {
          //                     if (capturedImages != null &&
          //                         capturedImages.isNotEmpty) {
          //                       List<File> files = capturedImages
          //                           .map((mediaModel) => mediaModel.file)
          //                           .toList();
          //                       currentFilesLength = files.length;
          //                       for (File image in files) {
          //                         chosenItem = await showDialog<String>(
          //                           context: context,
          //                           builder: (context) {
          //                             return AlertDialog(
          //                               title: Row(
          //                                 mainAxisAlignment:
          //                                     MainAxisAlignment.spaceBetween,
          //                                 children: [
          //                                   Text(
          //                                       'total pics ${currentFilesLength}'),
          //                                   IconButton(
          //                                     icon: Icon(Icons.add),
          //                                     onPressed: () {
          //                                       showDialog(
          //                                         context: context,
          //                                         builder: (context) {
          //                                           return AlertDialog(
          //                                             title: Text('Add Name'),
          //                                             content: TextField(
          //                                               controller:
          //                                                   _nameController,
          //                                               decoration:
          //                                                   InputDecoration(
          //                                                       labelText:
          //                                                           'Name'),
          //                                             ),
          //                                             actions: [
          //                                               TextButton(
          //                                                 child: Text('Cancel'),
          //                                                 onPressed: () {
          //                                                   Navigator.of(
          //                                                           context)
          //                                                       .pop();
          //                                                 },
          //                                               ),
          //                                               TextButton(
          //                                                 child: Text('Add'),
          //                                                 onPressed: () async {
          //                                                   String name =
          //                                                       _nameController
          //                                                           .text;
          //                                                   DataProvider
          //                                                       dataProvider =
          //                                                       Provider.of<
          //                                                               DataProvider>(
          //                                                           context,
          //                                                           listen:
          //                                                               false);
          //                                                   dataProvider
          //                                                       .addItem(name);
          //                                                   _nameController
          //                                                       .clear();
          //                                                   Navigator.of(
          //                                                           context)
          //                                                       .pop();
          //                                                 },
          //                                               ),
          //                                             ],
          //                                           );
          //                                         },
          //                                       );
          //                                     },
          //                                   ),
          //                                 ],
          //                               ),
          //                               content: SingleChildScrollView(
          //                                   child: Consumer<DataProvider>(
          //                                 builder:
          //                                     (context, dataProvider, child) {
          //                                   // Your Column widget here, using data from dataProvider.items
          //                                   return Column(
          //                                     children: dataProvider.items
          //                                         .map((item) {
          //                                       return ListTile(
          //                                         title: Text(item),
          //                                         onTap: () {
          //                                           final snackBar = SnackBar(
          //                                             content: Text(
          //                                                 'Save in this folder $item'), // Your snackbar message
          //                                             duration: Duration(
          //                                                 seconds:
          //                                                     2), // Duration for how long the snackbar is displayed
          //                                           );
          //                                           ScaffoldMessenger.of(
          //                                                   context)
          //                                               .showSnackBar(snackBar);
          //
          //                                           Navigator.of(context)
          //                                               .pop(item);
          //                                         },
          //                                       );
          //                                     }).toList(),
          //                                   );
          //                                 },
          //                               )),
          //                             );
          //                           },
          //                         );
          //                         // final imageProvider =
          //                         //     Provider.of<ImageListProvider>(context,
          //                         //         listen: false);
          //                         // imageProvider.addImage(
          //                         //     _scannedImage!, chosenItem!);
          //                         currentFilesLength = currentFilesLength - 1;
          //                         imageProvider.addImage(image, chosenItem!);
          //                       }
          //                     }
          //                   });
          //                 },
          //                 child: Container(
          //                   height: 40,
          //                   width: 150,
          //                   padding: EdgeInsets.only(left: 10),
          //                   decoration: BoxDecoration(
          //                     color: Color(0xff037D14D),
          //                     borderRadius: BorderRadius.only(
          //                       topRight: Radius.circular(100),
          //                     ),
          //                     // border: Border.all(color: Colors.black),
          //                   ),
          //                   child: Row(
          //                     mainAxisAlignment: MainAxisAlignment.start,
          //                     crossAxisAlignment: CrossAxisAlignment.center,
          //                     children: [
          //                       Icon(Icons.batch_prediction,
          //                           color: Colors.white),
          //                       SizedBox(width: 8),
          //                       Text(
          //                         'Multiple',
          //                         style: TextStyle(color: Colors.white),
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //               ),
          //               SizedBox(
          //                 width: 30,
          //               ),
          //               InkWell(
          //                 onTap: () {
          //                   openImageScanner(context);
          //                 },
          //                 child: Container(
          //                   height: 40,
          //                   width: 150,
          //                   padding: EdgeInsets.only(left: 20),
          //                   decoration: BoxDecoration(
          //                       borderRadius: BorderRadius.only(
          //                         topLeft: Radius.circular(200),
          //                       ),
          //                       // border: Border.all(color: Colors.black),
          //                       color: Color(0xff0F5BC17)),
          //                   child: Row(
          //                     mainAxisAlignment: MainAxisAlignment.start,
          //                     crossAxisAlignment: CrossAxisAlignment.center,
          //                     children: [
          //                       Icon(Icons.card_travel, color: Colors.white),
          //                       SizedBox(width: 8),
          //                       Text(
          //                         'Id card',
          //                         style: TextStyle(color: Colors.white),
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ],
          //       ),
          //       Positioned(
          //         child: Container(
          //           margin: EdgeInsets.only(
          //               left: MediaQuery.of(context).size.width * 0.41,
          //               top: 19), // Circle ka margin set kiya
          //           width: 50, // Circle width
          //           height: 50, // Circle height
          //           child: Center(
          //             child: InkWell(
          //               // onTap: openImageScanner2(context),
          //               child: Icon(
          //                 Icons.camera_alt_sharp,
          //                 color: Colors.white,
          //               ),
          //             ),
          //           ),
          //           decoration: BoxDecoration(
          //             shape: BoxShape.circle,
          //             color: Color(0xff0C10617),
          //             border: Border.all(color: Colors.transparent),
          //           ),
          //         ),
          //       ),
          //       // Row(
          //       //   mainAxisAlignment: MainAxisAlignment.center,
          //       //   crossAxisAlignment: CrossAxisAlignment.center,
          //       //   children: [
          //       //     Column(
          //       //       children: [
          //       //         Icon(Icons.picture_as_pdf),
          //       //         SizedBox(height: 8),
          //       //         Text('PDF Tools'),
          //       //       ],
          //       //     ),
          //       //     SizedBox(width: 20),
          //       //     Column(
          //       //       children: [
          //       //         InkWell(
          //       //           onTap: _openCameraAndConvertToExcel,
          //       //           child: Icon(Icons.file_copy_sharp),
          //       //         ),
          //       //         SizedBox(height: 8),
          //       //         Text('Scan Excel'),
          //       //       ],
          //       //     ),
          //       //     SizedBox(width: 20),
          //
          //       //     // Replace icon2 with the second icon
          //       //     Column(
          //       //       children: [
          //       //         InkWell(
          //       //             onTap: () {
          //       //               openImageScanner(context);
          //       //             },
          //       //             child: Icon(Icons.text_fields)),
          //       //         SizedBox(height: 8),
          //       //         Text('To Text'),
          //       //       ],
          //       //     ),
          //       //     SizedBox(width: 20),
          //
          //       //     // Replace icon3 with the third icon
          //       //     Column(
          //       //       children: [
          //       //         InkWell(
          //       //           onTap: () {
          //       //             Navigator.push(
          //       //                 context,
          //       //                 MaterialPageRoute(
          //       //                     builder: (context) => QrScan()));
          //       //           },
          //       //           child: Icon(Icons.adf_scanner_sharp),
          //       //         ),
          //       //         SizedBox(height: 8),
          //       //         Text('Scan'),
          //       //       ],
          //       //     ),
          //       //   ],
          //       // ),
          //       // SizedBox(height: 30),
          //       // Row(
          //       //   mainAxisAlignment: MainAxisAlignment.center,
          //       //   crossAxisAlignment: CrossAxisAlignment.center,
          //       //   children: [
          //       //     Column(
          //       //       children: [
          //       //         InkWell(
          //       //             onTap: () {
          //       //               openImageScanner(context);
          //       //             },InkWell(
          //       //             onTap: () {
          //       //               openImageScanner(context);
          //       //             },
          //       //             child: Icon(Icons.photo_album)),
          //       //         SizedBox(height: 8),
          //       //         Text('Id photo maker'),
          //       //       ],
          //       //     ),
          //       //     SizedBox(width: 20),
          //
          //       //     // Replace icon6 with the sixth icon
          //       //     Column(
          //       //       children: [
          //       //         InkWell(
          //       //             onTap: () {
          //       //               openImageScanner2(context);
          //       //             },
          //       //             child: Icon(Icons.download)),
          //       //         SizedBox(height: 8),
          //       //         Text('Import Files'),
          //       //       ],
          //       //     ),
          //       //     SizedBox(width: 20),
          //
          //       //     // Replace icon7 with the seventh icon
          //       //     Column(
          //       //       children: [
          //       //         InkWell(
          //       //             onTap: () {
          //       //               openImageScanner(context);
          //       //             },
          //       //             child: Icon(Icons.scanner_outlined)),
          //       //         SizedBox(height: 8),
          //       //         Text('ID Card'),
          //       //       ],
          //       //     ),
          //       //     SizedBox(width: 20),
          //
          //       //     // Replace icon8 with the eighth icon
          //       //     Column(
          //       //       children: [
          //       //         Icon(Icons.all_inbox),
          //       //         SizedBox(height: 8),
          //       //         Text('All '),
          //       //       ],
          //       //     ),
          //       //   ],
          //       // ),
          //     ],
          //   ),
          // ),
          Container(
            height: 60,
            decoration: BoxDecoration(
              color:
                  isSearchOpen ? Color(0xff0FFFFFF) : AppColors.SecondaryColor,
              boxShadow: [
                BoxShadow(
                  color: isSearchOpen
                      ? Color(0xff0FFFFFF)
                      : Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 0.5), // changes position of shadow
                ),
              ],
            ),
            child: isSearchOpen // Conditional rendering based on search state
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(top: 8, bottom: 8),
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: 'Search for folders,OCR',
                                border: InputBorder.none,
                                prefixIcon: Icon(Icons.search),
                                contentPadding: EdgeInsets.only(top: 10),
                                filled:
                                    true, // This will fill the background with the specified color
                                fillColor: Color(0xffEFF2F9),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xffEFF2F9),
                                  ), // Adjust border color if needed
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Adjust border radius as needed
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xffEFF2F9),
                                  ), // Adjust border color if needed
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Adjust border radius as needed
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  searchQuery =
                                      value.trim(); // Update search query
                                });
                              },
                              onSubmitted: (value) {
                                setState(() {
                                  searchQuery =
                                      value.trim(); // Update search query
                                });
                              },
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isSearchOpen = false; // Close search field
                              _searchController.clear(); // Clear text field
                              searchQuery = ''; // Clear search query
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.clear),
                          ),
                        ),
                        InkWell(
                            onTap: () {
                              final dataprovider = Provider.of<DataProvider>(
                                  context,
                                  listen: false);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SelectionModeScreen(
                                    items: dataprovider.items,
                                    selectedView: selectedView,
                                  ),
                                ),
                              ).then((selectedItems) {
                                // Handle the selected items returned from the selection mode screen
                                if (selectedItems != null) {
                                  setState(() {
                                    _selectedIndices
                                        .clear(); // Clear previously selected indices
                                    _selectedIndices.addAll(selectedItems);
                                  });
                                }
                              });
                            },
                            child: Icon(
                              Icons.check_box_outlined,
                              color: Color(0xff192A36),
                              size: 25,
                            )),
                        SizedBox(width: 10),
                        InkWell(
                            onTap: () {
                              DataProvider dataProvider =
                                  Provider.of<DataProvider>(context,
                                      listen: false);
                              List<String> items = dataProvider.items;
                              items.sort();
                              dataProvider.items = items;
                              setState(() {});
                            },
                            child: Icon(
                              Icons.sort_rounded,
                              color: Color(0xff192A36),
                              size: 25,
                            )),
                      ],
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'All Docs',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        ListTile(
                                          leading: Icon(
                                            Icons.format_list_bulleted,
                                            size: 20,
                                            color: Colors.green,
                                          ),
                                          title: Text('ListView'),
                                          tileColor: selectedView == 'ListView'
                                              ? Colors.grey.shade300
                                              : null,
                                          onTap: () {
                                            setState(() {
                                              selectedView = 'ListView';
                                            });
                                            Navigator.pop(
                                                context); // Close the bottom sheet
                                          },
                                        ),
                                        ListTile(
                                          leading: Icon(
                                            Icons.grid_view,
                                            size: 20,
                                            color: Colors.green,
                                          ),
                                          title: Text('GridView'),
                                          tileColor:
                                              selectedView == 'GridView 2'
                                                  ? Colors.grey.shade300
                                                  : null,
                                          onTap: () {
                                            setState(() {
                                              selectedView = 'GridView 2';
                                            });
                                            Navigator.pop(
                                                context); // Close the bottom sheet
                                          },
                                        ),
                                        ListTile(
                                          leading: Icon(
                                            Icons.grid_view,
                                            size: 20,
                                            color: Colors.green,
                                          ),
                                          title: Text('GridView (3 Columns)'),
                                          tileColor:
                                              selectedView == 'GridView 3'
                                                  ? Colors.grey.shade300
                                                  : null,
                                          onTap: () {
                                            setState(() {
                                              selectedView = 'GridView 3';
                                            });
                                            Navigator.pop(
                                                context); // Close the bottom sheet
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            child: Icon(Icons.grid_view_outlined,
                                color: Color(0xff192A36), size: 25),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('Create a Folder'),
                                      content: TextField(
                                        controller: _nameController,
                                        decoration:
                                            InputDecoration(labelText: 'Name'),
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
                                                Provider.of<DataProvider>(
                                                    context,
                                                    listen: false);
                                            bool isNameExists =
                                                await dataProvider
                                                    .isNameExists(name);
                                            if (isNameExists) {
                                              // Show a toast indicating that the name already exists
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      'Folder with this name already exists.'),
                                                ),
                                              );
                                            } else if (_nameController
                                                .text.isEmpty) {
                                              // If the name doesn't exist, add it to the data provider
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content:
                                                      Text('Cannot be Empty.'),
                                                ),
                                              );
                                            } else {
                                              dataProvider.addItem(name);
                                              _nameController.clear();
                                              Navigator.of(context).pop();
                                            }
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Icon(
                                Icons.create_new_folder_outlined,
                                color: Color(0xff192A36),
                                size: 25,
                              )),
                          SizedBox(
                            width: 15,
                          ),
                          InkWell(
                              onTap: () {
                                setState(() {
                                  isSearchOpen = true; // Open search field
                                });
                              },
                              child: Icon(
                                Icons.search,
                                color: Color(0xff192A36),
                                size: 25,
                              )),
                          SizedBox(
                            width: 15,
                          ),
                          InkWell(
                              onTap: () {
                                final dataprovider = Provider.of<DataProvider>(
                                    context,
                                    listen: false);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SelectionModeScreen(
                                      items: dataprovider.items,
                                      selectedView: selectedView,
                                    ),
                                  ),
                                ).then((selectedItems) {
                                  // Handle the selected items returned from the selection mode screen
                                  if (selectedItems != null) {
                                    setState(() {
                                      _selectedIndices
                                          .clear(); // Clear previously selected indices
                                      _selectedIndices.addAll(selectedItems);
                                    });
                                  }
                                });
                              },
                              child: Icon(
                                Icons.check_box_outlined,
                                color: Color(0xff192A36),
                                size: 25,
                              )),
                          SizedBox(
                            width: 15,
                          ),
                        ],
                      )
                    ],
                  ),
          ),
          SizedBox(
            height: 7,
          ),
          // ListTile(
          //   onTap: () {
          //     Navigator.push(context, MaterialPageRoute(
          //       builder: (context) {
          //         return batchImages(
          //           value: '',
          //         );
          //       },
          //     ));
          //   },
          //   leading: Icon(
          //     Icons.folder,
          //     size: 30,
          //   ),
          //   title: Text('Batch Images'),
          //   trailing: Text(imageProvider.images.length.toString()),
          // ),
          Expanded(
            child: getView(selectedView),
          ),
        ],
      ),
      floatingActionButton: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: AppColors.primaryColor,
            child: Icon(
              Icons.image_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              pickFil2('pdf');
            },
            heroTag: 'fabl',
          ),
          SizedBox(
            width: 6,
          ),
          SpeedDial(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  15.0), // Yahan aap apne pasand ke mutabiq radius set kar sakte hain.
            ),
            backgroundColor: AppColors.primaryColor,
            icon: Icons.camera_alt_outlined,
            iconTheme: IconThemeData(color: Colors.white),
            activeIcon: Icons.close,
            spacing: 3,
            buttonSize: Size(58, 58),
            children: [
              SpeedDialChild(
                elevation: 0,
                child: Icon(
                  Icons.document_scanner,
                  color: Colors.black,
                ),
                backgroundColor: AppColors.SecondaryColor,
                labelStyle:
                    TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
                labelBackgroundColor: Colors.black,
                labelWidget: Text(
                  'Scanning   ',
                  style: TextStyle(color: Colors.black),
                ),
                onTap: () {
                  openImageScanner(context);
                },
              ),
              SpeedDialChild(
                elevation: 0,
                child: Icon(
                  Icons.batch_prediction_outlined,
                  color: Colors.black,
                ),
                backgroundColor: AppColors.FourthColor,
                labelStyle:
                    TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
                labelBackgroundColor: Colors.black,
                labelWidget: Text(
                  'Batch Images   ',
                  style: TextStyle(color: Colors.black),
                ),
                onTap: () {
                  String? chosenItem;
                  // Inside your code where images are being captured and saved
                  List<MediaModel> capturedImages = [];
                  ImageListProvider imageProvider =
                      Provider.of<ImageListProvider>(context, listen: false);
                  int currentFilesLength = 0;
                  MultipleImageCamera.capture(context: context)
                      .then((capturedImages) async {
                    if (capturedImages != null && capturedImages.isNotEmpty) {
                      List<File> files = capturedImages
                          .map((mediaModel) => mediaModel.file)
                          .toList();
                      currentFilesLength = files.length;
                      for (File image in files) {
                        chosenItem = await showDialog<String>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('total pics ${currentFilesLength}'),
                                  IconButton(
                                    icon: Icon(Icons.add),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text('Create a Folder'),
                                            content: TextField(
                                              controller: _nameController,
                                              decoration: InputDecoration(
                                                  labelText: 'Name'),
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
                                                  String name =
                                                      _nameController.text;
                                                  DataProvider dataProvider =
                                                      Provider.of<DataProvider>(
                                                          context,
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
                              content: SingleChildScrollView(
                                  child: Consumer<DataProvider>(
                                builder: (context, dataProvider, child) {
                                  // Your Column widget here, using data from dataProvider.items
                                  return Column(
                                    children: dataProvider.items.map((item) {
                                      return ListTile(
                                        title: Text(item),
                                        onTap: () {
                                          final snackBar = SnackBar(
                                            content: Text(
                                                'Save in this folder $item'), // Your snackbar message
                                            duration: Duration(
                                                seconds:
                                                    2), // Duration for how long the snackbar is displayed
                                          );
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);

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
                        // final imageProvider =
                        //     Provider.of<ImageListProvider>(context,
                        //         listen: false);
                        // imageProvider.addImage(
                        //     _scannedImage!, chosenItem!);
                        currentFilesLength = currentFilesLength - 1;
                        imageProvider.addImage(image, chosenItem!);
                      }
                    }
                  });
                },
              ),
              // SpeedDialChild(
              //   elevation: 0,
              //   backgroundColor: AppColors.ThirdColor,
              //   labelStyle:
              //       TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
              //   labelBackgroundColor: Colors.black,
              //   child: Icon(
              //     Icons.scanner,
              //     color: Colors.black,
              //   ),
              //   labelWidget: Text(
              //     'Image to Text  ',
              //     style: TextStyle(color: Colors.black),
              //   ),
              //   onTap: () {},
              // ),

              // SpeedDialChild(
              //   elevation: 0,
              //   child: Icon(
              //     Icons.image_rounded,
              //     color: Colors.red.shade300,
              //   ),
              //   labelWidget: Text(
              //     'Import File',
              //     style: TextStyle(color: Colors.blue),
              //   ),
              //   onTap: () {
              //     pickFil2('pdf');
              //   },
              // ),
              // SpeedDialChild(
              //   elevation: 0,
              //   child: Icon(
              //     Icons.wordpress,
              //     color: Colors.blue,
              //   ),
              //   labelWidget: Text(
              //     'Word to Pdf',
              //     style: TextStyle(color: Colors.blue),
              //   ),
              //   onTap: () {
              //     pickFile('pdf');
              //   },
              // ),
              // SpeedDialChild(
              //   elevation: 0,
              //   child: Icon(
              //     Icons.wordpress,
              //     color: Colors.blue,
              //   ),
              //   labelWidget: Text(
              //     'Pdf to Word',
              //     style: TextStyle(color: Colors.blue),
              //   ),
              //   onTap: () {
              //     pickFile('docx');
              //   },
              // ),
              // SpeedDialChild(
              //   elevation: 0,
              //   child: Icon(
              //     Icons.picture_as_pdf,
              //     color: Colors.red,
              //   ),
              //   labelWidget: Text(
              //     'Image to Pdf',
              //     style: TextStyle(color: Colors.red),
              //   ),
              //   onTap: () {
              //     pickFile('pdf');
              //   },
              // ),
              // SpeedDialChild(
              //   elevation: 0,
              //   child: Icon(
              //     Icons.edit_document,
              //     color: Colors.purple,
              //   ),
              //   labelWidget: Text(
              //     'pdf to excel',
              //     style: TextStyle(color: Colors.purple),
              //   ),
              //   onTap: () {
              //     pickFile('xlsx');
              //   },
              // ),
            ],
          ),
        ],
      ),
    );
  }

  String selectedFilePath = '';

  Future<void> pickFile(String name) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        selectedFilePath = result.files.single.path!;
        AsposeWordsCloudService()
            .uploadDocument(selectedFilePath, context, name);
      });
    }
  }

  Widget getView(String selectedView) {
    switch (selectedView) {
      case 'ListView':
        return buildListView();
      case 'GridView 2':
        return buildGridView(2);
      case 'GridView 3':
        return buildGridView(3);
      default:
        return buildListView();
    }
  }

  Widget buildListView() {
    return Consumer<DataProvider>(
      builder: (context, dataProvider, child) {
        final items = dataProvider.items;
        final filteredItems = searchQuery.isEmpty
            ? items // Show all items if search query is empty
            : items
                .where((item) =>
                    item.toLowerCase().contains(searchQuery.toLowerCase()))
                .toList();

        return ListView.builder(
          itemCount: filteredItems.length,
          itemBuilder: (context, index) {
            final selectedChosenItem = filteredItems[index];
            final selectedImages = Provider.of<ImageListProvider>(
              context,
              listen: true,
            ).getImagesForItem(selectedChosenItem);

            return buildListItem(
              selectedChosenItem,
              selectedImages,
              filteredItems.length,
              items.length,
              index,
            );
          },
        );
      },
    );
  }

  Widget buildGridView(int crossAxisCount) {
    return Consumer<DataProvider>(
      builder: (context, dataProvider, child) {
        final items = dataProvider.items;
        final filteredItems = searchQuery.isEmpty
            ? items // Show all items if search query is empty
            : items
                .where((item) =>
                    item.toLowerCase().contains(searchQuery.toLowerCase()))
                .toList();

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 20, // Set to 0
            crossAxisSpacing: 0, // Set to 0
            childAspectRatio: 0.9,
          ),
          itemCount: filteredItems.length,
          itemBuilder: (context, index) {
            final selectedChosenItem = filteredItems[index];
            final selectedImages = Provider.of<ImageListProvider>(
              context,
              listen: true,
            ).getImagesForItem(selectedChosenItem);

            return buildListItem(
              selectedChosenItem,
              selectedImages,
              filteredItems.length,
              items.length,
              index,
            );
          },
        );
      },
    );
  }

  Widget buildListItem(String selectedChosenItem, List<File> selectedImages,
      int itemCount, int index2, int index1) {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    final TextEditingController _nameController =
        TextEditingController(text: selectedChosenItem);

    // Function to update the item's name
    void updateItemName(String newName) {
      // Update the item's name in the data provider
      final dataProvider = Provider.of<DataProvider>(context, listen: false);
      dataProvider.updateItemName(selectedChosenItem, newName, context);
      // Close the dialog
      Navigator.of(context).pop();
    }

    return selectedView.contains('GridView')
        ? InkWell(
            onLongPress: () {
              final dataprovider =
                  Provider.of<DataProvider>(context, listen: false);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SelectionModeScreen(
                    items: dataprovider.items,
                    selectedView: selectedView,
                  ),
                ),
              ).then((selectedItems) {
                // Handle the selected items returned from the selection mode screen
                if (selectedItems != null) {
                  setState(() {
                    _selectedIndices
                        .clear(); // Clear previously selected indices
                    _selectedIndices.addAll(selectedItems);
                  });
                }
              });
            },
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ImageScreen(
                    selectedItemName: selectedChosenItem,
                    selectedImages: selectedImages,
                    items: selectedChosenItem,
                  ),
                ),
              );
            },
            child: Container(
              // Check if selectedView contains 'GridView'
              height: 200,
              width: 100,
              margin: EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                // border: Border.all(
                //   color: Colors.black,
                //   width: 1.0, // Adjust the width as needed
                // ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  selectedImages.isEmpty
                      ? Container(
                          margin: EdgeInsets.only(
                            top: selectedView.contains('GridView 3') ? 30 : 50,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.folder,
                              size:
                                  selectedView.contains('GridView 3') ? 50 : 80,
                              color: Color(0xff192A36),
                            ),
                          ),
                        )
                      : Image.file(
                          selectedImages[0],
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width,
                          height:
                              selectedView.contains('GridView 3') ? 90 : 150,
                        ),
                  SizedBox(
                    height: selectedView.contains('GridView 3') ? 3 : 10,
                  ),
                  Container(
                    // hei,
                    width: selectedView.contains('GridView 3') ? 100 : 150,
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(left: 10),
                    child: Text(
                      selectedChosenItem,
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xff192A36),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        width: 18,
                        height: selectedView.contains('GridView 3') ? 16 : 20,
                        decoration: BoxDecoration(
                          color: AppColors.SecondaryColor,
                          borderRadius: BorderRadius.circular(33),
                          border: Border.all(
                            color: AppColors.SecondaryColor,
                            width: 1.0, // Adjust the width as needed
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '${selectedImages.length}',
                            style: TextStyle(
                                fontSize: 10, color: Color(0xff192A36)),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.topRight,
                        margin: EdgeInsets.only(
                          right: 10,
                        ),
                        child: InkWell(
                          child: Icon(
                            Icons.edit,
                            size: selectedView.contains('GridView 3') ? 20 : 25,
                          ),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Update Item Name'),
                                  content: TextFormField(
                                    controller: _nameController,
                                    decoration:
                                        InputDecoration(labelText: 'New Name'),
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
                                        // Call updateItemName function with the new name
                                        if (_nameController.text.isEmpty) {
                                          final snackBar = SnackBar(
                                            content: Text(
                                                'Cannot be empty'), // Your snackbar message
                                            duration: Duration(
                                                seconds:
                                                    2), // Duration for how long the snackbar is displayed
                                          );
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                        } else {
                                          updateItemName(_nameController.text);
                                        }
                                      },
                                      child: Text('Update'),
                                    ),
                                  ],
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
          )
        : Container(
            color: Colors.white,
            child: InkWell(
              onLongPress: () {
                final dataprovider =
                    Provider.of<DataProvider>(context, listen: false);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SelectionModeScreen(
                      items: dataprovider.items,
                      selectedView: selectedView,
                    ),
                  ),
                ).then((selectedItems) {
                  // Handle the selected items returned from the selection mode screen
                  if (selectedItems != null) {
                    setState(() {
                      _selectedIndices
                          .clear(); // Clear previously selected indices
                      _selectedIndices.addAll(selectedItems);
                    });
                  }
                });
              },
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImageScreen(
                      selectedItemName: selectedChosenItem,
                      selectedImages: selectedImages,
                      items: selectedChosenItem,
                    ),
                  ),
                );
              },
              child: Column(
                children: [
                  Row(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: selectedImages.isEmpty
                                ? Icon(
                                    Icons.folder,
                                    size: 50,
                                    color: Color(0xff192A36),
                                  )
                                : Image.file(
                                    selectedImages[0], // The first File object
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          SizedBox(
                              width:
                                  20), // Adjust the spacing between icon and title as needed
                          Text(selectedChosenItem,
                              style: TextStyle(
                                  fontSize: 16, color: Color(0xff192A36))),
                        ],
                      ),
                      Spacer(),
                      SizedBox(
                          width:
                              8), // Adjust the spacing between title and trailing content as needed
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        width: 18,
                        height: 20,
                        decoration: BoxDecoration(
                          color: AppColors.SecondaryColor,
                          borderRadius: BorderRadius.circular(33),
                          border: Border.all(
                            color: AppColors.SecondaryColor,
                            width: 1.0, // Adjust the width as needed
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '${selectedImages.length}',
                            style: TextStyle(
                                fontSize: 10, color: Color(0xff192A36)),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Update Item Name'),
                                content: TextField(
                                  controller: _nameController,
                                  decoration:
                                      InputDecoration(labelText: 'New Name'),
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
                                      // Call updateItemName function with the new name
                                      updateItemName(_nameController.text);
                                    },
                                    child: Text('Update'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  if (index1 != index2 - 1) Divider(),
                ],
              ),
            ),
          );
  }
}

class User {
  final String email;
  final String displayName;
  final String photoUrl;

  User({
    required this.email,
    required this.displayName,
    required this.photoUrl,
  });
}
// Consumer<DataProvider>(
// builder: (context, dataProvider, child) {
// final items = dataProvider.items;
//
// return Container(
// child: ListView.builder(
// itemCount: items.length,
// itemBuilder: (context, index) {
// final selectedChosenItem = items[index];
//
// // Get the selectedImages asynchronously
// final selectedImages = Provider.of<ImageListProvider>(
// context,
// listen: true, // Listen to changes in the image list
// ).getImagesForItem(selectedChosenItem);
// return Slidable(
// key: Key(items[index]),
// endActionPane: ActionPane(
// // A motion is a widget used to control how the pane animates.
// motion: StretchMotion(),
//
// // A pane can dismiss the Slidable.
// // All actions are defined in the children parameter.
// children: [
// // A SlidableAction can have an icon and/or a label.
// SlidableAction(
// onPressed: (context) {},
// backgroundColor: Colors.grey,
// foregroundColor: Colors.white,
// icon: Icons.info_rounded,
// label: 'Option',
// ),
// SlidableAction(
// onPressed: (context) {
// showDialog(
// context: context,
// builder: (BuildContext context) {
// return AlertDialog(
// title: Text('Confirmation'),
// content: Text(
// 'Are you sure you want to delete this folder?'),
// actions: <Widget>[
// TextButton(
// child: Text('Cancel'),
// onPressed: () {
// Navigator.of(context)
//     .pop(); // Close the dialog
// },
// ),
// TextButton(
// child: Text('Delete'),
// onPressed: () {
// dataProvider.removeItem(index);
// Navigator.of(context)
//     .pop(); // Close the dialog
// },
// ),
// ],
// );
// },
// );
// },
// backgroundColor: Colors.red,
// foregroundColor: Colors.white,
// icon: Icons.delete,
// label: 'delete',
// ),
// ],
// ),
// child: Column(
// children: [
// ListTile(
// onTap: () {
// Navigator.push(context, MaterialPageRoute(
// builder: (context) {
// final selectedChosenItem = items[index];
// final selectedImages =
// Provider.of<ImageListProvider>(context,
// listen: false)
//     .getImagesForItem(
// selectedChosenItem);
// print(selectedImages);
// return ImageScreen(
// selectedItemName: selectedChosenItem,
// selectedImages: selectedImages,
// items: items[index]);
// },
// ));
// },
// leading: selectedImages.isEmpty
// ? Icon(
// Icons.folder,
// size: 50,color: Color(0xff192A36),
// )
//     : Image.file(
// selectedImages[
// 0], // The first File object
// width: 40,
// height: 40,
// fit: BoxFit.cover,
// ),
// title: Text(items[index]),
// trailing: Text('${selectedImages.length}'),
// ),
// ],
// ),
// );
// },
// ),
// );
// },
// ),