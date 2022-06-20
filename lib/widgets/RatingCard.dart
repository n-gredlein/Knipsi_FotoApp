import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:fotoapp/custom_icons.dart';
import 'package:fotoapp/pages/DoneChallengePage.dart';
import 'package:fotoapp/pages/InspoChallengePage.dart';
import 'package:fotoapp/services/AuthService.dart';
import 'package:fotoapp/services/DatabaseService.dart';
import 'package:fotoapp/widgets/TextButtonIcon.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';

import '../AppColors.dart';

DatabaseService service = DatabaseService();
AuthService authService = AuthService();

class RatingCard extends StatefulWidget {
  @override
  _RatingCardState createState() => _RatingCardState();

  String imgUrl;
  double rate;
  String photoId;
  RatingCard(
      {Key? key,
      required this.imgUrl,
      required this.rate,
      required this.photoId})
      : super(key: key);
}

class _RatingCardState extends State<RatingCard>
    with SingleTickerProviderStateMixin {
  OverlayEntry? entry;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: AppColors.secundaryColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Column(children: [
        buildImage(),
        buildRating(),
      ]),
    );
  }

  Widget buildRating() {
    return Container(
      padding: EdgeInsets.all(5),
      child: Center(
          child: SmoothStarRating(
        rating: widget.rate,
        size: 30,
        color: AppColors.primaryColor,
        borderColor: AppColors.textBlack,
        filledIconData: CustomIcons.star,
        defaultIconData: FeatherIcons.star,
        starCount: 5,
        allowHalfRating: false,
        spacing: 0,
        onRatingChanged: (value) {
          setState(() {
            String email =
                authService.getCurrentUserEmail().replaceAll('.', '_');
            widget.rate = value;
            service
                .updatePhoto(widget.photoId, {'ratings.$email': widget.rate});
          });
        },
      )),
    );
  }

  Widget buildImage() {
    return GestureDetector(
      onTap: () {
        showOverlay(context);
      },
      child: Container(
        height: 135.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0)),
            image: DecorationImage(
              image: new NetworkImage(
                widget.imgUrl,
              ),
              fit: BoxFit.cover,
            )),
      ),
    );
  }

  void showOverlay(BuildContext context) {
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
              child: Container(
                  width: size.width, child: Image.network(widget.imgUrl))),
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
