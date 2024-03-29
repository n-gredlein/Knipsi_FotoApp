import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:fotoapp/services/AuthService.dart';
import 'package:fotoapp/services/DatabaseService.dart';
import 'package:fotoapp/widgets/RatingCard.dart';
import '../AppColors.dart';
import '../arguments/PhotoChallengeArguments.dart';
import '../datamodels/Photo.dart';
import '../widgets/LoadingProgressIndicator.dart';

DatabaseService service = DatabaseService();
AuthService authService = AuthService();

class InspoChallengePage extends StatelessWidget {
  const InspoChallengePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as PhotoChallengeArguments;

    return Scaffold(
        appBar: AppBar(
          title: Text("Inspiration",
              style: TextStyle(fontFamily: 'Sora-Bold', fontSize: 16)),
          backgroundColor: AppColors.backgroundColorWhite,
          foregroundColor: AppColors.textBlack,
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(FeatherIcons.arrowLeft),
          ),
        ),
        body: Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StreamBuilder<List<Photo>>(
                  stream:
                      service.readPhotosPhotoChallenge(args.photoChallengeId),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text(
                          'Ups! Da ist etwas falsch gelaufen ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      final photos = snapshot.data!;

                      return Expanded(
                          child: GridView.builder(
                        itemCount: photos.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                        ),
                        itemBuilder: (context, index) {
                          var r;
                          if (photos[index].ratings?[authService
                                  .getCurrentUserEmail()
                                  .replaceAll('.', '_')] ==
                              null) {
                            r = 0.0;
                          } else {
                            r = photos[index]
                                .ratings?[authService
                                    .getCurrentUserEmail()
                                    .replaceAll('.', '_')]
                                .toDouble();
                          }

                          return RatingCard(
                              imgUrl: photos[index].photoUrl.toString(),
                              rate: r,
                              photoId: photos[index].id);
                        },
                      ));
                    } else {
                      return Center(
                        child: LoadingProgressIndicator(),
                      );
                    }
                  }),
            ],
          ),
        ));
  }
}
