import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fotoapp/AppColors.dart';
import 'package:fotoapp/arguments/PhotoChallengeArguments.dart';
import 'package:fotoapp/widgets/TextButtonIcon.dart';
import "package:flutter_feather_icons/flutter_feather_icons.dart";

import '../AppRoutes.dart';

class DonePhotoCard extends StatelessWidget {
  final String text;
  final String subtext;
  final String photoChallengeId;
  final String imgUrl;

  DonePhotoCard({
    Key? key,
    required this.text,
    required this.subtext,
    required this.photoChallengeId,
    required this.imgUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: AppColors.secundaryColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0)),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(imgUrl),
                  fit: BoxFit.cover,
                )),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 5),
            alignment: Alignment.centerLeft,
            child: Text(text, style: Theme.of(context).textTheme.headline2),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, bottom: 0),
            alignment: Alignment.centerLeft,
            child: Text(subtext),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.all(20.0),
                child: TextbuttonIcon(
                  icon: Icon(FeatherIcons.chevronRight),
                  text: "Mehr",
                  onPressed: () => Navigator.pushNamed(
                    context,
                    AppRoutes.doneChallenge,
                    arguments: PhotoChallengeArguments(photoChallengeId),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
