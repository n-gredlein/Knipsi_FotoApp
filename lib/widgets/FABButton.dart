import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fotoapp/AppColors.dart';

class FABButton extends StatelessWidget {
  Function() onTap;

  FABButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      icon: FeatherIcons.share2,
      elevation: 2,
      foregroundColor: AppColors.textBlack,
      activeForegroundColor: AppColors.textBlack,
      backgroundColor: AppColors.primaryColor,
      activeBackgroundColor: AppColors.secundaryColor,
      onOpen: onTap,
    );
  }
}
