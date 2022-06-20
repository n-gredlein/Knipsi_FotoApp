import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:fotoapp/pages/DoneChallengePage.dart';
import 'package:fotoapp/services/AuthService.dart';
import 'package:fotoapp/widgets/Button1.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';
import 'package:fotoapp/widgets/RatingCard.dart';
import '../../AppColors.dart';
import '../../datamodels/Photo.dart';
import '../../services/DatabaseService.dart';
import '../../widgets/LoadingProgressIndicator.dart';
import '../../widgets/Textfield1.dart';

DatabaseService service = DatabaseService();
AuthService authService = AuthService();
/*Future<List<Photo>>? photoList;
List<Photo>? retrievedPhotoList;

Future<void> _initRetrieval() async {
  photoList = service.retrievePhotos();
  retrievedPhotoList = await service.retrievePhotos();
}*/

class InspirationPage extends StatefulWidget {
  @override
  State<InspirationPage> createState() => _InspirationPageState();
}

class _InspirationPageState extends State<InspirationPage> {
  /*@override
  void initState() {
    super.initState();
    _initRetrieval();
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Inspiration",
              style: TextStyle(fontFamily: 'Sora-Bold', fontSize: 16)),
          backgroundColor: AppColors.backgroundColorWhite,
          foregroundColor: AppColors.textBlack,
          centerTitle: true,
          bottom: PreferredSize(
              child: Container(
                margin: EdgeInsets.all(10),
                child: Textfield1(
                  text: "Suche",
                  icon: FeatherIcons.search,
                ),
              ),
              preferredSize: Size(0, 80)),
        ),
        body: Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StreamBuilder<List<Photo>>(
                  stream: service.readPhotos(),
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
                            photoId: photos[index].id,
                          );
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
