import 'package:flutter/material.dart';

import '../AppColors.dart';

class AppBarTop extends StatelessWidget {
  final Color backgroundColor = Colors.red;
  final Text title;

  final bool backButton;

  const AppBarTop({Key? key, required this.title, required this.backButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        /* elevation: 2,
      shadowColor: AppColors.secundaryColor,
      title: title,
      backgroundColor: backgroundColor,
      leading: Container(
          child: backButton
              ? Text("Y is greater than or equal to 10")
              : Text("Y is less than 10")),*/
        );
  }
}
