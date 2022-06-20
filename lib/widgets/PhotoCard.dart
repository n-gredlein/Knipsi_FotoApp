import 'package:flutter/material.dart';
import 'package:fotoapp/AppColors.dart';
import 'package:fotoapp/arguments/PhotoChallengeArguments.dart';
import 'package:fotoapp/custom_icons.dart';
import 'package:fotoapp/services/DatabaseService.dart';
import 'package:fotoapp/widgets/TextButtonIcon.dart';
import "package:flutter_feather_icons/flutter_feather_icons.dart";

import '../AppRoutes.dart';

DatabaseService service = DatabaseService();

class PhotoCard extends StatelessWidget {
  final String text;
  final String subtext;
  final String photoChallengeId;
  final bool saved;
  final String imgUrl;
  final bool done;

  //final Image image;
  PhotoCard({
    Key? key,
    required this.text,
    required this.subtext,
    required this.photoChallengeId,
    required this.saved,
    required this.imgUrl,
    required this.done,
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
                  image: NetworkImage(imgUrl),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  padding: EdgeInsets.all(20.0),
                  child: IconButton(
                      onPressed: () {
                        saved
                            ? service.removeSavedPhotoChallenge(
                                photoChallengeId,
                              )
                            : service.addSavedPhotoChallenge(
                                photoChallengeId,
                              );
                      },
                      icon: saved
                          ? Icon(
                              CustomIcons.bookmark,
                              color: AppColors.primaryColor,
                            )
                          : Icon(FeatherIcons.bookmark))),
              Container(
                padding: EdgeInsets.all(20.0),
                child: TextbuttonIcon(
                  icon: Icon(FeatherIcons.chevronRight),
                  text: "Mehr",
                  onPressed: () => done
                      ? Navigator.pushNamed(context, AppRoutes.doneChallenge,
                          arguments: PhotoChallengeArguments(photoChallengeId))
                      : Navigator.pushNamed(
                          context,
                          AppRoutes.photoChallenge,
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
