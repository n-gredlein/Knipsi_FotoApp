import 'package:flutter/material.dart';
import 'package:fotoapp/custom_icons.dart';
import 'package:fotoapp/services/AuthService.dart';
import 'package:fotoapp/services/DatabaseService.dart';
import 'package:fotoapp/widgets/TextButtonIcon.dart';
import "package:flutter_feather_icons/flutter_feather_icons.dart";

import '../AppColors.dart';
import '../AppRoutes.dart';
import '../arguments/PhotoChallengeArguments.dart';

DatabaseService service = DatabaseService();
AuthService authService = AuthService();

class MiniPhotoCard extends StatelessWidget {
  final String text;
  final String subtext;
  final String photoChallengeId;
  final bool saved;
  final bool done;

  MiniPhotoCard({
    Key? key,
    required this.text,
    required this.subtext,
    required this.photoChallengeId,
    required this.saved,
    required this.done,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 2,
        shadowColor: AppColors.secundaryColor,
        margin: EdgeInsets.only(right: 10, top: 10, bottom: 10),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Container(
          width: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 130,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0)),
                    image: DecorationImage(
                      image: AssetImage("assets/images/testbild.jpg"),
                      fit: BoxFit.cover,
                    )),
              ),
              Container(
                margin:
                    EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
                child: Text(text, style: Theme.of(context).textTheme.headline3),
              ),
              Container(
                margin: EdgeInsets.only(left: 10, right: 10, bottom: 5),
                child: Text(subtext),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 10),
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
                          ? Navigator.pushNamed(
                              context, AppRoutes.doneChallenge,
                              arguments:
                                  PhotoChallengeArguments(photoChallengeId))
                          : Navigator.pushNamed(
                              context,
                              AppRoutes.photoChallenge,
                              arguments:
                                  PhotoChallengeArguments(photoChallengeId),
                            ),
                    ),
                  )
                ],
              )
            ],
          ),
        ));
  }
}
