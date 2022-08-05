import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import '../AppColors.dart';

class ChipFilter extends StatefulWidget {
  @override
  _ChipFilterState createState() => _ChipFilterState();

  String genre;
  String filter = '';
  bool selected = false;

  ChipFilter({Key? key, required this.genre}) : super(key: key);
}

class _ChipFilterState extends State<ChipFilter> {
  @override
  Widget build(BuildContext context) {
    return FilterChip(
        showCheckmark: false,
        label: Text(widget.genre),
        selected: widget.selected,
        selectedColor: AppColors.primaryColor,
        backgroundColor: AppColors.secundaryColor,
        shadowColor: null,
        selectedShadowColor: AppColors.backgroundColorYellow,
        avatar: (widget.selected) ? Icon(FeatherIcons.check) : null,
        onSelected: (bool selected) {
          setState(() {
            widget.filter = widget.genre;
            widget.selected ? widget.selected = false : widget.selected = true;
          });
        });
  }
}
