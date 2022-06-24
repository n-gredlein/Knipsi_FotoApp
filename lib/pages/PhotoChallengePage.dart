import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:fotoapp/AppColors.dart';
import 'package:fotoapp/arguments/PhotoChallengeArguments.dart';
import 'package:fotoapp/arguments/PhotoChallengeGenreArguments.dart';
import 'package:fotoapp/custom_icons.dart';
import 'package:fotoapp/services/AuthService.dart';
import 'package:fotoapp/widgets/AppBarTop.dart';
import 'package:fotoapp/widgets/Button1.dart';
import 'package:fotoapp/widgets/FABMenu.dart';
import 'package:fotoapp/widgets/PhotoCard.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:http/http.dart' as http;

import '../AppRoutes.dart';
import '../datamodels/Photo.dart';
import '../datamodels/PhotoChallenge.dart';
import '../services/DatabaseService.dart';
import '../widgets/LoadingProgressIndicator.dart';
import '../widgets/RatingCard.dart';

DatabaseService service = DatabaseService();
AuthService authService = AuthService();

class PhotoChallengePage extends StatelessWidget {
  static const routeName = AppRoutes.photoChallenge;

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as PhotoChallengeArguments;

    return StreamBuilder<List<PhotoChallenge>>(
        stream: service.readPhotoChallengeId(args.photoChallengeId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Ups! Es ist etwas falsch gelaufen. ${snapshot.error}');
          } else if (snapshot.hasData) {
            final photoChallenge = snapshot.data![0];
            return photoChallenge == null
                ? Center(child: Text('No PhotoChallenge'))
                : Scaffold(
                    floatingActionButton: FABMenu(
                      icons: [
                        Icon(FeatherIcons.upload),
                        Icon(FeatherIcons.instagram)
                      ],
                      onTap: [
                        () => Navigator.pushNamed(context, AppRoutes.upload,
                            arguments: PhotoChallengeGenreArguments(
                                photoChallenge.id, photoChallenge.genre)),
                        () async {
                          final urlImage = photoChallenge.titlePhoto;
                          final url = Uri.parse(urlImage);
                          final response = await http.get(url);
                          final bytes = response.bodyBytes;

                          final temp = await getTemporaryDirectory();
                          final path = '${temp.path}/image.jpg';
                          File(path).writeAsBytesSync(bytes);

                          await Share.shareFiles([path],
                              text:
                                  'Lust auf eine Fotochallenge zum Thema ${photoChallenge.title}? #becreativewithKNIPSI');
                        },
                      ],
                    ),
                    body: CustomScrollView(
                      slivers: <Widget>[
                        SliverAppBar(
                          elevation: 2,
                          centerTitle: true,
                          shadowColor: AppColors.secundaryColor,
                          title: Text(photoChallenge.title,
                              style: TextStyle(
                                  fontFamily: 'Sora-Bold', fontSize: 16)),
                          leading: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(FeatherIcons.arrowLeft),
                          ),
                          backgroundColor: AppColors.backgroundColorWhite,
                          foregroundColor: AppColors.textBlack,
                          pinned: true,
                          expandedHeight: 260.0,
                          flexibleSpace: const FlexibleSpaceBar(
                            expandedTitleScale: 2,
                            background: Image(
                              image: AssetImage("assets/images/testbild.jpg"),
                              fit: BoxFit.cover,
                            ),
                            centerTitle: true,
                          ),
                        ),
                        SliverList(
                            delegate: SliverChildListDelegate([
                          Container(
                              margin: EdgeInsets.all(10),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Align(
                                        alignment: Alignment.topRight,
                                        child: IconButton(
                                            onPressed: () {
                                              photoChallenge.usersSaved!
                                                      .contains(authService
                                                          .getCurrentUserEmail())
                                                  ? service
                                                      .removeSavedPhotoChallenge(
                                                      photoChallenge.id,
                                                    )
                                                  : service
                                                      .addSavedPhotoChallenge(
                                                      photoChallenge.id,
                                                    );
                                            },
                                            icon: photoChallenge.usersSaved!
                                                    .contains(authService
                                                        .getCurrentUserEmail())
                                                ? Icon(
                                                    CustomIcons.bookmark,
                                                    color:
                                                        AppColors.primaryColor,
                                                  )
                                                : Icon(FeatherIcons.bookmark))),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      photoChallenge.title,
                                      style:
                                          Theme.of(context).textTheme.headline1,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(photoChallenge.description),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Card(
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        shadowColor: AppColors.secundaryColor,
                                        color: AppColors.backgroundColorYellow,
                                        child: Container(
                                            padding: EdgeInsets.all(10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(
                                                      FeatherIcons.info,
                                                      size: 23,
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      "Tipp",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline3,
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(photoChallenge.tipp),
                                              ],
                                            ))),
                                    SizedBox(
                                      height: 40,
                                    ),
                                    Text(
                                      "Inspiration",
                                      style:
                                          Theme.of(context).textTheme.headline2,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                        height: 307,
                                        child: StreamBuilder<List<Photo>>(
                                            stream: service
                                                .readPhotosPhotoChallenge(
                                                    args.photoChallengeId),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasError) {
                                                return Text(
                                                    'Ups! Da ist etwas falsch gelaufen ${snapshot.error}');
                                              } else if (snapshot.hasData) {
                                                final photos = snapshot.data!;
                                                if (photos.length == 0) {
                                                  return Center(
                                                      child: Text(
                                                          'Es wurden noch keine Fotos hochgeladen.'));
                                                } else if (photos.length > 0 &&
                                                    photos.length < 3) {
                                                  return GridView.builder(
                                                    shrinkWrap: true,
                                                    itemCount: photos.length,
                                                    gridDelegate:
                                                        SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount:
                                                          photos.length,
                                                      crossAxisSpacing: 5,
                                                      mainAxisSpacing: 5,
                                                    ),
                                                    itemBuilder:
                                                        (context, index) {
                                                      var r;
                                                      if (photos[index]
                                                                  .ratings?[
                                                              authService
                                                                  .getCurrentUserEmail()
                                                                  .replaceAll(
                                                                      '.',
                                                                      '_')] ==
                                                          null) {
                                                        r = 0.0;
                                                      } else {
                                                        r = photos[index]
                                                            .ratings?[authService
                                                                .getCurrentUserEmail()
                                                                .replaceAll(
                                                                    '.', '_')]
                                                            .toDouble();
                                                      }
                                                      return RatingCard(
                                                          imgUrl: photos[index]
                                                              .photoUrl,
                                                          rate: r,
                                                          photoId:
                                                              photos[index].id);
                                                    },
                                                  );
                                                } else {
                                                  return Column(children: [
                                                    Container(
                                                        height: 259,
                                                        child: GridView.builder(
                                                          shrinkWrap: true,
                                                          itemCount: 2,
                                                          gridDelegate:
                                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                            crossAxisCount: 2,
                                                            crossAxisSpacing: 5,
                                                            mainAxisSpacing: 5,
                                                          ),
                                                          itemBuilder:
                                                              (context, index) {
                                                            var r;
                                                            if (photos[index]
                                                                        .ratings?[
                                                                    authService
                                                                        .getCurrentUserEmail()
                                                                        .replaceAll(
                                                                            '.',
                                                                            '_')] ==
                                                                null) {
                                                              r = 0.0;
                                                            } else {
                                                              r = photos[index]
                                                                  .ratings?[authService
                                                                      .getCurrentUserEmail()
                                                                      .replaceAll(
                                                                          '.',
                                                                          '_')]
                                                                  .toDouble();
                                                            }
                                                            return RatingCard(
                                                                imgUrl: photos[
                                                                        index]
                                                                    .photoUrl,
                                                                rate: 2,
                                                                photoId: photos[
                                                                        index]
                                                                    .id);
                                                          },
                                                        )),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Center(
                                                      child: Button1(
                                                        text: "Mehr anzeigen",
                                                        color: AppColors
                                                            .secundaryColor,
                                                        onPressed: () =>
                                                            Navigator.pushNamed(
                                                          context,
                                                          AppRoutes
                                                              .inspoChallenge,
                                                          arguments:
                                                              PhotoChallengeArguments(
                                                                  photoChallenge
                                                                      .id),
                                                        ),
                                                      ),
                                                    ),
                                                  ]);
                                                }
                                              } else {
                                                return Center(
                                                  child:
                                                      LoadingProgressIndicator(),
                                                );
                                              }
                                            })),
                                    Container(
                                      alignment: Alignment.bottomRight,
                                    )
                                  ]))
                        ])),
                      ],
                    ));
          } else {
            return Center(child: LoadingProgressIndicator());
          }
        });
  }
}
