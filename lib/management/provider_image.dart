import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
class ImageListProvider with ChangeNotifier {
  List<File> _images = [];

  List<File> get images => _images;

  ImageListProvider() {
    // Load saved images from local storage when the provider is initialized
    loadImages();
  }

  Future<void> loadImages() async {
    final appDir = await getApplicationDocumentsDirectory();
    final imageDir = Directory('${appDir.path}/images');
    if (imageDir.existsSync()) {
      final imageFiles = imageDir.listSync();
      _images = imageFiles.map((file) => File(file.path)).toList();
      notifyListeners();
    }
  }

  Future<void> addImage(File image, String itemName) async {
    // Associate the image with the item name by naming the image file
    final appDir = await getApplicationDocumentsDirectory();
    final imageDir = Directory('${appDir.path}/images');
    if (!imageDir.existsSync()) {
      imageDir.createSync(recursive: true);
    }

    // Format the item name with a dash and timestamp
    final formattedItemName = '$itemName-${DateTime.now().millisecondsSinceEpoch}';
    final imagePath = '${imageDir.path}/$formattedItemName.jpg';

    // Copy the image to the specified path
    image.copy(imagePath);

    _images.add(File(imagePath));
    notifyListeners();
  }

  // Define a method to get images associated with a specific item
  List<File> getImagesForItem(String item) {
    return _images.where((image) => image.path.contains(item)).toList();
  }

  void deleteImage(File image) {
    _images.remove(image);
    notifyListeners();

    // Delete the image file from storage
    image.deleteSync();
  }

  void deleteImagesForItem(String itemName) {
    // Delete all images associated with the item
    _images.removeWhere((image) => image.path.contains(itemName));
    notifyListeners();
  }

  Future<void> updateImages(
      String itemName, File oldImage, Uint8List newImageBytes) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final imageDir = Directory('${appDir.path}/images');

      // Generate a unique filename for the new image
      final newImagePath =
          '${imageDir.path}/$itemName-${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Write the new image data to the specified path
      File newImageFile = File(newImagePath);
      await newImageFile.writeAsBytes(newImageBytes);
      print("New Image Bytes: $newImageBytes");
      print("Old Image: $oldImage");

      // Add the new image file to the _images list
      _images.add(newImageFile);
      print("Number of Images after update: ${_images.length}");

      // Remove the old image file if it exists
      if (oldImage.existsSync()) {
        oldImage.deleteSync(recursive: true);
        print("Old Image Deleted Successfully");

        // Remove the old image file from the _images list
        _images.remove(oldImage);
        print("Number of Images after removing old image: ${_images.length}");
      } else {
        print("Old Image does not exist.");
      }

      // Notify listeners to update the UI
      notifyListeners();
    } catch (e) {
      print("Error updating images: $e");
      // Handle or log the error as needed
    }
  }
  Future<void> addImagesForItem(String itemName, List<File> images) async {
    final appDir = await getApplicationDocumentsDirectory();
    final imageDir = Directory('${appDir.path}/images/$itemName');

    if (!imageDir.existsSync()) {
      imageDir.createSync(recursive: true);
    }

    images.forEach((image) {
      final String imagePath = '${imageDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      image.copy(imagePath);
      _images.add(File(imagePath));
    });

    notifyListeners();
  }

}
