import 'package:flutter/material.dart';
import 'package:fotoapp/datamodels/PhotoChallenge.dart';
import 'package:fotoapp/services/AuthService.dart';
import 'package:fotoapp/services/DatabaseService.dart';
import 'package:fotoapp/widgets/PhotoCard.dart';
import '../widgets/LoadingProgressIndicator.dart';

final service = DatabaseService();
final authService = AuthService();

class SavedPage extends StatelessWidget {
  const SavedPage({Key? key}) : super(key: key);

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
                  stream: service.readSavedPhotoChallenges(
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
                                return PhotoCard(
                                  text: photoChallenge[i].title,
                                  subtext: photoChallenge[i].shortDescription,
                                  photoChallengeId: photoChallenge[i].id,
                                  saved: photoChallenge[i].usersSaved!.contains(
                                      authService.getCurrentUserEmail()),
                                  done: photoChallenge[i].usersDone!.contains(
                                      authService.getCurrentUserEmail()),
                                  imgUrl: photoChallenge[i].titlePhoto,
                                );
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
