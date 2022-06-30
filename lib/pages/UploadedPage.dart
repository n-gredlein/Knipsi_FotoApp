import 'package:flutter/material.dart';
import 'package:fotoapp/datamodels/Photo.dart';
import 'package:fotoapp/datamodels/PhotoChallenge.dart';
import 'package:fotoapp/services/AuthService.dart';
import 'package:fotoapp/services/DatabaseService.dart';
import 'package:fotoapp/widgets/Button1.dart';
import 'package:fotoapp/widgets/DonePhotoCard.dart';
import 'package:fotoapp/widgets/PhotoCard.dart';

import '../widgets/AppBarTop.dart';
import '../widgets/LoadingProgressIndicator.dart';

final service = DatabaseService();
final authService = AuthService();

class UploadedPage extends StatelessWidget {
  const UploadedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: StreamBuilder<List<PhotoChallenge>>(
                  stream: service.readDonePhotoChallenges(
                      authService.getCurrentUserEmail()),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text(
                          'Ups! Da ist etwas falsch gelaufen ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      final photoChallenge = snapshot.data!;
                      return photoChallenge.isEmpty
                          ? Center(
                              heightFactor: 3,
                              child:
                                  Text('Keine gespeicherten Fotochallenges.'))
                          : ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: photoChallenge.length,
                              itemBuilder: (context, i) {
                                return DonePhotoCard(
                                    text: photoChallenge[i].title,
                                    subtext: photoChallenge[i].shortDescription,
                                    imgUrl: photoChallenge[i].titlePhoto,
                                    photoChallengeId: photoChallenge[i].id);
                              });
                    } else {
                      return Center(
                        child: LoadingProgressIndicator(),
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
