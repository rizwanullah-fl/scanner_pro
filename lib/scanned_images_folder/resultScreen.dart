import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ResultScreen extends StatelessWidget {
  final String text;

  const ResultScreen({super.key, required this.text});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Result'),
          centerTitle: true,
          actions: [
            TextButton(
              child: Text('Copy'),
              onPressed: () {
                // Implement copy functionality here
                Clipboard.setData(ClipboardData(text: text));

                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Copied to clipboard'),
                    duration: Duration(seconds: 2),
                  ),
                );
                // Optionally, show a toast/snackbar to indicate copied text
              },
            ),
          ],
        ),
        body: Container(
          padding: const EdgeInsets.all(30.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  text,
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
        ),
      );
}
