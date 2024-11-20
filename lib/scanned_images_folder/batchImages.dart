import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scanner/management/provider_image.dart';

class batchImages extends StatefulWidget {
  final String value;
  const batchImages({super.key, required this.value});

  @override
  State<batchImages> createState() => _batchImagesState();
}

class _batchImagesState extends State<batchImages> {
  @override
  Widget build(BuildContext context) {
    final imageProvider =
        Provider.of<ImageListProvider>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          actions: [Text(widget.value)],
          centerTitle: true,
        ),
        body: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: imageProvider.images.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                // Perform actions when an image is tapped
                // For example: Navigator.push or any other action
              },
              child: Image.file(
                imageProvider.images[index],
                fit: BoxFit.cover, // Adjust the fit as per your requirement
              ),
            );
          },
        ));
  }
}
