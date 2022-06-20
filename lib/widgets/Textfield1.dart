import 'package:flutter/material.dart';
import 'package:fotoapp/AppColors.dart';

class Textfield1 extends StatelessWidget {
  String text;
  IconData icon;

  Textfield1({Key? key, required this.text, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
        decoration: InputDecoration(
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(
          color: AppColors.textGrey,
          width: 1.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(
          color: AppColors.primaryColor,
          width: 2.0,
        ),
      ),
      hintText: text,
      prefixIcon: Icon(
        icon,
        color: AppColors.textGrey,
      ),
    ));
  }
}
