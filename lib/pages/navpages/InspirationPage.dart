import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:fotoapp/services/AuthService.dart';
import 'package:fotoapp/widgets/RatingCard.dart';
import '../../AppColors.dart';
import '../../datamodels/Genre.dart';
import '../../datamodels/Photo.dart';
import '../../services/DatabaseService.dart';
import '../../widgets/LoadingProgressIndicator.dart';

DatabaseService service = DatabaseService();
AuthService authService = AuthService();

class InspirationPage extends StatefulWidget {
  @override
  State<InspirationPage> createState() => _InspirationPageState();
}

class _InspirationPageState extends State<InspirationPage> {
  List<String> _filters = <String>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Inspiration",
              style: TextStyle(fontFamily: 'Sora-Bold', fontSize: 16)),
          backgroundColor: AppColors.backgroundColorWhite,
          foregroundColor: AppColors.textBlack,
          centerTitle: true,
        ),
        body: Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StreamBuilder<List<Genre>>(
                  stream: service.readGenres(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text(
                          'Ups! Da ist etwas falsch gelaufen ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      final genres = snapshot.data!;
                      return Container(
                          height: 50,
                          //child: Expanded(
                          child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: genres.length,
                              itemBuilder: (context, index) {
                                return Container(
                                    margin: EdgeInsets.only(
                                        left: 10,
                                        right: 5,
                                        top: 10,
                                        bottom: 10),
                                    child: FilterChip(
                                        showCheckmark: false,
                                        label: Text(genres[index].name),

                                        // Wenn das jeweilige Genre in _filters enhalten ist, gilt der
                                        // FilterChip als „selected“
                                        selected:
                                            _filters.contains(genres[index].id),
                                        selectedColor: AppColors.primaryColor,
                                        backgroundColor:
                                            AppColors.secundaryColor,
                                        shadowColor: null,
                                        selectedShadowColor:
                                            AppColors.backgroundColorYellow,
                                        avatar: (_filters
                                                .contains(genres[index].name))
                                            ? Icon(FeatherIcons.check)
                                            : null,

                                        // Beim Tippen auf den FilterChip wird das jeweilige Genre
                                        // entweder der Liste hinzugefügt oder wieder entfernt
                                        onSelected: (bool value) {
                                          setState(() {
                                            value
                                                ? _filters.add(genres[index].id)
                                                : _filters.removeWhere(
                                                    (String name) =>
                                                        name ==
                                                        genres[index].id);
                                          });
                                        }));
                              }));
                    } else {
                      return Center(
                        child: LoadingProgressIndicator(),
                      );
                    }
                  }),
              StreamBuilder<List<Photo>>(
                  stream: _filters.isNotEmpty
                      ? service.readPhotosGenreFilter(_filters)
                      : service.readPhotos(),
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
