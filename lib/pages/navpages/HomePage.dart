import 'package:cron/cron.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fotoapp/AppColors.dart';
import 'package:fotoapp/arguments/PhotoChallengeArguments.dart';
import 'package:fotoapp/datamodels/PhotoChallenge.dart';
import 'package:fotoapp/services/AuthService.dart';
import 'package:fotoapp/widgets/Button1.dart';
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
                  Container(
                    padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                    child: StreamBuilder<List<PhotoChallenge>>(
                        stream: service.readPhotoChallenges(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text(
                                'Ups! Es ist etwas falsch gelaufen. ${snapshot.error}');
                          } else if (snapshot.hasData) {
                            final photoChallenges = snapshot.data;

                            return photoChallenges == null
                                ? Center(child: Text('No PhotoChallenge'))
                                : StreamBuilder<List<Userdb>>(
                                    stream: service.readUser(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) {
                                        return Text(
                                            'Ups! Es ist etwas falsch gelaufen. ${snapshot.error}');
                                      } else if (snapshot.hasData) {
                                        var challengeCounter = snapshot
                                            .data![0].currentChallenge
                                            .toInt();

                                        /* if (challengeCounter >=
                                            photoChallenges.length - 1) {
                                          challengeCounter = 0;
                                        }
                                        if (photoChallenges[challengeCounter]
                                            .usersDone!
                                            .contains(authService
                                                .getCurrentUserEmail())) {
                                          challengeCounter++;
                                        }

                                        service.updateUser(
                                            authService.getCurrentUserEmail(), {
                                          'currentChallenge': challengeCounter
                                        });
*/
                                        return Column(children: [
                                          PhotoCard(
                                            text: photoChallenges[
                                                    challengeCounter]
                                                .title,
                                            subtext: photoChallenges[
                                                    challengeCounter]
                                                .shortDescription,
                                            photoChallengeId: photoChallenges[
                                                    challengeCounter]
                                                .id,
                                            saved: photoChallenges[
                                                    challengeCounter]
                                                .usersSaved!
                                                .contains(authService
                                                    .getCurrentUserEmail()),
                                            done: photoChallenges[
                                                    challengeCounter]
                                                .usersDone!
                                                .contains(authService
                                                    .getCurrentUserEmail()),
                                            imgUrl: photoChallenges[
                                                    challengeCounter]
                                                .titlePhoto,
                                          ),
                                          Container(
                                            margin: EdgeInsets.all(10),
                                            child: Button1(
                                              text:
                                                  'Fotochallenge überspringen',
                                              color: AppColors.primaryColor,
                                              onPressed: () {
                                                challengeCounter++;
                                                if (challengeCounter >=
                                                    photoChallenges.length -
                                                        1) {
                                                  challengeCounter = 0;
                                                }
                                                if (photoChallenges[
                                                        challengeCounter]
                                                    .usersDone!
                                                    .contains(authService
                                                        .getCurrentUserEmail())) {
                                                  challengeCounter++;
                                                }

                                                service.updateUser(
                                                    authService
                                                        .getCurrentUserEmail(),
                                                    {
                                                      'currentChallenge':
                                                          challengeCounter
                                                    });
                                              },
                                              width: double.infinity,
                                            ),
                                          )
                                        ]);
                                      } else {
                                        return Center(
                                          child: LoadingProgressIndicator(),
                                        );
                                      }
                                    });
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
                                                    imgUrl: photoChallenges[i]
                                                        .titlePhoto,
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
          ],
        )));
  }
}

Widget buildUser(Userdb user) => ListTile(
    leading: CircleAvatar(child: Text('$user.name')), title: Text(user.email));
