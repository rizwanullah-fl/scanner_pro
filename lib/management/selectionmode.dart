import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:scanner/management/provider_folder.dart';
import 'package:scanner/management/provider_image.dart';
import 'package:scanner/scanned_images_folder/Maincolor.dart';
import 'package:scanner/scanned_images_folder/image_Screen.dart';
import 'package:scanner/scanned_images_folder/scan_folder.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/widgets.dart' as pw;

class SelectionModeScreen extends StatefulWidget {
  final List<String> items;
  final String selectedView;

  SelectionModeScreen({required this.items, required this.selectedView});

  @override
  _SelectionModeScreenState createState() => _SelectionModeScreenState();
}

class _SelectionModeScreenState extends State<SelectionModeScreen> {
  List<String> _selectedItems = [];

  // Function to share selected images as a PDF file
  void shareImagesAsPdf(List<String> selectedItems) async {
    // Create a PDF document
    final pdf = pw.Document();

    // Add items to the PDF document
    for (var item in selectedItems) {
      pdf.addPage(pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text(item),
          );
        },
      ));
    }
    void selectAll() {
      setState(() {
        _selectedItems = List.from(widget.items);
      });
    }

    // Save the PDF document to a temporary file
    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/selected_items.pdf');
    await tempFile.writeAsBytes(await pdf.save());

    // Share the PDF file
    Share.shareFiles([tempFile.path], text: 'Sharing selected items as PDF');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xff192A36),
        leading: IconButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => ScannedImagesScreen()),
              (Route<dynamic> route) => false,
            ).then((value) => print(widget.selectedView));
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(
          'Select Items',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          PopupMenuButton<int>(
            icon: Icon(Icons.more_vert, color: Colors.white),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Delete'),
                    Icon(
                      Icons.delete,
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
                    Text('All Select'),
                    Icon(
                      Icons.select_all,
                      color: Color(0xff192A36),
                    ),
                  ],
                ),
              ),
              // PopupMenuItem(
              //   value: 2,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Text('Share'),
              //       Icon(Icons.share,color: Color(0xff192A36),),
              //     ],
              //   ),
              // ),

              // Add more PopupMenuItems as needed
            ],
            onSelected: (value) {
              // Handle the selection here
              switch (value) {
                case 1:
                  setState(() {
                    final dataProvider =
                        Provider.of<DataProvider>(context, listen: false);
                    // Remove selected items from the DataProvider
                    _selectedItems.forEach((item) {
                      final index = dataProvider.items.indexOf(item);
                      if (index != -1) {
                        dataProvider.removeItem(index, context);
                      }
                    });
                    // Clear the selection
                    _selectedItems.clear();
                  });
                  break;
                case 2:
                  setState(() {
                    _selectedItems = List.from(widget.items);
                  });

                  break;
              }
            },
          )
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: getView(widget.selectedView),
          ),
        ],
      ),
    );
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

  Widget buildGridView(int crossAxisCount) {
    return Consumer<DataProvider>(
      builder: (context, dataProvider, child) {
        final items = dataProvider.items;

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 20, // Set to 0
              crossAxisSpacing: 0, // Set to 0
              childAspectRatio: 0.99),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final selectedChosenItem = items[index];
            final selectedImages = Provider.of<ImageListProvider>(
              context,
              listen: true,
            ).getImagesForItem(selectedChosenItem);

            return buildListItem(
                index, selectedChosenItem, selectedImages, items.length);
          },
        );
      },
    );
  }

  Widget buildListView() {
    return Consumer<DataProvider>(
      builder: (context, dataProvider, child) {
        final items = dataProvider.items;

        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final selectedChosenItem = items[index];
            final selectedImages = Provider.of<ImageListProvider>(
              context,
              listen: true,
            ).getImagesForItem(selectedChosenItem);

            return buildListItem(
                index, selectedChosenItem, selectedImages, items.length);
          },
        );
      },
    );
  }

  Widget buildListItem(int index, String selectedChosenItem,
      List<File> selectedImages, int index2) {
    return widget.selectedView.contains('GridView')
        ? InkWell(
            onTap: () {
              setState(() {
                if (_selectedItems.contains(widget.items[index])) {
                  _selectedItems.remove(widget.items[index]); // Deselect item
                } else {
                  _selectedItems.add(widget.items[index]); // Select item
                }
              });
            },
            child: Container(
              // Check if selectedView contains 'GridView'
              height: 200,
              width: 100,
              margin: EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.black,
                  width: 1.0, // Adjust the width as needed
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  selectedImages.isEmpty
                      ? Container(
                          margin: EdgeInsets.only(
                            top: widget.selectedView.contains('GridView 3')
                                ? 30
                                : 50,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.folder,
                              size: widget.selectedView.contains('GridView 3')
                                  ? 50
                                  : 80,
                              color: Color(0xff192A36),
                            ),
                          ),
                        )
                      : Image.file(
                          selectedImages[0],
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width,
                          height: widget.selectedView.contains('GridView 3')
                              ? 90
                              : 150,
                        ),
                  SizedBox(
                    height: widget.selectedView.contains('GridView 3') ? 5 : 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Checkbox(
                          activeColor: Colors.greenAccent,
                          checkColor: Colors.white,
                          visualDensity: const VisualDensity(
                              horizontal: -4.0, vertical: -4.0),
                          value: _selectedItems.contains(widget.items[index]),
                          onChanged: (value) {
                            setState(() {
                              if (value != null && value) {
                                _selectedItems
                                    .add(widget.items[index]); // Select item
                              } else {
                                _selectedItems.remove(
                                    widget.items[index]); // Deselect item
                              }
                            });
                          },
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            // hei,
                            width: widget.selectedView.contains('GridView 3')
                                ? 70
                                : 100,
                            alignment: Alignment.topRight,
                            margin: EdgeInsets.only(right: 10),
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
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              margin: EdgeInsets.only(right: 10),
                              width: 18,
                              height: widget.selectedView.contains('GridView 3')
                                  ? 16
                                  : 20,
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
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        : InkWell(
            onTap: () {
              setState(() {
                if (_selectedItems.contains(widget.items[index])) {
                  _selectedItems.remove(widget.items[index]); // Deselect item
                } else {
                  _selectedItems.add(widget.items[index]); // Select item
                }
              });
            },
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Checkbox(
                            activeColor: Colors.greenAccent,
                            checkColor: Colors.white,
                            value: _selectedItems.contains(widget.items[index]),
                            onChanged: (value) {
                              setState(() {
                                if (value != null && value) {
                                  _selectedItems
                                      .add(widget.items[index]); // Select item
                                } else {
                                  _selectedItems.remove(
                                      widget.items[index]); // Deselect item
                                }
                              });
                            },
                          ),
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
                    ],
                  ),
                  if (index != index2 - 1) Divider(),
                ],
              ),
            ),
          );
  }
}
