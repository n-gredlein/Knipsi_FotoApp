import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fotoapp/AppColors.dart';
import 'package:fotoapp/arguments/PhotoChallengeArguments.dart';
import 'package:fotoapp/datamodels/PhotoChallenge.dart';
import 'package:fotoapp/services/AuthService.dart';
import 'package:fotoapp/widgets/PhotoCard.dart';
import '../../datamodels/Genre.dart';
import '../../datamodels/Userdb.dart';
import '../../services/DatabaseService.dart';
import '../../widgets/LoadingProgressIndicator.dart';
import '../../widgets/MiniPhotoCard.dart';
import '../PhotoChallengePage.dart';

final auth = FirebaseAuth.instance;
DatabaseService service = DatabaseService();
AuthService authService = AuthService();

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final controller = TextEditingController();

  get firestoreInstance => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 2,
          shadowColor: AppColors.secundaryColor,
          title: Container(
              margin: EdgeInsets.only(left: 10),
              child: Image(
                height: 30,
                image: AssetImage("assets/images/LogoWithName.png"),
              )),
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                decoration:
                    BoxDecoration(color: AppColors.backgroundColorYellow),
                child: Column(children: [
                  Container(
                    padding: EdgeInsets.only(top: 20),
                    margin: EdgeInsets.only(left: 10),
                    child: Text(
                      "Aktuelle Fotochallenge",
                      style: Theme.of(context).textTheme.headline1,
                    ),
                  ),
                  /*FutureBuilder(
                      future: photochallengesList,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<PhotoChallenge>> snapshot) {
                        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                          return Text(
                              "${retrievedPhotochallengeById!.title.toString()}");
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      }),*/
                  Container(
                    padding: EdgeInsets.only(
                        top: 20, bottom: 20, left: 10, right: 10),
                    child: StreamBuilder<List<PhotoChallenge>>(
                        stream: service
                            .readPhotoChallengeId('3Bunk5d0pYl9MNnkecSr'),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text(
                                'Ups! Es ist etwas falsch gelaufen. ${snapshot.error}');
                          } else if (snapshot.hasData) {
                            final photoChallenge = snapshot.data![0];

                            return photoChallenge == null
                                ? Center(child: Text('No PhotoChallenge'))
                                : PhotoCard(
                                    text: photoChallenge.title,
                                    subtext: photoChallenge.shortDescription,
                                    photoChallengeId: '3Bunk5d0pYl9MNnkecSr',
                                    saved: photoChallenge.usersSaved!.contains(
                                        authService.getCurrentUserEmail()),
                                    done: photoChallenge.usersDone!.contains(
                                        authService.getCurrentUserEmail()),
                                    imgUrl: photoChallenge.titlePhoto,
                                  );
                          } else {
                            return Center(child: LoadingProgressIndicator());
                          }
                        }),
                  ),
                ])),
            SizedBox(
              height: 40,
            ),
            Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Text(
                "Weitere Fotochallenges",
                style: Theme.of(context).textTheme.headline2,
              ),
            ),
            StreamBuilder<List<Genre>>(
                stream: service.readGenres(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text(
                        'Ups! Da ist etwas falsch gelaufen ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    final genres = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: genres.length,
                      itemBuilder: (context, i) {
                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                  top: 20,
                                  left: 10,
                                  right: 10,
                                ),
                                child: Text(
                                  genres[i].name.toString(),
                                  style: Theme.of(context).textTheme.headline3,
                                ),
                              ),
                              StreamBuilder<List<PhotoChallenge>>(
                                  stream: service
                                      .readPhotoChallengesGenre(genres[i].id),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Text(
                                          'Ups! Da ist etwas falsch gelaufen ${snapshot.error}');
                                    } else if (snapshot.hasData) {
                                      final photoChallenges = snapshot.data!;
                                      return Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          height: 307.0,
                                          child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: photoChallenges.length,
                                              itemBuilder: (context, i) {
                                                return MiniPhotoCard(
                                                    text:
                                                        '${photoChallenges[i].title.toString()}',
                                                    subtext:
                                                        '${photoChallenges[i].shortDescription.toString()}',
                                                    photoChallengeId:
                                                        '${photoChallenges[i].id.toString()}',
                                                    saved: photoChallenges[i]
                                                        .usersSaved!
                                                        .contains(authService
                                                            .getCurrentUserEmail()),
                                                    done: photoChallenges[i]
                                                        .usersDone!
                                                        .contains(authService
                                                            .getCurrentUserEmail()));
                                              }));
                                    } else {
                                      return Center(
                                        child: LoadingProgressIndicator(),
                                      );
                                    }
                                  }),
                            ]);
                      },
                    );
                  } else {
                    return Center(
                      child: LoadingProgressIndicator(),
                    );
                  }
                }),

            /*child: FutureBuilder(
                  future: genreList,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Genre>> snapshot) {
                    if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      return Expanded(
                          child: ListView.builder(
                        itemCount: retrievedGenreList!.length,
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                  top: 10,
                                ),
                                child: Text(
                                  "${retrievedGenreList![index].name.toString()}",
                                  style: Theme.of(context).textTheme.headline3,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Container(
                                  height: 332,
                                  child: FutureBuilder(
                                      future: photochallengesList,
                                      builder: (BuildContext context,
                                          AsyncSnapshot<List<PhotoChallenge>>
                                              snapshot) {
                                        if (snapshot.hasData &&
                                            snapshot.data!.isNotEmpty) {
                                          return Expanded(
                                            child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                padding: EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                ),
                                                itemCount: 3,
                                                itemBuilder: (context, index) {
                                                  if (retrievedPhotochallengesList![
                                                              index]
                                                          .categoryId ==
                                                      retrievedGenreList![index]
                                                          .id) {
                                                    return MiniPhotoCard(
                                                        text:
                                                            "${retrievedPhotochallengesList![index].title.toString()}",
                                                        subtext:
                                                            "${retrievedPhotochallengesList![index].shortDescription.toString()}");
                                                  } else {
                                                    return Container();
                                                  }
                                                }),
                                          );
                                        } else {
                                          return const Center(
                                              child:
                                                  CircularProgressIndicator());
                                        }
                                      })),
                            ],
                          );
                        },
                      ));
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  }),*/

            TextField(
              controller: controller,
            ),
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  //final name = controller.text;
                  final user = PhotoChallenge(
                      title: 'title',
                      shortDescription: 'shortDescription',
                      description: 'description',
                      tipp: 'tipp',
                      genre: 'genre',
                      categoryId: 'categoryId',
                      titlePhoto: '');
                  service.createPhotoChallenge(user);
                }),
            StreamBuilder<List<Userdb>>(
                stream: service.readUsers(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text(
                        'Ups! Da ist etwas falsch gelaufen ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    final users = snapshot.data!;
                    return SizedBox(
                        height: 200,
                        child: ListView(
                          shrinkWrap: true,
                          children: users.map(buildUser).toList(),
                        ));
                  } else {
                    return Center(child: LoadingProgressIndicator());
                  }
                }),
            FutureBuilder<Userdb?>(
                future: service.readUser('5z8vQ3aJGG41EvTRIXDp'),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text(
                        'Ups! Es ist etwas falsch gelaufen. ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    final user = snapshot.data;
                    return user == null
                        ? Center(child: Text('No User'))
                        : buildUser(user);
                  } else {
                    return Center(child: LoadingProgressIndicator());
                  }
                }),
            IconButton(
                onPressed: () {
                  final updatedData = {'email': 'nadi@lein.de'};
                  service.updateUser('yyWXklKC2xO1BxnYA76I', updatedData);
                },
                icon: Icon(Icons.update)),
            IconButton(
                onPressed: () {
                  service.deleteUser('yyWXklKC2xO1BxnYA76I');
                },
                icon: Icon(Icons.delete)),

            /* FloatingActionButton(
                onPressed: (() async {
                  PhotoChallenge photoChallenge = PhotoChallenge(
                    title: "Test Foto!!!",
                    shortDescription: "Testi",
                    description: "blalbkadsljfsidjf",
                    tipp: "retrievedPhotoList![index].photoUrl.toString(),",
                    categoryId: "blablabla",
                  );

                  await service.addPhotoChallenge(photoChallenge);
                }),
                child: const Text(
                  "Add PhotoChallenge",
                )),
            FloatingActionButton(
                onPressed: (() async {
                  Genre genre = Genre(
                    name: "Architekturfotografie",
                  );

                  await service.addGenre(genre);
                }),
                child: const Text(
                  "Add Genre",
                )),*/

            // A button that navigates to a named route.
// The named route extracts the arguments
// by itself.
            ElevatedButton(
              onPressed: () {
                // When the user taps the button,
                // navigate to a named route and
                // provide the arguments as an optional
                // parameter.
                Navigator.pushNamed(
                  context,
                  PhotoChallengePage.routeName,
                  arguments: PhotoChallengeArguments(
                    'Extract Arguments Screen',
                  ),
                );
              },
              child: const Text('Navigate to screen that extracts arguments'),
            ),
          ],
        )));
  }
}

Widget buildUser(Userdb user) => ListTile(
    leading: CircleAvatar(child: Text('$user.name')), title: Text(user.email));
