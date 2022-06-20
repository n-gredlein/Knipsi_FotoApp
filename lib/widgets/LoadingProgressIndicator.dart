import 'package:flutter/material.dart';
import 'package:fotoapp/AppColors.dart';

class LoadingProgressIndicator extends StatelessWidget {
  LoadingProgressIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      color: AppColors.primaryColor,
    );
  }
}
