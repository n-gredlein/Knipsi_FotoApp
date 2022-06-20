import 'package:flutter/material.dart';

class Text1 extends StatelessWidget {
  double size;
  final String text;
  final Color color;
  Text1(
      {Key? key, this.size = 16, required this.text, this.color = Colors.black})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: color, fontSize: size, fontWeight: FontWeight.normal),
    );
  }
}
