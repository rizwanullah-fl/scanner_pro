import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyProgressDialog {
  static show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Set this to false to make the dialog not clickable
      builder: (context) {
        return Container(
          child: Center(
            child: CircularProgressIndicator(
              color: Color(0xFF009B79),
            ),
          ),
        );
      },
    );
  }
}
