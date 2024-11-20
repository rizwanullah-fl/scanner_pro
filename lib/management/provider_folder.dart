import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:scanner/management/provider_image.dart';

class DataProvider with ChangeNotifier {
  List<String> items = [];
  final String fileName = 'data.json'; // File name for saving data

  DataProvider() {
    _loadItems();
  }

  Future<void> _loadItems() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final file = File('${appDir.path}/$fileName');

      if (file.existsSync()) {
        final jsonString = await file.readAsString();
        final List<dynamic> jsonData = json.decode(jsonString);
        items = jsonData.map((item) => item.toString()).toList();
        notifyListeners();
      }
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  Future<void> _saveItems() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final file = File('${appDir.path}/$fileName');
      final jsonString = json.encode(items);
      await file.writeAsString(jsonString);
      await _loadItems();
    } catch (e) {
      print('Error saving data: $e');
    }
  }

  Future<void> addItem(String name) async {
    items.add(name);
    notifyListeners();
    await _saveItems();
  }

  bool removeItem(int index,BuildContext context) {
    if (index >= 0 && index < items.length) {
      String removedItem = items.removeAt(index); // Store the removed item
      // Delete associated images
      final imageListProvider = Provider.of<ImageListProvider>(context, listen: false);
      final List<File> associatedImages = imageListProvider.getImagesForItem(removedItem);
      if (associatedImages.isNotEmpty) {
        associatedImages.forEach((image) {
          image.deleteSync(); // Delete the image file
        });
        imageListProvider.deleteImagesForItem(removedItem); // Delete images from ImageListProvider
      }
      notifyListeners(); // Notify listeners of the change
      _saveItems(); // Save the updated list
      // Return true to indicate successful removal
      return true;
    }
    // Return false if removal was not successful
    return false;
  }

  void updateItemName(String oldName, String newName,BuildContext context) {
    final index = items.indexOf(oldName);
    if (index != -1) {
      final String oldItem = items[index];
      items[index] = newName;
      notifyListeners();
      _saveItems();

      // Check if the item name has actually changed
      if (oldItem != newName) {
        // Update associated images if any
        final imageListProvider = Provider.of<ImageListProvider>(context, listen: false);
        final List<File> associatedImages = imageListProvider.getImagesForItem(oldItem);
        if (associatedImages.isNotEmpty) {
          // imageListProvider.deleteImagesForItem(oldItem);
          imageListProvider.addImagesForItem(newName, associatedImages);
        }
      }
    }
  }
  Future isNameExists(String name) async {
    await _loadItems();
    return items.contains(name);
  }

}
