import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:fotoapp/AppColors.dart';
import '../../services/AuthService.dart';
import '../SavedPage.dart';
import '../StartPage.dart';
import '../UploadedPage.dart';

class UserPage extends StatelessWidget {
  AuthService authservice = AuthService();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                    onPressed: () {
                      authservice.logout();
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => StartPage()));
                    },
                    icon: Icon(FeatherIcons.logOut))
              ],
              elevation: 2,
              shadowColor: AppColors.secundaryColor,
              title: Text("Meine Fotochallenges",
                  style: TextStyle(fontFamily: 'Sora-Bold', fontSize: 16)),
              backgroundColor: AppColors.backgroundColorWhite,
              foregroundColor: AppColors.textBlack,
              centerTitle: true,
              bottom: TabBar(
                unselectedLabelColor: AppColors.textBlack,
                labelColor: AppColors.textBlack,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    color: AppColors.primaryColor),
                indicatorPadding:
                    EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
                labelStyle: TextStyle(fontFamily: 'Sora-Bold'),
                unselectedLabelStyle: TextStyle(fontFamily: 'Sora'),
                enableFeedback: false,
                tabs: [
                  Tab(
                    icon: Icon(FeatherIcons.bookmark),
                    text: "Gespeichert",
                  ),
                  Tab(icon: Icon(FeatherIcons.upload), text: "Hochgeladen")
                ],
              ),
            ),
            body: TabBarView(children: [
              Container(
                child: SavedPage(),
              ),
              Container(child: UploadedPage())
            ])));
  }
}
