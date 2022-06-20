import 'package:flutter/material.dart';
import 'package:fotoapp/AppColors.dart';

import '../AppRoutes.dart';

class TextbuttonIcon extends StatelessWidget {
  String text;
  Icon icon;
  final GestureTapCallback onPressed;

  TextbuttonIcon({
    Key? key,
    required this.icon,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text),
          SizedBox(
            width: 5,
          ),
          icon,
        ],
      ),
    );
  }
}
