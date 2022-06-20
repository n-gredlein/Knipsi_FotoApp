import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fotoapp/AppColors.dart';

class FABMenu extends StatelessWidget {
  List<Icon> icons;
  List<Function()> onTap;

  FABMenu({
    Key? key,
    required this.icons,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      icon: FeatherIcons.plus,
      activeIcon: FeatherIcons.x,
      elevation: 2,
      foregroundColor: AppColors.textBlack,
      activeForegroundColor: AppColors.textBlack,
      backgroundColor: AppColors.primaryColor,
      activeBackgroundColor: AppColors.secundaryColor,
      children: List.generate(icons.length, (index) {
        return SpeedDialChild(
          child: icons[index],
          backgroundColor: AppColors.primaryColor,
          onTap: onTap[index],
        );
      }),
    );
  }
}
