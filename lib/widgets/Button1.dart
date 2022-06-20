import 'package:flutter/material.dart';
import 'package:fotoapp/AppColors.dart';

class Button1 extends StatelessWidget {
  bool? isResponsive;
  double? width;
  String text;
  Color color;
  final GestureTapCallback onPressed;

  Button1(
      {Key? key,
      this.width,
      this.isResponsive = false,
      required this.text,
      required this.color,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width,
        child: ElevatedButton(
          onPressed: onPressed,
          child: Text(text),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(this.color),
            foregroundColor:
                MaterialStateProperty.all<Color>(AppColors.textBlack),
            elevation: MaterialStateProperty.all<double>(0),
          ),
        ));
  }
}
