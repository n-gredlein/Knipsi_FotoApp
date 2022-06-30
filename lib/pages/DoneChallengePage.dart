import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:fotoapp/AppColors.dart';
import 'package:fotoapp/services/AuthService.dart';
import 'package:fotoapp/widgets/AppBarTop.dart';
import 'package:fotoapp/widgets/Button1.dart';
import 'package:fotoapp/widgets/FABMenu.dart';
import 'package:fotoapp/widgets/FABButton.dart';
import 'package:fotoapp/widgets/PhotoCard.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:http/http.dart' as http;
import '../AppRoutes.dart';
import '../arguments/PhotoChallengeArguments.dart';
import '../arguments/PhotoChallengeGenreArguments.dart';
import '../datamodels/Photo.dart';
import '../datamodels/PhotoChallenge.dart';
import '../services/DatabaseService.dart';
import '../widgets/LoadingProgressIndicator.dart';
import '../widgets/RatingCard.dart';

DatabaseService service = DatabaseService();
AuthService authService = AuthService();

class DoneChallengePage extends StatefulWidget {
  @override
  _DoneChallengePageState createState() => _DoneChallengePageState();
}

class _DoneChallengePageState extends State<DoneChallengePage> {
  bool deleted = false;
  OverlayEntry? entry;
  bool view = false;

  void delte() {
    setState(() {
      deleted = true;
    });
  }

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
                    floatingActionButton: StreamBuilder<List<Photo>>(
                        stream: service
                            .readPhotoByPhotoChallengeId(photoChallenge.id),
                        builder: (context, snapshot) {
                          if (deleted == false) {
                            return FABButton(onTap: () async {
                              final photo = snapshot.data![0];
                              final urlImage = photo.photoUrl;
                              final url = Uri.parse(urlImage);
                              final response = await http.get(url);
                              final bytes = response.bodyBytes;

                              final temp = await getTemporaryDirectory();
                              final path = '${temp.path}/image.jpg';
                              File(path).writeAsBytesSync(bytes);

                              await Share.shareFiles([path],
                                  text:
                                      'Das ist meine Knipsi-Fotochallenge zum Thema: ${photoChallenge.title}. #becreativewithKNIPSI');
                            });
                          } else {
                            return SizedBox();
                          }
                        }),
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
                              Navigator.pushNamed(context, AppRoutes.main);
                            },
                            icon: Icon(FeatherIcons.arrowLeft),
                          ),
                          backgroundColor: AppColors.backgroundColorWhite,
                          foregroundColor: AppColors.textBlack,
                          pinned: true,
                          expandedHeight: 260.0,
                          flexibleSpace: FlexibleSpaceBar(
                            expandedTitleScale: 2,
                            background: Image(
                              image: CachedNetworkImageProvider(
                                  photoChallenge.titlePhoto),
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
                                    ),
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
                                    Container(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 20,
                                        ),
                                        if (deleted == false)
                                          StreamBuilder<List<Photo>>(
                                              stream: service
                                                  .readPhotoByPhotoChallengeId(
                                                      photoChallenge.id),
                                              builder: (context, snapshot) {
                                                if (snapshot.hasError) {
                                                  return Text(
                                                      'Ups! Es ist etwas falsch gelaufen. ${snapshot.error}');
                                                } else if (snapshot.hasData) {
                                                  if (snapshot.data![0] ==
                                                      null) {
                                                    delte();
                                                    return SizedBox();
                                                  } else {
                                                    final photo =
                                                        snapshot.data![0];
                                                    return Container(
                                                        margin: EdgeInsets.only(
                                                            bottom: 70),
                                                        child: Card(
                                                          elevation: 2,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          20))),
                                                          shadowColor: AppColors
                                                              .secundaryColor,
                                                          child: Column(
                                                            children: [
                                                              buildImage(photo
                                                                  .photoUrl),
                                                              Container(
                                                                  margin:
                                                                      EdgeInsets
                                                                          .all(
                                                                              10),
                                                                  child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Container(
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Icon(
                                                                                FeatherIcons.star,
                                                                                size: 40,
                                                                              ),
                                                                              SizedBox(
                                                                                width: 10,
                                                                              ),
                                                                              if (photo.ratings != null)
                                                                                Text(((photo.ratings!.values.reduce((value, element) => value + element) / photo.ratings!.length).round().toString()) + '/5'),
                                                                              if (photo.ratings == null)
                                                                                Text('Keine Bewertung'),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          padding:
                                                                              EdgeInsets.all(15),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                AppColors.secundaryColor,
                                                                            borderRadius:
                                                                                BorderRadius.circular(100),
                                                                          ),
                                                                          child: IconButton(
                                                                              onPressed: () {
                                                                                service.removeDonePhotoChallenge(args.photoChallengeId);
                                                                                FirebaseStorage.instance.refFromURL(photo.photoUrl).delete();
                                                                                service.deletePhoto(photo.id);
                                                                                delte();
                                                                              },
                                                                              icon: Icon(FeatherIcons.trash)),
                                                                        )
                                                                      ])),
                                                            ],
                                                          ),
                                                        ));
                                                  }
                                                } else {
                                                  return Center(
                                                      child:
                                                          LoadingProgressIndicator());
                                                }
                                              })
                                        else
                                          Column(
                                            children: [
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Center(
                                                child: Text(
                                                    'Das Foto wurde erfolgreich gelöscht.'),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Button1(
                                                  text: 'Neues Foto hochladen',
                                                  color: AppColors.primaryColor,
                                                  onPressed: () {
                                                    Navigator.pushNamed(
                                                      context,
                                                      AppRoutes.upload,
                                                      arguments:
                                                          PhotoChallengeGenreArguments(
                                                              photoChallenge.id,
                                                              photoChallenge
                                                                  .genre),
                                                    );
                                                  }),
                                            ],
                                          )
                                      ],
                                    )),
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

  Widget buildImage(photoUrl) {
    return GestureDetector(
      onTap: () {
        showOverlay(context, photoUrl);
      },
      child: Container(
        height: 200.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0)),
            image: DecorationImage(
              image: NetworkImage(photoUrl),
              fit: BoxFit.cover,
            )),
      ),
    );
  }

  void showOverlay(BuildContext context, photoUrl) {
    final renderBox = context.findRenderObject()! as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final size = MediaQuery.of(context).size;

    entry = OverlayEntry(builder: (context) {
      return Stack(children: <Widget>[
        Positioned.fill(
          child: Container(color: AppColors.textBlack.withOpacity(0.7)),
        ),
        Center(
          child: GestureDetector(
              onTap: removeOverlay,
              child:
                  Container(width: size.width, child: Image.network(photoUrl))),
        )
      ]);
    });

    final overlay = Overlay.of(context)!;
    overlay.insert(entry!);
  }

  void removeOverlay() {
    entry?.remove();
    entry = null;
  }
}



/*SizedBox(
                          height: 20,
                        ),
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          shadowColor: AppColors.secundaryColor,
                          child: Column(
                            children: [
                              Container(
                                height: 200.0,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20.0),
                                        topRight: Radius.circular(20.0)),
                                    image: DecorationImage(
                                      image: AssetImage(
                                          "assets/images/testbild.jpg"),
                                      fit: BoxFit.cover,
                                    )),
                              ),
                              Container(
                                  margin: EdgeInsets.all(10),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          child: Row(
                                            children: [
                                              Icon(Icons.star),
                                              Text("4,5/10"),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          color: AppColors.primaryColor,
                                          child: IconButton(
                                              onPressed: () {},
                                              icon: Icon(Icons.delete)),
                                        )
                                      ])),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),*/

                        