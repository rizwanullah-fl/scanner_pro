import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:document_scanner_flutter/configs/configs.dart';
import 'package:document_scanner_flutter/document_scanner_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import 'package:scanner/management/provider_image.dart';
import 'package:scanner/scanned_images_folder/Maincolor.dart';
import 'package:scanner/scanned_images_folder/download_images.dart';
import 'package:scanner/scanned_images_folder/qr_scan.dart';
import 'package:scanner/scanned_images_folder/scan_folder.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class ImageScreen extends StatefulWidget {
  late final String selectedItemName;
  late final List<File> selectedImages;
  final String items;

  ImageScreen(
      {required this.selectedItemName,
      required this.selectedImages,
      required this.items});

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  bool isSelectionMode = false;
  final TextEditingController _nameController = TextEditingController();
  File? _scannedImage;
  Map<int, bool> selectedFlag = {};
  openImageScanner(BuildContext context) async {
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

      if (widget.items != null && widget.items.isNotEmpty) {
        // Add the scanned image to the ImageListProvider
        final imageProvider =
            Provider.of<ImageListProvider>(context, listen: false);
        imageProvider.addImage(_scannedImage!, widget.items);

        // No need to add the chosen item as it already exists in DataProvider
        // You can use the chosenItem to associate the image with this item if needed

        setState(() {});
      }
    }
  }

  bool selectAll = false;
  void toggleSelectAll() {
    setState(() {
      selectAll = !selectAll;

      // Implement the logic to select or deselect all items
      if (selectAll) {
        // If 'Select All' is pressed, select all items
        for (int i = 0; i < selectedFlag.length; i++) {
          selectedFlag[i] = true;
        }
      } else {
        // If 'Select All' is pressed again, deselect all items
        for (int i = 0; i < selectedFlag.length; i++) {
          selectedFlag[i] = false;
        }
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      selectedImagess;
      widget.selectedItemName.toString();
      widget.items.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedImages =
        Provider.of<ImageListProvider>(context, listen: false)
            .getImagesForItem(widget.items);
    final imageProvider =
        Provider.of<ImageListProvider>(context, listen: false);
    print(widget.items);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xff192A36),
        title: Text(
          widget.items,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              // onTap(isSelected, index);
              // Show the bottom sheet when the button is pressed
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return buildBottomSheetContent(context, imageProvider);
                },
              );

              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) =>
              //         CollageScreen(selectedImages: selectedImages),
              //   ),
              // );
            },
            child: Container(
              margin: EdgeInsets.only(right: 10),
              child: Icon(Icons.more_vert, color: Colors.white),
            ),
          ),
        ],
      ),
      body:
          Consumer<ImageListProvider>(builder: (context, imageProvider, child) {
        return ReorderableGridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 20, // Set to 0
              crossAxisSpacing: 0, // Set to 0
              childAspectRatio: 0.9),
          itemCount: selectedImages.length,
          itemBuilder: (context, index) {
            File data = selectedImages[index];
            selectedFlag[index] = selectedFlag[index] ?? false;
            bool? isSelected = selectedFlag[index];
            print(selectedImages.length);
            return LongPressDraggable<int>(
              onDragEnd: (details) {
                // Handle drag end here using 'details'
                onLongPress(isSelected!, index);
              },
              key: ValueKey(index),
              data: index,
              child: InkWell(
                onTap: () {
                  onTap(isSelected!, index);
                  isSelectionMode
                      ? SizedBox()
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChangesInImages(
                                  images: selectedImages[index],
                                  itemName: index,
                                  folderName: widget.selectedItemName)),
                        ).then((value) => selectedImages[index]);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10)
                  ),
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.only(right: 10,left: 10),
                  key: ValueKey(index),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Stack( // Wrap your image and text widgets inside a Stack
                          children: [
                            Image.file(
                              selectedImages[index],
                              fit: BoxFit.fitWidth,
                              width: MediaQuery.of(context).size.width - 100,
                              height: 200,
                            ),
                      if (isSelectionMode)
                 Positioned(
                   top: 10.0,
                   right: 10,
                   child: Icon(
                     isSelected! ? Icons.check_box : Icons.check_box_outline_blank,
                                   color: AppColors.SecondaryColor,
                                   ),
                 ),

                            Positioned( // Position the text widget on top of the image
                              top: 170.0, // Adjust the top position as needed// Adjust the left position as needed
                              child: Container(
                                width: MediaQuery.of(context).size.width - 100,
                                color: Color(0xffE9ECEF),
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  (index+1).toString(),
                                  style: TextStyle(
                                    fontSize: 20.0, // Adjust the font size as needed
                                    color: Colors.black, // You can change the color here
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // _buildSelectIcon(isSelected!, data, index + 1),
                      ],
                    ),
                  ),
                ),
              ),
              feedback: Material(
                child: Container(
                  key: ValueKey(index),
                  width: 200.0,
                  height: 200.0,
                  color: Colors.transparent,
                  child: Image.file(
                    selectedImages[index],
                    width: 230,
                    height: 155,
                  ),
                ),
              ),
              childWhenDragging: Container(),
            );
          },
          onReorder: (oldIndex, newIndex) {
            setState(() {
              final element = selectedImages.removeAt(oldIndex);
              selectedImages.insert(newIndex, element);
              // imageProvider.images.insert(newIndex, element);
            });
            // if (oldIndex < newIndex) {
            //   newIndex -= 1;
            // }
            // final File image = selectedImages.removeAt(oldIndex);
            // selectedImages.insert(newIndex, image);
          },
        );
      }),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Color(0xff0DA292F),
      //   onPressed: () {
      //     openImageScanner(context);
      //   },
      //   child: Icon(
      //     Icons.add_a_photo,
      //     color: Colors.white,
      //   ),
      // ),
      bottomNavigationBar: isSelectionMode
          ? BottomAppBar(
              height: isSelectionMode ? 50 : 0.0,
              color: isSelectionMode ? Color(0xff192A36) : Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                    onTap: () {
                      deleteSelectedImages(imageProvider);
                    },
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.select_all,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      toggleSelectAll(); // Call the toggleSelectAll method
                    },
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  InkWell(
                      child: Icon(
                        Icons.share,
                        color: Colors.white,
                      ),
                      onTap: () {
                        shareSelectedImagesFromProvider(imageProvider, 0);
                      }),
                ],
              ))
          : SizedBox(),
    );
  }

  Future<Uint8List> generatePdf(List<File> selectedImages) async {
    final pdf = pw.Document();

    for (var image in selectedImages) {
      final imageBytes = await image.readAsBytes();
      pdf.addPage(
        pw.Page(
          build: (context) {
            return pw.Image(pw.MemoryImage(imageBytes));
          },
        ),
      );
    }

    return pdf.save();
  }

  Future<List<int>> _readDocumentData(String name) async {
    final ByteData data = await rootBundle.load(name);
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  Future<void> shareSelectedImages(
      List<File> selectedImages, BuildContext context, int value) async {
    if (selectedImages.isNotEmpty) {
      final pdfBytes = await generatePdf(selectedImages);
      final directory = await getTemporaryDirectory();
      final pdfPath = '${directory.path}/images.pdf';

      // Create a PDF document from the generated bytes
      PdfDocument document = PdfDocument(inputBytes: pdfBytes);

      showModalBottomSheet(
        context: context, // Use the scaffold's context
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.picture_as_pdf),
                title: Text(value == 1 ? 'Lock and Share PDf' : 'Share in PDF'),
                onTap: () async {
                  if (value == 1) {
                    // Show a dialog to ask whether to set a password for the PDF
                    bool setPassword = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Set Password?'),
                          content: Text(
                              'Do you want to set a password for the PDF?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(false); // No password
                              },
                              child: Text('No'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(true); // Set password
                              },
                              child: Text('Yes'),
                            ),
                          ],
                        );
                      },
                    );

                    if (setPassword) {
                      // If the user wants to set a password, show a TextFormField
                      String userPassword = '';
                      String ownerPassword = '';

                      // Show a dialog to input passwords
                      await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Set Passwords'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  decoration: InputDecoration(
                                      labelText: 'User Password'),
                                  onChanged: (value) {
                                    userPassword = value;
                                  },
                                ),
                                TextFormField(
                                  decoration: InputDecoration(
                                      labelText: 'Owner Password'),
                                  onChanged: (value) {
                                    ownerPassword = value;
                                  },
                                ),
                              ],
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  // Show toast message after setting password
                                  Fluttertoast.showToast(
                                    msg: "Password set successfully!",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.grey,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );
                                },
                                child: Text('Set'),
                              ),
                            ],
                          );
                        },
                      );

                      // Set passwords for the PDF document if provided
                      if (userPassword.isNotEmpty && ownerPassword.isNotEmpty) {
                        document.security.userPassword = userPassword;
                        document.security.ownerPassword = ownerPassword;
                      }
                    }
                  }

                  // Set the encryption algorithm and permissions
                  document.security.algorithm =
                      PdfEncryptionAlgorithm.aesx256Bit;
                  document.security.permissions.addAll([
                    PdfPermissionsFlags.print,
                    PdfPermissionsFlags.copyContent
                  ]);

                  // Save the PDF document with encryption
                  await File(pdfPath).writeAsBytes(await document.save());

                  // Dispose the PDF document
                  document.dispose();

                  Navigator.of(context).pop(); // Close the modal dialog

                  Share.shareFiles(
                    [pdfPath],
                    text: 'Check out these images in PDF!',
                    subject: 'Image Share',
                  );
                },
              ),
              value == 1
                  ? SizedBox()
                  : ListTile(
                      leading: Icon(Icons.image),
                      title: Text('Share in Image'),
                      onTap: () async {
                        if (selectedImages.isNotEmpty) {
                          List<String> imagePaths = selectedImages
                              .map((image) => image.path)
                              .toList();

                          await Share.shareFiles(
                            imagePaths,
                            text: 'Check out these images!',
                            subject: 'Image Share',
                          );
                        }
                      },
                    ),
            ],
          );
        },
      );
    }
  }

  void deleteimages(ImageListProvider imageProvider) {
    imageProvider.deleteImage(imageProvider.images.first);
  }

  List<File> selectedImagess = [];
  void shareSelectedImagesFromProvider(
      ImageListProvider imageProvider, int value) {
    for (int index = 0; index < selectedFlag.length; index++) {
      if (selectedFlag[index] == true) {
        selectedImagess.add(widget.selectedImages[index]);
      }
    }

    shareSelectedImages(selectedImagess, context, value);
  }

  void AllImagesFromProvider(ImageListProvider imageProvider, int value) {
    selectedImagess.clear();

    // Add all selected images to the list
    for (int index = 0; index < widget.selectedImages.length; index++) {
      selectedImagess.add(widget.selectedImages[index]);
    }

    shareSelectedImages(selectedImagess, context, value);
  }

  void deleteAllSelectedImages(ImageListProvider imageProvider) {
    List<int> indicesToRemove = [];

    for (int index = 0; index < selectedFlag.length; index++) {
      if (selectedFlag[index] == true) {
        indicesToRemove.add(index);
      }
    }

    deleteSelectedImages(
      imageProvider,
    );
  }

  void deleteSelectedImages(
    ImageListProvider imageProvider,
  ) {
    List<int> indicesToRemove = [];

    for (int index = 0; index < selectedFlag.length; index++) {
      if (selectedFlag[index] == true) {
        indicesToRemove.add(index);
      }
    }

    // Sort the indices in descending order so that we remove items from the end of the list first
    indicesToRemove.sort((a, b) => b.compareTo(a));

    for (int index in indicesToRemove) {
      File imageToDelete = widget.selectedImages[index];
      imageProvider.deleteImage(imageToDelete);
      widget.selectedImages.removeAt(index);
      selectedFlag.remove(index);
    }

    // Exit selection mode after deleting selected images
    setState(() {
      isSelectionMode = false;
    });
  }

  void onTap(bool isSelected, int index) {
    if (isSelectionMode) {
      setState(() {
        selectedFlag[index] = !isSelected;
        isSelectionMode = selectedFlag.containsValue(true);
      });
    } else {
      // Open Detail Page
    }
  }

  void onLongPress(bool isSelected, int index) {
    setState(() {
      selectedFlag[index] = !isSelected;
      isSelectionMode = selectedFlag.containsValue(true);
    });
    setState(() {
      selectedImagess;
    });
  }

  Widget _buildSelectIcon(bool isSelected, File data, index) {
    if (isSelectionMode) {
      return Icon(
        isSelected ? Icons.check_box : Icons.check_box_outline_blank,
        color: Color(0xff192A36),
      );
    } else {
      return Text(index.toString());
    }
  }

  Widget buildBottomSheetContent(
      BuildContext context, ImageListProvider imageProvider) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.23,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.lock),
                      onPressed: () => AllImagesFromProvider(imageProvider, 1),
                    ),
                    Text('Lock'), // Label for Lock IconButton
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.drive_file_rename_outline),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text('Share This App'), // Label for Rename IconButton
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.select_all),
                      onPressed: () {
                        _selectAll();
                        Navigator.pop(context);
                      },
                    ),
                    Text('Select All'), // Label for Select All IconButton
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.image),
                      onPressed: () => openImageScanner(context),
                    ),
                    Text('Import'), // Label for Grid View IconButton
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: () => AllImagesFromProvider(imageProvider, 0),
                    ),
                    Text('Share'), // Label for Share IconButton
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.qr_code_scanner),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => QrScan()));
                      },
                    ),
                    Text('QR Scanner'), // Label for QR Scanner IconButton
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget? _buildSelectAllButton() {
    bool isFalseAvailable = selectedFlag.containsValue(false);
    if (isSelectionMode) {
      return FloatingActionButton(
        backgroundColor: Colors.cyan,
        onPressed: _selectAll,
        child: Icon(
          isFalseAvailable ? Icons.done_all : Icons.remove_done,
        ),
      );
    } else {
      return null;
    }
  }

  void _selectAll() {
    bool isFalseAvailable = selectedFlag.containsValue(false);
    selectedFlag.updateAll((key, value) => isFalseAvailable);
    setState(() {
      isSelectionMode = selectedFlag.containsValue(true);
    });
  }
}

class CollageScreen extends StatelessWidget {
  final List<File> selectedImages;

  CollageScreen({required this.selectedImages});
  void saveCollage(List<File> images) async {
    for (File image in images) {
      final result = await ImageGallerySaver.saveFile(image.path);
      if (result['isSuccess'] == true) {
        // The image was saved successfully.
        print("Image saved successfully: ${image.path}");
      } else {
        // There was an error saving the image.
        print("Failed to save image: ${image.path}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Collage"),
        actions: [
          InkWell(
              onTap: () {
                saveImagesAsPdf(
                  selectedImages,
                );
              },
              child: Icon(Icons.save))
        ],
      ),
      body: GridView.builder(
        gridDelegate: SliverWovenGridDelegate.count(
          crossAxisCount: 3,
          pattern: [
            WovenGridTile(1),
            WovenGridTile(
              5 / 7,
              crossAxisRatio: 0.9,
              alignment: AlignmentDirectional.centerEnd,
            ),
          ],
        ),
        itemCount: selectedImages.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: FileImage(selectedImages[index]),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }

  Future saveImagesAsPdf(List<File> images) async {
    // Create a PDF document
    final pdf = pw.Document();

    for (var image in images) {
      final imageBytes = await image.readAsBytes();
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Image(pw.MemoryImage(imageBytes));
          },
        ),
      );
    }

    // Generate a unique file name for the PDF
    final fileName = 'images.pdf';

    // Get the application's document directory
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName');

    // Save the PDF to a file
    await file.writeAsBytes(await pdf.save());

    // Show a confirmation message
    print('PDF saved to ${file.path}');
  }
}
