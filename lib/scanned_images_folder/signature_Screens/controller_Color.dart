import 'package:flutter/material.dart';
import 'package:hsv_color_pickers/hsv_color_pickers.dart';

class ControllerExample extends StatefulWidget {
  final Function(Color) updateStrokeColor;

  const ControllerExample({Key? key, required this.updateStrokeColor})
      : super(key: key);

  @override
  State<ControllerExample> createState() => _ControllerExampleState();
}

class _ControllerExampleState extends State<ControllerExample> {
  late final HueController _controller;

  @override
  void initState() {
    super.initState();
    _controller = HueController(HSVColor.fromColor(Colors.green));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: HuePicker(
            controller: _controller,
            onChanged: (color) {
              widget.updateStrokeColor(
                  color.toColor()); // Convert HSVColor to Color
              setState(() {});
            },
            thumbShape: const HueSliderThumbShape(
              color: Colors.white,
              borderColor: Colors.black,
              filled: false,
              showBorder: true,
            ),
          ),
        ),
      ],
    );
  }
}
