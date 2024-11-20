import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:scanner/management/signaturePad.dart';
import 'package:scanner/scanned_images_folder/signature_Screens/controller_Color.dart';
import 'package:scanner/scanned_images_folder/signature_Screens/signature_overlay.dart'; // Import the dart:math library and alias it as math

class SignatureScreen extends StatefulWidget {
  final int index;
  final String folderName;
  final File images;
  const SignatureScreen(
      {super.key,
      required this.index,
      required this.folderName,
      required this.images});

  @override
  _SignatureScreenState createState() => _SignatureScreenState();
}

class _SignatureScreenState extends State<SignatureScreen> {
  late final GlobalKey<SfSignaturePadState> signatureGlobalKey;
  late Color strokeColor;

  @override
  void initState() {
    super.initState();
    signatureGlobalKey = GlobalKey();
    strokeColor = Colors.black;
  }

  void updateStrokeColor(Color color) {
    setState(() {
      strokeColor = color;
    });
  }

  void _handleClearButtonPressed() {
    signatureGlobalKey.currentState!.clear();
  }

  void _handleSaveButtonPressed() async {
    final data = await signatureGlobalKey.currentState!.toImage(pixelRatio: 3);
    final bytes = await data.toByteData(format: ImageByteFormat.png);
    final Uint8List signatureBytes = bytes!.buffer.asUint8List();

    // Get the position of the signature
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    // Navigate to the next screen and pass the signatureBytes, position, and new dimensions as parameters
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return SignatureOverlay(
            folderName: widget.folderName,
            index: widget.index,
            images: widget.images,
            signatureBytes: signatureBytes,
            signaturePosition: position,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xff192A36),
        actions: [
          TextButton(
              onPressed: _handleClearButtonPressed,
              child: Text(
                'Clear',
                style: TextStyle(color: Colors.white),
              )),
          TextButton(
              onPressed: _handleSaveButtonPressed,
              child: Text(
                'Save',
                style: TextStyle(color: Colors.white),
              )),
        ],
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Container(
              height: MediaQuery.of(context).size.height - 200,
              child: SfSignaturePad(
                key: signatureGlobalKey,
                backgroundColor: Colors.transparent,
                strokeColor: strokeColor,
                minimumStrokeWidth: 2.0,
                maximumStrokeWidth: 4.0,
              ),
              decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
            ),
          ),

          ControllerExample(updateStrokeColor: updateStrokeColor),
        ],
        crossAxisAlignment: CrossAxisAlignment.center,
      ),
    );
  }
}

// class SignaturePainter extends CustomPainter {
//   List<Offset?> points;

//   SignaturePainter(this.points);

//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint paint = Paint()
//       ..color = Colors.black
//       ..strokeCap = StrokeCap.round
//       ..strokeWidth = 5.0;

//     for (int i = 0; i < points.length - 1; i++) {
//       if (points[i] != null && points[i + 1] != null) {
//         canvas.drawLine(points[i]!, points[i + 1]!, paint);
//       }
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
// }
//   SignatureController controller = SignatureController(
//     penStrokeWidth: 1,
//     penColor: Colors.black,
//     exportBackgroundColor: Colors.transparent,
//     exportPenColor: Colors.black,
//     onDrawStart: () => log('onDrawStart called!'),
//     onDrawEnd: () => log('onDrawEnd called!'),
//
//   );
//   @override
//   void initState() {
//     super.initState();
//     controller.addListener(() => log('Value changed'));
//   }
//
//   @override
//   void dispose() {
//
//     controller.dispose();
//     super.dispose();
//   }
//
//   Future<void> exportImage(BuildContext context) async {
//     if (controller.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           key: Key('snackbarPNG'),
//           content: Text('No content'),
//         ),
//       );
//       return;
//     }
//
//     final Uint8List? data =
//     await controller.toPngBytes(height: 1000, width: 1000);
//     if (data == null) {
//       return;
//     }
//
//     if (!mounted) return;
//
//     await push(
//       context,
//       Scaffold(
//         appBar: AppBar(
//           title: const Text('PNG Image'),
//         ),
//         body: Center(
//           child: Container(
//             color: Colors.grey[300],
//             child: Image.memory(data),
//           ),
//         ),
//       ),
//     );
//   }
//   GlobalKey _globalKey = GlobalKey();
//
//   @override
//   Widget build(BuildContext context) {
//     final selectedImages = Provider.of<ImageListProvider>(context, listen: true)
//         .getImagesForItem(widget.folderName);
//     ImageListProvider imageListProvider =
//     Provider.of<ImageListProvider>(context, listen: true);
//     final image = selectedImages[widget.index];
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: IconThemeData(color: Colors.white),
//         backgroundColor: AppColors.primaryColor,
//         centerTitle: true,
//         title: const Text('Digital Signature',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.only(left:10,right: 10,top: 20),
//         child: Column(
//           children: [
//             SizedBox(height: 15,),
//             RepaintBoundary(
//               key: _globalKey,
//               child: Stack(
//                 children: [
//                   Container(
//                   height: 630,
//                   width: 600,
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                       image: FileImage(selectedImages[widget.index]), // Loading image from file
//                       fit: BoxFit.cover, // Adjusting the fit to cover the container
//                     ),
//                   ),
//                 ),
//                   Signature(
//                     controller: controller,
//                     height: 630,
//                     width: 390,
//                     backgroundColor: Colors.transparent,
//                   ),
//                 ],
//               ),
//             ),
//
//           ],
//         ),
//       ),
//       bottomNavigationBar: BottomAppBar(
//         color: Colors.white,
//         child: Container(
//           decoration: const BoxDecoration(color: AppColors.primaryColor),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             mainAxisSize: MainAxisSize.max,
//             children: <Widget>[
//               //SHOW EXPORTED IMAGE IN NEW ROUTE
//               IconButton(
//                 icon: const Icon(Icons.check),
//                 color: Colors.white,
//                 onPressed: () async{
//                                         final boundary = _globalKey.currentContext!
//                           .findRenderObject() as RenderRepaintBoundary;
//                       final image = await boundary.toImage(
//                         pixelRatio: 3, // Adjust pixelRatio as needed
//                       );
//
//                       final byteData =
//                           await image.toByteData(format: ImageByteFormat.png);
//                       final buffer = byteData!.buffer.asUint8List();
//
//                       // Decode the buffer into an img.Image
//                       final img.Image baseImage = img.decodeImage(buffer)!;
//
//                       // Check if the signature is visible
//
//                       // Continue with the existing logic...
//
//                       // Now you have the merged image in the 'buffer' variable.
//                       // Create a temporary directory to store the merged image
//
//                       // Write the merged image data to the temporary file
//                       // Read the contents of the temporary file into a Uint8List
//                       Uint8List newImageBytes =
//                           Uint8List.fromList(await buffer);
//                       print(newImageBytes);
//                       final snackBar = SnackBar(
//                         content:
//                             Text('Signature Added'), // Your snackbar message
//                         duration: Duration(seconds: 2),
//                       );
//                       ScaffoldMessenger.of(context).showSnackBar(snackBar);
//                       // Now you can pass the newImageBytes to the updateImages method
//                                         imageListProvider.updateImages(
//                                           widget.folderName,
//                                           selectedImages[widget.index],
//                                           newImageBytes,
//                                         );
//                       Navigator.pop(context);
//                 },
//               ),
//
//               IconButton(
//                 icon: const Icon(Icons.undo),
//                 color: Colors.black,
//                 onPressed: () {
//                   setState(() => controller.undo());
//                 },
//                 tooltip: 'Undo',
//               ),
//               IconButton(
//                 icon: const Icon(Icons.redo),
//                 color: Colors.white,
//                 onPressed: () {
//                   setState(() => controller.redo());
//                 },
//                 tooltip: 'Redo',
//               ),
//               //CLEAR CANVAS
//               IconButton(
//                 key: const Key('clear'),
//                 icon: const Icon(Icons.clear),
//                 color: Colors.white,
//                 onPressed: () {
//                   setState(() => controller.clear());
//                 },
//                 tooltip: 'Clear',
//               ),
//               // STOP Edit
//               IconButton(
//                 key: const Key('stop'),
//                 icon: Icon(
//                   controller.disabled ? Icons.pause : Icons.play_arrow,
//                 ),
//                 color: Colors.white,
//                 onPressed: () {
//                   setState(() => controller.disabled = !controller.disabled);
//                 },
//                 tooltip: controller.disabled ? 'Pause' : 'Play',
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//   Future push(context, widget) {
//     return Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (BuildContext context) {
//           return widget;
//         },
//       ),
//     );
//   }
// }