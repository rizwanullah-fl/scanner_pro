import 'dart:developer';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pro_image_editor/pro_image_editor_main.dart';
import 'package:provider/provider.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:scanner/scanned_images_folder/addImagetoexcel.dart';
import 'package:scanner/scanned_images_folder/scan_folder.dart';
import 'package:scanner/scanned_images_folder/signature_Screens/signature.dart';
import 'package:share_plus/share_plus.dart';
import 'package:signature/signature.dart';
import '../management/provider_image.dart';

class ChangesInImages extends StatefulWidget {
  final File images;
  final int itemName;
  final String folderName;

  ChangesInImages(
      {Key? key,
      required this.images,
      required this.itemName,
      required this.folderName})
      : super(key: key);

  @override
  _ChangesInImagesState createState() => _ChangesInImagesState();
}

class _ChangesInImagesState extends State<ChangesInImages> {
  GlobalKey _globalKey = GlobalKey();

  // SignatureController _controller = SignatureController(
  //   penStrokeWidth: 5,
  //   penColor: Colors.red,
  //   exportBackgroundColor: Colors.blue,
  // );
  List<Positioned> textWidgets = [];
  List<DraggableText> draggableTexts = [];
  List<DraggableSignature> draggableSignature = [];
  List<DraggableImage> draggableImage = [];
  bool isDragging = false;

  void _addText(String text) {
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
    });
  }

  File? _pickedImage;
  File? _pickedSignature;
  List<DraggableItem> draggableSignatures = [];
  ImageToExcelConverter _imageToExcelConverter = ImageToExcelConverter();

  // Future<Uint8List?> getSignature() async {
  //   final signature = await _controller.toPngBytes();
  //   draggableSignature
  //       .add(DraggableSignature(Offset(100.0, 100.0), signature.toString()));
  // }

  // Function to pick an image from the gallery
  Future _pickImage(File image) async {
    if (image != null) {
      setState(() {
        _pickedImage = image;
      });
      draggableImage
          .add(DraggableImage(Offset(100.0, 100.0), image.toString()));
    }
  }

  Offset position = Offset(0.0, 0.0);
  Future<void> saveCollage(File hdImage) async {
    if (hdImage != null) {
      // Read the content of the image file as a Uint8List.
      Uint8List imageBytes = await hdImage.readAsBytes();

      final hdResult = await ImageGallerySaver.saveImage(
        imageBytes,
        quality: 100,
      );
      if (hdResult['isSuccess'] == true) {
        // The HD image was saved successfully.
        print("HD Image saved successfully: ${hdImage.path}");
      } else {
        // There was an error saving the HD image.
        print("Failed to save HD image: ${hdImage.path}");
      }
    }
  }

  Future<void> NormalSave(File hdImage) async {
    if (hdImage != null) {
      // Read the content of the image file as a Uint8List.
      Uint8List imageBytes = await hdImage.readAsBytes();

      final hdResult = await ImageGallerySaver.saveImage(
        imageBytes,
        quality: 10,
      );
      if (hdResult['isSuccess'] == true) {
        // The HD image was saved successfully.
        print("HD Image saved successfully: ${hdImage.path}");
      } else {
        // There was an error saving the HD image.
        print("Failed to save HD image: ${hdImage.path}");
      }
    }
  }

  Future<void> _pickSignature() async {
    final XFile? pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImage != null) {
      setState(() {
        _pickedSignature = File(pickedImage.path);
      });
    }
  }

  void deleteImage(File File) {
    File.delete();
  }

  @override
  void initState() {
    super.initState();
    // controller.addListener(() => log('Value changed'));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  bool isSigning = false;
  SignatureController controller = SignatureController(
    penStrokeWidth: 1,
    penColor: Colors.white,
    exportBackgroundColor: Colors.transparent,
    exportPenColor: Colors.black,
    // onDrawStart: () => log('onDrawStart called!'),
    // onDrawEnd: () => log('onDrawEnd called!'),
  );
  @override
  Widget build(BuildContext context) {
    String buttonLabel = '';
    if (draggableTexts.isNotEmpty) {
      buttonLabel = 'Save Image';
    } else if (_pickedImage != null) {
      buttonLabel = 'Save Image';
    } else if (isSigning == true) {
      buttonLabel = 'Save Image';
    } else {
      buttonLabel = 'Save in Gallery';
    }
    final selectedImages = Provider.of<ImageListProvider>(context, listen: true)
        .getImagesForItem(widget.folderName);
    ImageListProvider imageListProvider =
        Provider.of<ImageListProvider>(context, listen: true);

    print('item name ${selectedImages[widget.itemName].toString()}');
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xff192A36),
        leading: BackButton(),
        actions: [
          TextButton(
            onPressed: () {
              // setState(() {
              //   isSigning = !isSigning;
              // });
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SignatureScreen(
                          folderName: widget.folderName,
                          index: widget.itemName,
                          images: widget.images)));
            },
            child: Text(
              'Add Signature',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: InteractiveViewer(
        // Maximum scale level
        child: Container(
           height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          // padding: EdgeInsets.only(
          //   // left: 20,
          //   // top: 20,
          //   // bottom: 20,
            
          // ),
          child: RepaintBoundary(
            key: _globalKey,
            child: Image.file(
              fit:BoxFit.cover,
              selectedImages[widget.itemName],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
          height: 70,
          color: Color(0xff192A36),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                  child: Column(
                    children: [
                      Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                      Text(
                        'Delete',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                  onTap: () {
                    setState(
                      () {
                        void _deleteImage(File imageToDelete) {
                          setState(() {
                            // Remove the image from the selectedImages map
                            File imageToDelete =
                                selectedImages[widget.itemName];

                            // Call a method to delete the image from wherever it's stored
                            imageListProvider.deleteImage(imageToDelete);

                            // Remove the image from the selectedImages list
                            selectedImages.removeAt(widget.itemName);
                            // Optionally, you can also update your database or any other storage mechanism to reflect the deletion
                          });
                        }

                        File imageToDelete = selectedImages[widget.itemName];
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Delete Image'),
                              content: Text(
                                  'Are you sure you want to delete this image?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    _deleteImage(imageToDelete);
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ScannedImagesScreen()),
                                      (Route<dynamic> route) => false,
                                    );
                                    final snackBar = SnackBar(
                                      content: Text(
                                          'Your Image Successfully Delete'), // Your snackbar message
                                      duration: Duration(seconds: 2),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  },
                                  child: Text('Yes'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  }),
              SizedBox(
                width: 20,
              ),
              InkWell(
                  child: Column(
                    children: [
                      Icon(
                        Icons.print,
                        color: Colors.white,
                      ),
                      Text(
                        'Print',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                  onTap: () {
                    _createPdf(
                      selectedImages[widget.itemName].path,
                    );
                  }),
              SizedBox(
                width: 20,
              ),
              InkWell(
                child: Column(
                  children: [
                    Icon(
                      Icons.edit_document,
                      color: Colors.white,
                    ),
                    Text(
                      'Edit',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProImageEditor.file(
                        selectedImages[widget.itemName],
                        onImageEditingComplete: (bytes) async {
                          imageListProvider.updateImages(
                            widget.folderName,
                            selectedImages[widget.itemName],
                            bytes,
                          );
                          Navigator.pop(context, bytes);
                        },
                      ),
                    ),
                  );
                },
              ),
              SizedBox(
                width: 20,
              ),
              InkWell(
                  child: Column(
                    children: [
                      Icon(
                        Icons.share,
                        color: Colors.white,
                      ),
                      Text(
                        'Share',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                  onTap: () {
                    Share.shareXFiles(
                      [XFile(selectedImages[widget.itemName].path)],
                      text: 'Check out these images in PDF!',
                      subject: 'Image Share',
                    );
                  }),
              SizedBox(
                width: 20,
              ),
              InkWell(
                  child: Column(
                    children: [
                      Icon(
                        Icons.download,
                        color: Colors.white,
                      ),
                      Text(
                        'Download',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                  onTap: () async {
                    final boundary = _globalKey.currentContext!
                        .findRenderObject() as RenderRepaintBoundary;
                    final image = await boundary.toImage(
                      pixelRatio: 3, // Adjust pixelRatio as needed
                    );

                    final byteData =
                        await image.toByteData(format: ImageByteFormat.png);
                    final buffer = byteData!.buffer.asUint8List();

                    // Decode the buffer into an img.Image
                    final img.Image baseImage = img.decodeImage(buffer)!;

                    // Check if the signature is visible

                    // Continue with the existing logic...

                    // Now you have the merged image in the 'buffer' variable.
                    // Create a temporary directory to store the merged image

                    // Write the merged image data to the temporary file
                    // Read the contents of the temporary file into a Uint8List
                    Uint8List newImageBytes = Uint8List.fromList(await buffer);
                    print(widget.images);
                    print(newImageBytes);
                    Center(
                        child: CircularProgressIndicator(
                      color: Colors.amber,
                    ));
                    final snackBar = SnackBar(
                      content: Text('Your Image Save'), // Your snackbar message
                      duration: Duration(seconds: 2),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    // Now you can pass the newImageBytes to the updateImages method
                    imageListProvider.updateImages(
                        widget.folderName, widget.images, newImageBytes);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ScannedImagesScreen()),
                      (Route<dynamic> route) => false,
                    );
                  }),
            ],
          )),
    );
  }

  void _createPdf(String imagePath) async {
    final doc = pw.Document();

    // Load the image file
    final File imageFile = File(imagePath);

    // Read the image data as bytes
    final Uint8List bytes = await imageFile.readAsBytes();

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Image(
              pw.MemoryImage(bytes),
              width: 200, // Adjust width as needed
              height: 200, // Adjust height as needed
            ),
          );
        },
      ),
    );

    // Print or share the document
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());
  }

  /// display a pdf document.
  void _displayPdf() {
    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text(
              'Hello eclectify Enthusiast',
              style: pw.TextStyle(fontSize: 30),
            ),
          );
        },
      ),
    );

    /// open Preview Screen
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PreviewScreen(doc: doc),
        ));
  }

  /// Convert a Pdf to images, one image per page, get only pages 1 and 2 at 72 dpi
  void _convertPdfToImages(pw.Document doc) async {
    await for (var page
        in Printing.raster(await doc.save(), pages: [0, 1], dpi: 72)) {
      final image = page.toImage(); // ...or page.toPng()
      print(image);
    }
  }

  /// print an existing Pdf file from a Flutter asset
  void _printExistingPdf() async {
    // import 'package:flutter/services.dart';
    final pdf = await rootBundle.load('assets/document.pdf');
    await Printing.layoutPdf(onLayout: (_) => pdf.buffer.asUint8List());
  }

  /// more advanced PDF styling
  Future<Uint8List> _generatePdf(PdfPageFormat format, String title) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final font = await PdfGoogleFonts.nunitoExtraLight();

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Column(
            children: [
              pw.SizedBox(
                width: double.infinity,
                child: pw.FittedBox(
                  child: pw.Text(title, style: pw.TextStyle(font: font)),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Flexible(child: pw.FlutterLogo())
            ],
          );
        },
      ),
    );
    return pdf.save();
  }

  void generatePdf() async {
    const title = 'eclectify Demo';
    await Printing.layoutPdf(onLayout: (format) => _generatePdf(format, title));
  }
}

class PreviewScreen extends StatelessWidget {
  final pw.Document doc;

  const PreviewScreen({
    Key? key,
    required this.doc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_outlined),
        ),
        centerTitle: true,
        title: Text("Preview"),
      ),
      body: PdfPreview(
        build: (format) => doc.save(),
        allowSharing: true,
        allowPrinting: true,
        initialPageFormat: PdfPageFormat.a4,
        pdfFileName: "mydoc.pdf",
      ),
    );
  }
}

class DraggableText {
  Offset position;
  final String text;

  DraggableText(this.position, this.text);
  void updatePosition(Offset newPosition) {
    position = newPosition;
  }
}

class DraggableImage {
  Offset position;
  final String image;

  DraggableImage(this.position, this.image);

  void updatePosition(Offset newPosition) {
    position = newPosition;
  }
}

class DraggableSignature {
  Offset position;
  Size size;
  double rotationAngle; // New property to hold rotation angle in radians
  final String signature;

  DraggableSignature(this.position, this.signature,
      {required this.size, this.rotationAngle = 0.0});

  void updatePosition(Offset newPosition) {
    position = newPosition;
  }

  void setSize(double scale, {double rotationAngle = 0.0}) {
    if (size != null) {
      // Calculate new size based on scale
      double newWidth = size.width * scale;
      double newHeight = size.height * scale;

      // Calculate the average scale factor
      double averageScale = (newWidth + newHeight) / 2.0;

      // Calculate rotated size using the average scale factor
      double rotatedWidth = averageScale *
          sqrt(pow(cos(rotationAngle), 2) + pow(sin(rotationAngle), 2));
      double rotatedHeight = averageScale *
          sqrt(pow(sin(rotationAngle), 2) + pow(cos(rotationAngle), 2));

      // Update size equally
      size = Size(rotatedWidth, rotatedHeight);
    }
    this.rotationAngle = rotationAngle;
  }
}

class DraggableItem {
  Offset position;
  DraggableItem({required this.position});

  void updatePosition(Offset newPosition) {
    position = newPosition;
  }
}
